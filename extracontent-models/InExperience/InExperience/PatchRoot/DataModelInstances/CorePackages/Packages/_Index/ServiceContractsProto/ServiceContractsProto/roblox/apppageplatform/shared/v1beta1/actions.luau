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

			function t2.new(t3: {[any]: any}?) -- line: 5215
				-- upvalues: t1 (copy), t2 (copy)
				return (setmetatable({
					action_type = if t3 ~= nil and t3.action_type ~= nil then t3.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t3 ~= nil and t3.action_params ~= nil then t3.action_params else nil
				}, t2))
			end
			function t2.encode(p1) -- line: 5224
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n1 = 0

				if p1.action_type ~= nil and (p1.action_type ~= nil and p1.action_type ~= 0 or p1.action_type ~= t1.ActionType.fromNumber(0)) then
					local v177, v178 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

					buf, n1 = proto.writeVarInt(v177, v178, t1.ActionType.toNumber(p1.action_type))
				end

				if p1.action_params ~= nil then
					local v179 = p1.action_params:encode()
					local v180, v181 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

					buf, n1 = proto.writeBuffer(v180, v181, v179, buffer.len(v179))
				end

				local buf2 = buffer.create(n1)

				buffer.copy(buf2, 0, buf, 0, n1)

				return buf2
			end
			function t2.decode(p2: buffer) -- line: 5250
				-- upvalues: t2 (copy), proto (copy), t1 (copy)
				local v184 = t2.new()
				local n2 = 0

				while n2 < buffer.len(p2) do
					local v186, v187

					v186, v187, n2 = proto.readTag(p2, n2)

					if v187 == proto.wireTypes.varint then
						if v186 == 1 then
							local v188

							v188, n2 = proto.readVarIntI32(p2, n2)
							v184.action_type = t1.ActionType.fromNumber(v188) or v188
						else
							local v189

							v189, n2 = proto.readVarInt(p2, n2)
						end
					elseif v187 == proto.wireTypes.lengthDelimited then
						if v186 == 2 then
							local v190

							v190, n2 = proto.readBuffer(p2, n2)
							v184.action_params = t1.DismissDialogAction_Params.decode(v190)
						else
							local v191, v192 = proto.readVarInt(p2, n2)

							n2 = v192 + v191
						end
					elseif v187 == proto.wireTypes.i32 then
						local v193

						v193, n2 = proto.readFixed32(p2, n2)
					elseif v187 == proto.wireTypes.i64 then
						local v194

						v194, n2 = proto.readFixed64(p2, n2)
					else
						error("Unsupported wire type: " .. v187)
					end
				end

				return v184
			end
			function t2.jsonEncode(p3) -- line: 5298
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
			function t2.jsonDecode(t5: {[any]: any}) -- line: 5320
				-- upvalues: t2 (copy), t1 (copy)
				local v198 = t2.new()

				if t5.action_type ~= nil then
					v198.action_type = if typeof(t5.action_type) ~= "number" then t1.ActionType.fromName(t5.action_type) or t5.action_type else t1.ActionType.fromNumber(t5.action_type) or t5.action_type
				end

				if t5.actionType ~= nil then
					v198.action_type = if typeof(t5.actionType) ~= "number" then t1.ActionType.fromName(t5.actionType) or t5.actionType else t1.ActionType.fromNumber(t5.actionType) or t5.actionType
				end

				if t5.action_params ~= nil then
					v198.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.action_params)
				end

				if t5.actionParams ~= nil then
					v198.action_params = t1.DismissDialogAction_Params.jsonDecode(t5.actionParams)
				end

				return v198
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

			function t6.new(t7: {[any]: any}?) -- line: 5360
				-- upvalues: t6 (copy)
				return (setmetatable({
					dialog_type = if t7 ~= nil and t7.dialog_type ~= nil then t7.dialog_type else nil
				}, t6))
			end
			function t6.encode(p4) -- line: 5368
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n3 = 0

				if p4.dialog_type ~= nil then
					local v203 = p4.dialog_type:encode()
					local v204, v205 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

					buf, n3 = proto.writeBuffer(v204, v205, v203, buffer.len(v203))
				end

				local buf3 = buffer.create(n3)

				buffer.copy(buf3, 0, buf, 0, n3)

				return buf3
			end
			function t6.decode(p5: buffer) -- line: 5383
				-- upvalues: t6 (copy), proto (copy), prop_types (copy)
				local v208 = t6.new()
				local n4 = 0

				while n4 < buffer.len(p5) do
					local v210, v211

					v210, v211, n4 = proto.readTag(p5, n4)

					if v211 == proto.wireTypes.varint then
						local v212

						v212, n4 = proto.readVarInt(p5, n4)
					elseif v211 == proto.wireTypes.lengthDelimited then
						if v210 == 1 then
							local v213

							v213, n4 = proto.readBuffer(p5, n4)
							v208.dialog_type = prop_types.StringProp.decode(v213)
						else
							local v214, v215 = proto.readVarInt(p5, n4)

							n4 = v215 + v214
						end
					elseif v211 == proto.wireTypes.i32 then
						local v216

						v216, n4 = proto.readFixed32(p5, n4)
					elseif v211 == proto.wireTypes.i64 then
						local v217

						v217, n4 = proto.readFixed64(p5, n4)
					else
						error("Unsupported wire type: " .. v211)
					end
				end

				return v208
			end
			function t6.jsonEncode(p6) -- line: 5426
				local t8 = {}

				if p6.dialog_type ~= nil then
					t8.dialogType = p6.dialog_type:jsonEncode()
				end

				return t8
			end
			function t6.jsonDecode(t9: {[any]: any}) -- line: 5436
				-- upvalues: t6 (copy), prop_types (copy)
				local v221 = t6.new()

				if t9.dialog_type ~= nil then
					v221.dialog_type = prop_types.StringProp.jsonDecode(t9.dialog_type)
				end

				if t9.dialogType ~= nil then
					v221.dialog_type = prop_types.StringProp.jsonDecode(t9.dialogType)
				end

				return v221
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

			function t10.new(t11: {[any]: any}?) -- line: 5465
				-- upvalues: t1 (copy), t10 (copy)
				return (setmetatable({
					action_type = if t11 ~= nil and t11.action_type ~= nil then t11.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t11 ~= nil and t11.action_params ~= nil then t11.action_params else nil
				}, t10))
			end
			function t10.encode(p7) -- line: 5474
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n5 = 0

				if p7.action_type ~= nil and (p7.action_type ~= nil and p7.action_type ~= 0 or p7.action_type ~= t1.ActionType.fromNumber(0)) then
					local v226, v227 = proto.writeTag(buf, n5, 1, proto.wireTypes.varint)

					buf, n5 = proto.writeVarInt(v226, v227, t1.ActionType.toNumber(p7.action_type))
				end

				if p7.action_params ~= nil then
					local v228 = p7.action_params:encode()
					local v229, v230 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

					buf, n5 = proto.writeBuffer(v229, v230, v228, buffer.len(v228))
				end

				local buf4 = buffer.create(n5)

				buffer.copy(buf4, 0, buf, 0, n5)

				return buf4
			end
			function t10.decode(p8: buffer) -- line: 5500
				-- upvalues: t10 (copy), proto (copy), t1 (copy)
				local v233 = t10.new()
				local n6 = 0

				while n6 < buffer.len(p8) do
					local v235, v236

					v235, v236, n6 = proto.readTag(p8, n6)

					if v236 == proto.wireTypes.varint then
						if v235 == 1 then
							local v237

							v237, n6 = proto.readVarIntI32(p8, n6)
							v233.action_type = t1.ActionType.fromNumber(v237) or v237
						else
							local v238

							v238, n6 = proto.readVarInt(p8, n6)
						end
					elseif v236 == proto.wireTypes.lengthDelimited then
						if v235 == 2 then
							local v239

							v239, n6 = proto.readBuffer(p8, n6)
							v233.action_params = t1.LinkAction_Params.decode(v239)
						else
							local v240, v241 = proto.readVarInt(p8, n6)

							n6 = v241 + v240
						end
					elseif v236 == proto.wireTypes.i32 then
						local v242

						v242, n6 = proto.readFixed32(p8, n6)
					elseif v236 == proto.wireTypes.i64 then
						local v243

						v243, n6 = proto.readFixed64(p8, n6)
					else
						error("Unsupported wire type: " .. v236)
					end
				end

				return v233
			end
			function t10.jsonEncode(p9) -- line: 5548
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
			function t10.jsonDecode(t13: {[any]: any}) -- line: 5570
				-- upvalues: t10 (copy), t1 (copy)
				local v247 = t10.new()

				if t13.action_type ~= nil then
					v247.action_type = if typeof(t13.action_type) ~= "number" then t1.ActionType.fromName(t13.action_type) or t13.action_type else t1.ActionType.fromNumber(t13.action_type) or t13.action_type
				end

				if t13.actionType ~= nil then
					v247.action_type = if typeof(t13.actionType) ~= "number" then t1.ActionType.fromName(t13.actionType) or t13.actionType else t1.ActionType.fromNumber(t13.actionType) or t13.actionType
				end

				if t13.action_params ~= nil then
					v247.action_params = t1.LinkAction_Params.jsonDecode(t13.action_params)
				end

				if t13.actionParams ~= nil then
					v247.action_params = t1.LinkAction_Params.jsonDecode(t13.actionParams)
				end

				return v247
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

			function t14.new(t15: {[any]: any}?) -- line: 5610
				-- upvalues: t14 (copy)
				return (setmetatable({
					url = if t15 ~= nil and t15.url ~= nil then t15.url else nil,
					title_key = if t15 ~= nil and t15.title_key ~= nil then t15.title_key else nil,
					on_webview_close = if t15 ~= nil and t15.on_webview_close ~= nil then t15.on_webview_close else nil
				}, t14))
			end
			function t14.encode(p10) -- line: 5618
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n7 = 0

				if p10.url ~= nil then
					local v252 = p10.url:encode()
					local v253, v254 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v253, v254, v252, buffer.len(v252))
				end

				if p10.title_key ~= nil then
					local v255 = p10.title_key:encode()
					local v256, v257 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v256, v257, v255, buffer.len(v255))
				end

				if p10.on_webview_close ~= nil then
					local v258 = p10.on_webview_close:encode()
					local v259, v260 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

					buf, n7 = proto.writeBuffer(v259, v260, v258, buffer.len(v258))
				end

				local buf5 = buffer.create(n7)

				buffer.copy(buf5, 0, buf, 0, n7)

				return buf5
			end
			function t14.decode(p11: buffer) -- line: 5645
				-- upvalues: t14 (copy), proto (copy), prop_types (copy), t1 (copy)
				local v263 = t14.new()
				local n8 = 0

				while n8 < buffer.len(p11) do
					local v265, v266

					v265, v266, n8 = proto.readTag(p11, n8)

					if v266 == proto.wireTypes.varint then
						local v267

						v267, n8 = proto.readVarInt(p11, n8)
					elseif v266 == proto.wireTypes.lengthDelimited then
						if v265 == 1 then
							local v268

							v268, n8 = proto.readBuffer(p11, n8)
							v263.url = prop_types.StringProp.decode(v268)
						elseif v265 == 2 then
							local v269

							v269, n8 = proto.readBuffer(p11, n8)
							v263.title_key = prop_types.StringProp.decode(v269)
						elseif v265 == 4 then
							local v270

							v270, n8 = proto.readBuffer(p11, n8)
							v263.on_webview_close = t1.ActionProp.decode(v270)
						else
							local v271, v272 = proto.readVarInt(p11, n8)

							n8 = v272 + v271
						end
					elseif v266 == proto.wireTypes.i32 then
						local v273

						v273, n8 = proto.readFixed32(p11, n8)
					elseif v266 == proto.wireTypes.i64 then
						local v274

						v274, n8 = proto.readFixed64(p11, n8)
					else
						error("Unsupported wire type: " .. v266)
					end
				end

				return v263
			end
			function t14.jsonEncode(p12) -- line: 5698
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
			function t14.jsonDecode(t17: {[any]: any}) -- line: 5716
				-- upvalues: t14 (copy), prop_types (copy), t1 (copy)
				local v278 = t14.new()

				if t17.url ~= nil then
					v278.url = prop_types.StringProp.jsonDecode(t17.url)
				end

				if t17.title_key ~= nil then
					v278.title_key = prop_types.StringProp.jsonDecode(t17.title_key)
				end

				if t17.titleKey ~= nil then
					v278.title_key = prop_types.StringProp.jsonDecode(t17.titleKey)
				end

				if t17.on_webview_close ~= nil then
					v278.on_webview_close = t1.ActionProp.jsonDecode(t17.on_webview_close)
				end

				if t17.onWebviewClose ~= nil then
					v278.on_webview_close = t1.ActionProp.jsonDecode(t17.onWebviewClose)
				end

				return v278
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

			function t18.new(t19: {[any]: any}?) -- line: 5756
				-- upvalues: t1 (copy), t18 (copy)
				return (setmetatable({
					action_type = if t19 ~= nil and t19.action_type ~= nil then t19.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t19 ~= nil and t19.action_params ~= nil then t19.action_params else nil
				}, t18))
			end
			function t18.encode(p13) -- line: 5765
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n9 = 0

				if p13.action_type ~= nil and (p13.action_type ~= nil and p13.action_type ~= 0 or p13.action_type ~= t1.ActionType.fromNumber(0)) then
					local v283, v284 = proto.writeTag(buf, n9, 1, proto.wireTypes.varint)

					buf, n9 = proto.writeVarInt(v283, v284, t1.ActionType.toNumber(p13.action_type))
				end

				if p13.action_params ~= nil then
					local v285 = p13.action_params:encode()
					local v286, v287 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

					buf, n9 = proto.writeBuffer(v286, v287, v285, buffer.len(v285))
				end

				local buf6 = buffer.create(n9)

				buffer.copy(buf6, 0, buf, 0, n9)

				return buf6
			end
			function t18.decode(p14: buffer) -- line: 5791
				-- upvalues: t18 (copy), proto (copy), t1 (copy)
				local v290 = t18.new()
				local n10 = 0

				while n10 < buffer.len(p14) do
					local v292, v293

					v292, v293, n10 = proto.readTag(p14, n10)

					if v293 == proto.wireTypes.varint then
						if v292 == 1 then
							local v294

							v294, n10 = proto.readVarIntI32(p14, n10)
							v290.action_type = t1.ActionType.fromNumber(v294) or v294
						else
							local v295

							v295, n10 = proto.readVarInt(p14, n10)
						end
					elseif v293 == proto.wireTypes.lengthDelimited then
						if v292 == 2 then
							local v296

							v296, n10 = proto.readBuffer(p14, n10)
							v290.action_params = t1.OpenSocialLinkAction_Params.decode(v296)
						else
							local v297, v298 = proto.readVarInt(p14, n10)

							n10 = v298 + v297
						end
					elseif v293 == proto.wireTypes.i32 then
						local v299

						v299, n10 = proto.readFixed32(p14, n10)
					elseif v293 == proto.wireTypes.i64 then
						local v300

						v300, n10 = proto.readFixed64(p14, n10)
					else
						error("Unsupported wire type: " .. v293)
					end
				end

				return v290
			end
			function t18.jsonEncode(p15) -- line: 5839
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
			function t18.jsonDecode(t21: {[any]: any}) -- line: 5861
				-- upvalues: t18 (copy), t1 (copy)
				local v304 = t18.new()

				if t21.action_type ~= nil then
					v304.action_type = if typeof(t21.action_type) ~= "number" then t1.ActionType.fromName(t21.action_type) or t21.action_type else t1.ActionType.fromNumber(t21.action_type) or t21.action_type
				end

				if t21.actionType ~= nil then
					v304.action_type = if typeof(t21.actionType) ~= "number" then t1.ActionType.fromName(t21.actionType) or t21.actionType else t1.ActionType.fromNumber(t21.actionType) or t21.actionType
				end

				if t21.action_params ~= nil then
					v304.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.action_params)
				end

				if t21.actionParams ~= nil then
					v304.action_params = t1.OpenSocialLinkAction_Params.jsonDecode(t21.actionParams)
				end

				return v304
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

			function t22.new(t23: {[any]: any}?) -- line: 5901
				-- upvalues: t22 (copy)
				return (setmetatable({
					assignment_id = if t23 ~= nil and t23.assignment_id ~= nil then t23.assignment_id else nil,
					assignment_type = if t23 ~= nil and t23.assignment_type ~= nil then t23.assignment_type else nil,
					social_link_type = if t23 ~= nil and t23.social_link_type ~= nil then t23.social_link_type else nil,
					social_link_url = if t23 ~= nil and t23.social_link_url ~= nil then t23.social_link_url else nil,
					social_link_display_type = if t23 ~= nil and t23.social_link_display_type ~= nil then t23.social_link_display_type else nil
				}, t22))
			end
			function t22.encode(p16) -- line: 5915
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n11 = 0

				if p16.assignment_id ~= nil then
					local v309 = p16.assignment_id:encode()
					local v310, v311 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v310, v311, v309, buffer.len(v309))
				end

				if p16.assignment_type ~= nil then
					local v312 = p16.assignment_type:encode()
					local v313, v314 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v313, v314, v312, buffer.len(v312))
				end

				if p16.social_link_type ~= nil then
					local v315 = p16.social_link_type:encode()
					local v316, v317 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v316, v317, v315, buffer.len(v315))
				end

				if p16.social_link_url ~= nil then
					local v318 = p16.social_link_url:encode()
					local v319, v320 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v319, v320, v318, buffer.len(v318))
				end

				if p16.social_link_display_type ~= nil then
					local v321 = p16.social_link_display_type:encode()
					local v322, v323 = proto.writeTag(buf, n11, 5, proto.wireTypes.lengthDelimited)

					buf, n11 = proto.writeBuffer(v322, v323, v321, buffer.len(v321))
				end

				local buf7 = buffer.create(n11)

				buffer.copy(buf7, 0, buf, 0, n11)

				return buf7
			end
			function t22.decode(p17: buffer) -- line: 5954
				-- upvalues: t22 (copy), proto (copy), prop_types (copy)
				local v326 = t22.new()
				local n12 = 0

				while n12 < buffer.len(p17) do
					local v328, v329

					v328, v329, n12 = proto.readTag(p17, n12)

					if v329 == proto.wireTypes.varint then
						local v330

						v330, n12 = proto.readVarInt(p17, n12)
					elseif v329 == proto.wireTypes.lengthDelimited then
						if v328 == 1 then
							local v331

							v331, n12 = proto.readBuffer(p17, n12)
							v326.assignment_id = prop_types.StringProp.decode(v331)
						elseif v328 == 2 then
							local v332

							v332, n12 = proto.readBuffer(p17, n12)
							v326.assignment_type = prop_types.StringProp.decode(v332)
						elseif v328 == 3 then
							local v333

							v333, n12 = proto.readBuffer(p17, n12)
							v326.social_link_type = prop_types.StringProp.decode(v333)
						elseif v328 == 4 then
							local v334

							v334, n12 = proto.readBuffer(p17, n12)
							v326.social_link_url = prop_types.StringProp.decode(v334)
						elseif v328 == 5 then
							local v335

							v335, n12 = proto.readBuffer(p17, n12)
							v326.social_link_display_type = prop_types.StringProp.decode(v335)
						else
							local v336, v337 = proto.readVarInt(p17, n12)

							n12 = v337 + v336
						end
					elseif v329 == proto.wireTypes.i32 then
						local v338

						v338, n12 = proto.readFixed32(p17, n12)
					elseif v329 == proto.wireTypes.i64 then
						local v339

						v339, n12 = proto.readFixed64(p17, n12)
					else
						error("Unsupported wire type: " .. v329)
					end
				end

				return v326
			end
			function t22.jsonEncode(p18) -- line: 6018
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
			function t22.jsonDecode(t25: {[any]: any}) -- line: 6044
				-- upvalues: t22 (copy), prop_types (copy)
				local v343 = t22.new()

				if t25.assignment_id ~= nil then
					v343.assignment_id = prop_types.StringProp.jsonDecode(t25.assignment_id)
				end

				if t25.assignmentId ~= nil then
					v343.assignment_id = prop_types.StringProp.jsonDecode(t25.assignmentId)
				end

				if t25.assignment_type ~= nil then
					v343.assignment_type = prop_types.StringProp.jsonDecode(t25.assignment_type)
				end

				if t25.assignmentType ~= nil then
					v343.assignment_type = prop_types.StringProp.jsonDecode(t25.assignmentType)
				end

				if t25.social_link_type ~= nil then
					v343.social_link_type = prop_types.StringProp.jsonDecode(t25.social_link_type)
				end

				if t25.socialLinkType ~= nil then
					v343.social_link_type = prop_types.StringProp.jsonDecode(t25.socialLinkType)
				end

				if t25.social_link_url ~= nil then
					v343.social_link_url = prop_types.StringProp.jsonDecode(t25.social_link_url)
				end

				if t25.socialLinkUrl ~= nil then
					v343.social_link_url = prop_types.StringProp.jsonDecode(t25.socialLinkUrl)
				end

				if t25.social_link_display_type ~= nil then
					v343.social_link_display_type = prop_types.StringProp.jsonDecode(t25.social_link_display_type)
				end

				if t25.socialLinkDisplayType ~= nil then
					v343.social_link_display_type = prop_types.StringProp.jsonDecode(t25.socialLinkDisplayType)
				end

				return v343
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

			function t26.new(t27: {[any]: any}?) -- line: 6114
				-- upvalues: t1 (copy), t26 (copy)
				return (setmetatable({
					action_type = if t27 ~= nil and t27.action_type ~= nil then t27.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t27 ~= nil and t27.action_params ~= nil then t27.action_params else nil
				}, t26))
			end
			function t26.encode(p19) -- line: 6123
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n13 = 0

				if p19.action_type ~= nil and (p19.action_type ~= nil and p19.action_type ~= 0 or p19.action_type ~= t1.ActionType.fromNumber(0)) then
					local v348, v349 = proto.writeTag(buf, n13, 1, proto.wireTypes.varint)

					buf, n13 = proto.writeVarInt(v348, v349, t1.ActionType.toNumber(p19.action_type))
				end

				if p19.action_params ~= nil then
					local v350 = p19.action_params:encode()
					local v351, v352 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

					buf, n13 = proto.writeBuffer(v351, v352, v350, buffer.len(v350))
				end

				local buf8 = buffer.create(n13)

				buffer.copy(buf8, 0, buf, 0, n13)

				return buf8
			end
			function t26.decode(p20: buffer) -- line: 6149
				-- upvalues: t26 (copy), proto (copy), t1 (copy)
				local v355 = t26.new()
				local n14 = 0

				while n14 < buffer.len(p20) do
					local v357, v358

					v357, v358, n14 = proto.readTag(p20, n14)

					if v358 == proto.wireTypes.varint then
						if v357 == 1 then
							local v359

							v359, n14 = proto.readVarIntI32(p20, n14)
							v355.action_type = t1.ActionType.fromNumber(v359) or v359
						else
							local v360

							v360, n14 = proto.readVarInt(p20, n14)
						end
					elseif v358 == proto.wireTypes.lengthDelimited then
						if v357 == 2 then
							local v361

							v361, n14 = proto.readBuffer(p20, n14)
							v355.action_params = t1.OpenGameDetailsAction_Params.decode(v361)
						else
							local v362, v363 = proto.readVarInt(p20, n14)

							n14 = v363 + v362
						end
					elseif v358 == proto.wireTypes.i32 then
						local v364

						v364, n14 = proto.readFixed32(p20, n14)
					elseif v358 == proto.wireTypes.i64 then
						local v365

						v365, n14 = proto.readFixed64(p20, n14)
					else
						error("Unsupported wire type: " .. v358)
					end
				end

				return v355
			end
			function t26.jsonEncode(p21) -- line: 6197
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
			function t26.jsonDecode(t29: {[any]: any}) -- line: 6219
				-- upvalues: t26 (copy), t1 (copy)
				local v369 = t26.new()

				if t29.action_type ~= nil then
					v369.action_type = if typeof(t29.action_type) ~= "number" then t1.ActionType.fromName(t29.action_type) or t29.action_type else t1.ActionType.fromNumber(t29.action_type) or t29.action_type
				end

				if t29.actionType ~= nil then
					v369.action_type = if typeof(t29.actionType) ~= "number" then t1.ActionType.fromName(t29.actionType) or t29.actionType else t1.ActionType.fromNumber(t29.actionType) or t29.actionType
				end

				if t29.action_params ~= nil then
					v369.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.action_params)
				end

				if t29.actionParams ~= nil then
					v369.action_params = t1.OpenGameDetailsAction_Params.jsonDecode(t29.actionParams)
				end

				return v369
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

			function t30.new(t31: {[any]: any}?) -- line: 6259
				-- upvalues: t30 (copy)
				return (setmetatable({
					place_id = if t31 ~= nil and t31.place_id ~= nil then t31.place_id else nil,
					universe_id = if t31 ~= nil and t31.universe_id ~= nil then t31.universe_id else nil,
					inherit_referral_session = if t31 ~= nil and t31.inherit_referral_session ~= nil then t31.inherit_referral_session else nil
				}, t30))
			end
			function t30.encode(p22) -- line: 6271
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n15 = 0

				if p22.place_id ~= nil then
					local v374 = p22.place_id:encode()
					local v375, v376 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v375, v376, v374, buffer.len(v374))
				end

				if p22.universe_id ~= nil then
					local v377 = p22.universe_id:encode()
					local v378, v379 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v378, v379, v377, buffer.len(v377))
				end

				if p22.inherit_referral_session ~= nil then
					local v380 = p22.inherit_referral_session:encode()
					local v381, v382 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

					buf, n15 = proto.writeBuffer(v381, v382, v380, buffer.len(v380))
				end

				local buf9 = buffer.create(n15)

				buffer.copy(buf9, 0, buf, 0, n15)

				return buf9
			end
			function t30.decode(p23: buffer) -- line: 6298
				-- upvalues: t30 (copy), proto (copy), prop_types (copy)
				local v385 = t30.new()
				local n16 = 0

				while n16 < buffer.len(p23) do
					local v387, v388

					v387, v388, n16 = proto.readTag(p23, n16)

					if v388 == proto.wireTypes.varint then
						local v389

						v389, n16 = proto.readVarInt(p23, n16)
					elseif v388 == proto.wireTypes.lengthDelimited then
						if v387 == 1 then
							local v390

							v390, n16 = proto.readBuffer(p23, n16)
							v385.place_id = prop_types.StringProp.decode(v390)
						elseif v387 == 2 then
							local v391

							v391, n16 = proto.readBuffer(p23, n16)
							v385.universe_id = prop_types.StringProp.decode(v391)
						elseif v387 == 3 then
							local v392

							v392, n16 = proto.readBuffer(p23, n16)
							v385.inherit_referral_session = prop_types.BoolProp.decode(v392)
						else
							local v393, v394 = proto.readVarInt(p23, n16)

							n16 = v394 + v393
						end
					elseif v388 == proto.wireTypes.i32 then
						local v395

						v395, n16 = proto.readFixed32(p23, n16)
					elseif v388 == proto.wireTypes.i64 then
						local v396

						v396, n16 = proto.readFixed64(p23, n16)
					else
						error("Unsupported wire type: " .. v388)
					end
				end

				return v385
			end
			function t30.jsonEncode(p24) -- line: 6352
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
			function t30.jsonDecode(t33: {[any]: any}) -- line: 6370
				-- upvalues: t30 (copy), prop_types (copy)
				local v400 = t30.new()

				if t33.place_id ~= nil then
					v400.place_id = prop_types.StringProp.jsonDecode(t33.place_id)
				end

				if t33.placeId ~= nil then
					v400.place_id = prop_types.StringProp.jsonDecode(t33.placeId)
				end

				if t33.universe_id ~= nil then
					v400.universe_id = prop_types.StringProp.jsonDecode(t33.universe_id)
				end

				if t33.universeId ~= nil then
					v400.universe_id = prop_types.StringProp.jsonDecode(t33.universeId)
				end

				if t33.inherit_referral_session ~= nil then
					v400.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inherit_referral_session)
				end

				if t33.inheritReferralSession ~= nil then
					v400.inherit_referral_session = prop_types.BoolProp.jsonDecode(t33.inheritReferralSession)
				end

				return v400
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

			function t34.new(t35: {[any]: any}?) -- line: 6417
				-- upvalues: t1 (copy), t34 (copy)
				return (setmetatable({
					action_type = if t35 ~= nil and t35.action_type ~= nil then t35.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t35 ~= nil and t35.action_params ~= nil then t35.action_params else nil
				}, t34))
			end
			function t34.encode(p25) -- line: 6426
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n17 = 0

				if p25.action_type ~= nil and (p25.action_type ~= nil and p25.action_type ~= 0 or p25.action_type ~= t1.ActionType.fromNumber(0)) then
					local v405, v406 = proto.writeTag(buf, n17, 1, proto.wireTypes.varint)

					buf, n17 = proto.writeVarInt(v405, v406, t1.ActionType.toNumber(p25.action_type))
				end

				if p25.action_params ~= nil then
					local v407 = p25.action_params:encode()
					local v408, v409 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

					buf, n17 = proto.writeBuffer(v408, v409, v407, buffer.len(v407))
				end

				local buf10 = buffer.create(n17)

				buffer.copy(buf10, 0, buf, 0, n17)

				return buf10
			end
			function t34.decode(p26: buffer) -- line: 6452
				-- upvalues: t34 (copy), proto (copy), t1 (copy)
				local v412 = t34.new()
				local n18 = 0

				while n18 < buffer.len(p26) do
					local v414, v415

					v414, v415, n18 = proto.readTag(p26, n18)

					if v415 == proto.wireTypes.varint then
						if v414 == 1 then
							local v416

							v416, n18 = proto.readVarIntI32(p26, n18)
							v412.action_type = t1.ActionType.fromNumber(v416) or v416
						else
							local v417

							v417, n18 = proto.readVarInt(p26, n18)
						end
					elseif v415 == proto.wireTypes.lengthDelimited then
						if v414 == 2 then
							local v418

							v418, n18 = proto.readBuffer(p26, n18)
							v412.action_params = t1.OpenJoinFriendsAction_Params.decode(v418)
						else
							local v419, v420 = proto.readVarInt(p26, n18)

							n18 = v420 + v419
						end
					elseif v415 == proto.wireTypes.i32 then
						local v421

						v421, n18 = proto.readFixed32(p26, n18)
					elseif v415 == proto.wireTypes.i64 then
						local v422

						v422, n18 = proto.readFixed64(p26, n18)
					else
						error("Unsupported wire type: " .. v415)
					end
				end

				return v412
			end
			function t34.jsonEncode(p27) -- line: 6500
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
			function t34.jsonDecode(t37: {[any]: any}) -- line: 6522
				-- upvalues: t34 (copy), t1 (copy)
				local v426 = t34.new()

				if t37.action_type ~= nil then
					v426.action_type = if typeof(t37.action_type) ~= "number" then t1.ActionType.fromName(t37.action_type) or t37.action_type else t1.ActionType.fromNumber(t37.action_type) or t37.action_type
				end

				if t37.actionType ~= nil then
					v426.action_type = if typeof(t37.actionType) ~= "number" then t1.ActionType.fromName(t37.actionType) or t37.actionType else t1.ActionType.fromNumber(t37.actionType) or t37.actionType
				end

				if t37.action_params ~= nil then
					v426.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.action_params)
				end

				if t37.actionParams ~= nil then
					v426.action_params = t1.OpenJoinFriendsAction_Params.jsonDecode(t37.actionParams)
				end

				return v426
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

			function t38.new(t39: {[any]: any}?) -- line: 6562
				-- upvalues: t38 (copy)
				return (setmetatable({
					place_id = if t39 ~= nil and t39.place_id ~= nil then t39.place_id else nil,
					universe_id = if t39 ~= nil and t39.universe_id ~= nil then t39.universe_id else nil
				}, t38))
			end
			function t38.encode(p28) -- line: 6571
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n19 = 0

				if p28.place_id ~= nil then
					local v431 = p28.place_id:encode()
					local v432, v433 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v432, v433, v431, buffer.len(v431))
				end

				if p28.universe_id ~= nil then
					local v434 = p28.universe_id:encode()
					local v435, v436 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

					buf, n19 = proto.writeBuffer(v435, v436, v434, buffer.len(v434))
				end

				local buf11 = buffer.create(n19)

				buffer.copy(buf11, 0, buf, 0, n19)

				return buf11
			end
			function t38.decode(p29: buffer) -- line: 6592
				-- upvalues: t38 (copy), proto (copy), prop_types (copy)
				local v439 = t38.new()
				local n20 = 0

				while n20 < buffer.len(p29) do
					local v441, v442

					v441, v442, n20 = proto.readTag(p29, n20)

					if v442 == proto.wireTypes.varint then
						local v443

						v443, n20 = proto.readVarInt(p29, n20)
					elseif v442 == proto.wireTypes.lengthDelimited then
						if v441 == 1 then
							local v444

							v444, n20 = proto.readBuffer(p29, n20)
							v439.place_id = prop_types.StringProp.decode(v444)
						elseif v441 == 2 then
							local v445

							v445, n20 = proto.readBuffer(p29, n20)
							v439.universe_id = prop_types.StringProp.decode(v445)
						else
							local v446, v447 = proto.readVarInt(p29, n20)

							n20 = v447 + v446
						end
					elseif v442 == proto.wireTypes.i32 then
						local v448

						v448, n20 = proto.readFixed32(p29, n20)
					elseif v442 == proto.wireTypes.i64 then
						local v449

						v449, n20 = proto.readFixed64(p29, n20)
					else
						error("Unsupported wire type: " .. v442)
					end
				end

				return v439
			end
			function t38.jsonEncode(p30) -- line: 6640
				local t40 = {}

				if p30.place_id ~= nil then
					t40.placeId = p30.place_id:jsonEncode()
				end

				if p30.universe_id ~= nil then
					t40.universeId = p30.universe_id:jsonEncode()
				end

				return t40
			end
			function t38.jsonDecode(t41: {[any]: any}) -- line: 6654
				-- upvalues: t38 (copy), prop_types (copy)
				local v453 = t38.new()

				if t41.place_id ~= nil then
					v453.place_id = prop_types.StringProp.jsonDecode(t41.place_id)
				end

				if t41.placeId ~= nil then
					v453.place_id = prop_types.StringProp.jsonDecode(t41.placeId)
				end

				if t41.universe_id ~= nil then
					v453.universe_id = prop_types.StringProp.jsonDecode(t41.universe_id)
				end

				if t41.universeId ~= nil then
					v453.universe_id = prop_types.StringProp.jsonDecode(t41.universeId)
				end

				return v453
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

			function t42.new(t43: {[any]: any}?) -- line: 6691
				-- upvalues: t1 (copy), t42 (copy)
				return (setmetatable({
					action_type = if t43 ~= nil and t43.action_type ~= nil then t43.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t43 ~= nil and t43.action_params ~= nil then t43.action_params else nil
				}, t42))
			end
			function t42.encode(p31) -- line: 6702
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n21 = 0

				if p31.action_type ~= nil and (p31.action_type ~= nil and p31.action_type ~= 0 or p31.action_type ~= t1.ActionType.fromNumber(0)) then
					local v458, v459 = proto.writeTag(buf, n21, 1, proto.wireTypes.varint)

					buf, n21 = proto.writeVarInt(v458, v459, t1.ActionType.toNumber(p31.action_type))
				end

				if p31.action_params ~= nil then
					local v460 = p31.action_params:encode()
					local v461, v462 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

					buf, n21 = proto.writeBuffer(v461, v462, v460, buffer.len(v460))
				end

				local buf12 = buffer.create(n21)

				buffer.copy(buf12, 0, buf, 0, n21)

				return buf12
			end
			function t42.decode(p32: buffer) -- line: 6728
				-- upvalues: t42 (copy), proto (copy), t1 (copy)
				local v465 = t42.new()
				local n22 = 0

				while n22 < buffer.len(p32) do
					local v467, v468

					v467, v468, n22 = proto.readTag(p32, n22)

					if v468 == proto.wireTypes.varint then
						if v467 == 1 then
							local v469

							v469, n22 = proto.readVarIntI32(p32, n22)
							v465.action_type = t1.ActionType.fromNumber(v469) or v469
						else
							local v470

							v470, n22 = proto.readVarInt(p32, n22)
						end
					elseif v468 == proto.wireTypes.lengthDelimited then
						if v467 == 2 then
							local v471

							v471, n22 = proto.readBuffer(p32, n22)
							v465.action_params = t1.OpenMarketplaceTryOnAction_Params.decode(v471)
						else
							local v472, v473 = proto.readVarInt(p32, n22)

							n22 = v473 + v472
						end
					elseif v468 == proto.wireTypes.i32 then
						local v474

						v474, n22 = proto.readFixed32(p32, n22)
					elseif v468 == proto.wireTypes.i64 then
						local v475

						v475, n22 = proto.readFixed64(p32, n22)
					else
						error("Unsupported wire type: " .. v468)
					end
				end

				return v465
			end
			function t42.jsonEncode(p33) -- line: 6776
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
			function t42.jsonDecode(t45: {[any]: any}) -- line: 6798
				-- upvalues: t42 (copy), t1 (copy)
				local v479 = t42.new()

				if t45.action_type ~= nil then
					v479.action_type = if typeof(t45.action_type) ~= "number" then t1.ActionType.fromName(t45.action_type) or t45.action_type else t1.ActionType.fromNumber(t45.action_type) or t45.action_type
				end

				if t45.actionType ~= nil then
					v479.action_type = if typeof(t45.actionType) ~= "number" then t1.ActionType.fromName(t45.actionType) or t45.actionType else t1.ActionType.fromNumber(t45.actionType) or t45.actionType
				end

				if t45.action_params ~= nil then
					v479.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.action_params)
				end

				if t45.actionParams ~= nil then
					v479.action_params = t1.OpenMarketplaceTryOnAction_Params.jsonDecode(t45.actionParams)
				end

				return v479
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

			function t46.new(t47: {[any]: any}?) -- line: 6838
				-- upvalues: t46 (copy)
				return (setmetatable({
					item_id = if t47 ~= nil and t47.item_id ~= nil then t47.item_id else nil,
					item_type = if t47 ~= nil and t47.item_type ~= nil then t47.item_type else nil,
					item_sub_type_name = if t47 ~= nil and t47.item_sub_type_name ~= nil then t47.item_sub_type_name else nil
				}, t46))
			end
			function t46.encode(p34) -- line: 6848
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n23 = 0

				if p34.item_id ~= nil then
					local v484 = p34.item_id:encode()
					local v485, v486 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v485, v486, v484, buffer.len(v484))
				end

				if p34.item_type ~= nil then
					local v487 = p34.item_type:encode()
					local v488, v489 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v488, v489, v487, buffer.len(v487))
				end

				if p34.item_sub_type_name ~= nil then
					local v490 = p34.item_sub_type_name:encode()
					local v491, v492 = proto.writeTag(buf, n23, 3, proto.wireTypes.lengthDelimited)

					buf, n23 = proto.writeBuffer(v491, v492, v490, buffer.len(v490))
				end

				local buf13 = buffer.create(n23)

				buffer.copy(buf13, 0, buf, 0, n23)

				return buf13
			end
			function t46.decode(p35: buffer) -- line: 6875
				-- upvalues: t46 (copy), proto (copy), prop_types (copy)
				local v495 = t46.new()
				local n24 = 0

				while n24 < buffer.len(p35) do
					local v497, v498

					v497, v498, n24 = proto.readTag(p35, n24)

					if v498 == proto.wireTypes.varint then
						local v499

						v499, n24 = proto.readVarInt(p35, n24)
					elseif v498 == proto.wireTypes.lengthDelimited then
						if v497 == 1 then
							local v500

							v500, n24 = proto.readBuffer(p35, n24)
							v495.item_id = prop_types.StringProp.decode(v500)
						elseif v497 == 2 then
							local v501

							v501, n24 = proto.readBuffer(p35, n24)
							v495.item_type = prop_types.StringProp.decode(v501)
						elseif v497 == 3 then
							local v502

							v502, n24 = proto.readBuffer(p35, n24)
							v495.item_sub_type_name = prop_types.StringProp.decode(v502)
						else
							local v503, v504 = proto.readVarInt(p35, n24)

							n24 = v504 + v503
						end
					elseif v498 == proto.wireTypes.i32 then
						local v505

						v505, n24 = proto.readFixed32(p35, n24)
					elseif v498 == proto.wireTypes.i64 then
						local v506

						v506, n24 = proto.readFixed64(p35, n24)
					else
						error("Unsupported wire type: " .. v498)
					end
				end

				return v495
			end
			function t46.jsonEncode(p36) -- line: 6928
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
			function t46.jsonDecode(t49: {[any]: any}) -- line: 6946
				-- upvalues: t46 (copy), prop_types (copy)
				local v510 = t46.new()

				if t49.item_id ~= nil then
					v510.item_id = prop_types.StringProp.jsonDecode(t49.item_id)
				end

				if t49.itemId ~= nil then
					v510.item_id = prop_types.StringProp.jsonDecode(t49.itemId)
				end

				if t49.item_type ~= nil then
					v510.item_type = prop_types.StringProp.jsonDecode(t49.item_type)
				end

				if t49.itemType ~= nil then
					v510.item_type = prop_types.StringProp.jsonDecode(t49.itemType)
				end

				if t49.item_sub_type_name ~= nil then
					v510.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.item_sub_type_name)
				end

				if t49.itemSubTypeName ~= nil then
					v510.item_sub_type_name = prop_types.StringProp.jsonDecode(t49.itemSubTypeName)
				end

				return v510
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

			function t50.new(t51: {[any]: any}?) -- line: 6994
				-- upvalues: t1 (copy), t50 (copy)
				return (setmetatable({
					action_type = if t51 ~= nil and t51.action_type ~= nil then t51.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t51 ~= nil and t51.action_params ~= nil then t51.action_params else nil
				}, t50))
			end
			function t50.encode(p37) -- line: 7003
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n25 = 0

				if p37.action_type ~= nil and (p37.action_type ~= nil and p37.action_type ~= 0 or p37.action_type ~= t1.ActionType.fromNumber(0)) then
					local v515, v516 = proto.writeTag(buf, n25, 1, proto.wireTypes.varint)

					buf, n25 = proto.writeVarInt(v515, v516, t1.ActionType.toNumber(p37.action_type))
				end

				if p37.action_params ~= nil then
					local v517 = p37.action_params:encode()
					local v518, v519 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

					buf, n25 = proto.writeBuffer(v518, v519, v517, buffer.len(v517))
				end

				local buf14 = buffer.create(n25)

				buffer.copy(buf14, 0, buf, 0, n25)

				return buf14
			end
			function t50.decode(p38: buffer) -- line: 7029
				-- upvalues: t50 (copy), proto (copy), t1 (copy)
				local v522 = t50.new()
				local n26 = 0

				while n26 < buffer.len(p38) do
					local v524, v525

					v524, v525, n26 = proto.readTag(p38, n26)

					if v525 == proto.wireTypes.varint then
						if v524 == 1 then
							local v526

							v526, n26 = proto.readVarIntI32(p38, n26)
							v522.action_type = t1.ActionType.fromNumber(v526) or v526
						else
							local v527

							v527, n26 = proto.readVarInt(p38, n26)
						end
					elseif v525 == proto.wireTypes.lengthDelimited then
						if v524 == 2 then
							local v528

							v528, n26 = proto.readBuffer(p38, n26)
							v522.action_params = t1.OpenSeeAllAction_Params.decode(v528)
						else
							local v529, v530 = proto.readVarInt(p38, n26)

							n26 = v530 + v529
						end
					elseif v525 == proto.wireTypes.i32 then
						local v531

						v531, n26 = proto.readFixed32(p38, n26)
					elseif v525 == proto.wireTypes.i64 then
						local v532

						v532, n26 = proto.readFixed64(p38, n26)
					else
						error("Unsupported wire type: " .. v525)
					end
				end

				return v522
			end
			function t50.jsonEncode(p39) -- line: 7077
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
			function t50.jsonDecode(t53: {[any]: any}) -- line: 7099
				-- upvalues: t50 (copy), t1 (copy)
				local v536 = t50.new()

				if t53.action_type ~= nil then
					v536.action_type = if typeof(t53.action_type) ~= "number" then t1.ActionType.fromName(t53.action_type) or t53.action_type else t1.ActionType.fromNumber(t53.action_type) or t53.action_type
				end

				if t53.actionType ~= nil then
					v536.action_type = if typeof(t53.actionType) ~= "number" then t1.ActionType.fromName(t53.actionType) or t53.actionType else t1.ActionType.fromNumber(t53.actionType) or t53.actionType
				end

				if t53.action_params ~= nil then
					v536.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.action_params)
				end

				if t53.actionParams ~= nil then
					v536.action_params = t1.OpenSeeAllAction_Params.jsonDecode(t53.actionParams)
				end

				return v536
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

			function t54.new(t55: {[any]: any}?) -- line: 7139
				-- upvalues: t54 (copy)
				return (setmetatable({
					collection_id = if t55 ~= nil and t55.collection_id ~= nil then t55.collection_id else nil,
					game_set_target_id = if t55 ~= nil and t55.game_set_target_id ~= nil then t55.game_set_target_id else nil,
					collection_position = if t55 ~= nil and t55.collection_position ~= nil then t55.collection_position else nil
				}, t54))
			end
			function t54.encode(p40) -- line: 7149
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n27 = 0

				if p40.collection_id ~= nil then
					local v541 = p40.collection_id:encode()
					local v542, v543 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v542, v543, v541, buffer.len(v541))
				end

				if p40.game_set_target_id ~= nil then
					local v544 = p40.game_set_target_id:encode()
					local v545, v546 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v545, v546, v544, buffer.len(v544))
				end

				if p40.collection_position ~= nil then
					local v547 = p40.collection_position:encode()
					local v548, v549 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

					buf, n27 = proto.writeBuffer(v548, v549, v547, buffer.len(v547))
				end

				local buf15 = buffer.create(n27)

				buffer.copy(buf15, 0, buf, 0, n27)

				return buf15
			end
			function t54.decode(p41: buffer) -- line: 7176
				-- upvalues: t54 (copy), proto (copy), prop_types (copy)
				local v552 = t54.new()
				local n28 = 0

				while n28 < buffer.len(p41) do
					local v554, v555

					v554, v555, n28 = proto.readTag(p41, n28)

					if v555 == proto.wireTypes.varint then
						local v556

						v556, n28 = proto.readVarInt(p41, n28)
					elseif v555 == proto.wireTypes.lengthDelimited then
						if v554 == 1 then
							local v557

							v557, n28 = proto.readBuffer(p41, n28)
							v552.collection_id = prop_types.StringProp.decode(v557)
						elseif v554 == 2 then
							local v558

							v558, n28 = proto.readBuffer(p41, n28)
							v552.game_set_target_id = prop_types.StringProp.decode(v558)
						elseif v554 == 3 then
							local v559

							v559, n28 = proto.readBuffer(p41, n28)
							v552.collection_position = prop_types.StringProp.decode(v559)
						else
							local v560, v561 = proto.readVarInt(p41, n28)

							n28 = v561 + v560
						end
					elseif v555 == proto.wireTypes.i32 then
						local v562

						v562, n28 = proto.readFixed32(p41, n28)
					elseif v555 == proto.wireTypes.i64 then
						local v563

						v563, n28 = proto.readFixed64(p41, n28)
					else
						error("Unsupported wire type: " .. v555)
					end
				end

				return v552
			end
			function t54.jsonEncode(p42) -- line: 7230
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
			function t54.jsonDecode(t57: {[any]: any}) -- line: 7248
				-- upvalues: t54 (copy), prop_types (copy)
				local v567 = t54.new()

				if t57.collection_id ~= nil then
					v567.collection_id = prop_types.StringProp.jsonDecode(t57.collection_id)
				end

				if t57.collectionId ~= nil then
					v567.collection_id = prop_types.StringProp.jsonDecode(t57.collectionId)
				end

				if t57.game_set_target_id ~= nil then
					v567.game_set_target_id = prop_types.StringProp.jsonDecode(t57.game_set_target_id)
				end

				if t57.gameSetTargetId ~= nil then
					v567.game_set_target_id = prop_types.StringProp.jsonDecode(t57.gameSetTargetId)
				end

				if t57.collection_position ~= nil then
					v567.collection_position = prop_types.StringProp.jsonDecode(t57.collection_position)
				end

				if t57.collectionPosition ~= nil then
					v567.collection_position = prop_types.StringProp.jsonDecode(t57.collectionPosition)
				end

				return v567
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

			function t58.new(t59: {[any]: any}?) -- line: 7298
				-- upvalues: t1 (copy), t58 (copy)
				return (setmetatable({
					action_type = if t59 ~= nil and t59.action_type ~= nil then t59.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t59 ~= nil and t59.action_params ~= nil then t59.action_params else nil
				}, t58))
			end
			function t58.encode(p43) -- line: 7309
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n29 = 0

				if p43.action_type ~= nil and (p43.action_type ~= nil and p43.action_type ~= 0 or p43.action_type ~= t1.ActionType.fromNumber(0)) then
					local v572, v573 = proto.writeTag(buf, n29, 1, proto.wireTypes.varint)

					buf, n29 = proto.writeVarInt(v572, v573, t1.ActionType.toNumber(p43.action_type))
				end

				if p43.action_params ~= nil then
					local v574 = p43.action_params:encode()
					local v575, v576 = proto.writeTag(buf, n29, 2, proto.wireTypes.lengthDelimited)

					buf, n29 = proto.writeBuffer(v575, v576, v574, buffer.len(v574))
				end

				local buf16 = buffer.create(n29)

				buffer.copy(buf16, 0, buf, 0, n29)

				return buf16
			end
			function t58.decode(p44: buffer) -- line: 7335
				-- upvalues: t58 (copy), proto (copy), t1 (copy)
				local v579 = t58.new()
				local n30 = 0

				while n30 < buffer.len(p44) do
					local v581, v582

					v581, v582, n30 = proto.readTag(p44, n30)

					if v582 == proto.wireTypes.varint then
						if v581 == 1 then
							local v583

							v583, n30 = proto.readVarIntI32(p44, n30)
							v579.action_type = t1.ActionType.fromNumber(v583) or v583
						else
							local v584

							v584, n30 = proto.readVarInt(p44, n30)
						end
					elseif v582 == proto.wireTypes.lengthDelimited then
						if v581 == 2 then
							local v585

							v585, n30 = proto.readBuffer(p44, n30)
							v579.action_params = t1.OpenSponsoredTooltipAction_Params.decode(v585)
						else
							local v586, v587 = proto.readVarInt(p44, n30)

							n30 = v587 + v586
						end
					elseif v582 == proto.wireTypes.i32 then
						local v588

						v588, n30 = proto.readFixed32(p44, n30)
					elseif v582 == proto.wireTypes.i64 then
						local v589

						v589, n30 = proto.readFixed64(p44, n30)
					else
						error("Unsupported wire type: " .. v582)
					end
				end

				return v579
			end
			function t58.jsonEncode(p45) -- line: 7383
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
			function t58.jsonDecode(t61: {[any]: any}) -- line: 7405
				-- upvalues: t58 (copy), t1 (copy)
				local v593 = t58.new()

				if t61.action_type ~= nil then
					v593.action_type = if typeof(t61.action_type) ~= "number" then t1.ActionType.fromName(t61.action_type) or t61.action_type else t1.ActionType.fromNumber(t61.action_type) or t61.action_type
				end

				if t61.actionType ~= nil then
					v593.action_type = if typeof(t61.actionType) ~= "number" then t1.ActionType.fromName(t61.actionType) or t61.actionType else t1.ActionType.fromNumber(t61.actionType) or t61.actionType
				end

				if t61.action_params ~= nil then
					v593.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.action_params)
				end

				if t61.actionParams ~= nil then
					v593.action_params = t1.OpenSponsoredTooltipAction_Params.jsonDecode(t61.actionParams)
				end

				return v593
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

			function t62.new(_: {[any]: any}?) -- line: 7445
				-- upvalues: t62 (copy)
				return (setmetatable({}, t62))
			end
			function t62.encode(_) -- line: 7451
				local buf = buffer.create(0)
				local buf17 = buffer.create(0)

				buffer.copy(buf17, 0, buf, 0, 0)

				return buf17
			end
			function t62.decode(p47: buffer) -- line: 7460
				-- upvalues: t62 (copy), proto (copy)
				local v599 = t62.new()
				local n31 = 0

				while n31 < buffer.len(p47) do
					local v601, v602

					v601, v602, n31 = proto.readTag(p47, n31)

					if v602 == proto.wireTypes.varint then
						local v603

						v603, n31 = proto.readVarInt(p47, n31)
					elseif v602 == proto.wireTypes.lengthDelimited then
						local v604, v605 = proto.readVarInt(p47, n31)

						n31 = v605 + v604
					elseif v602 == proto.wireTypes.i32 then
						local v606

						v606, n31 = proto.readFixed32(p47, n31)
					elseif v602 == proto.wireTypes.i64 then
						local v607

						v607, n31 = proto.readFixed64(p47, n31)
					else
						error("Unsupported wire type: " .. v602)
					end
				end

				return v599
			end
			function t62.jsonEncode(_) -- line: 7498
				return {}
			end
			function t62.jsonDecode(_: {[any]: any}) -- line: 7504
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

			function t65.new(t66: {[any]: any}?) -- line: 7526
				-- upvalues: t1 (copy), t65 (copy)
				return (setmetatable({
					action_type = if t66 ~= nil and t66.action_type ~= nil then t66.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t66 ~= nil and t66.action_params ~= nil then t66.action_params else nil
				}, t65))
			end
			function t65.encode(p49) -- line: 7535
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n32 = 0

				if p49.action_type ~= nil and (p49.action_type ~= nil and p49.action_type ~= 0 or p49.action_type ~= t1.ActionType.fromNumber(0)) then
					local v614, v615 = proto.writeTag(buf, n32, 1, proto.wireTypes.varint)

					buf, n32 = proto.writeVarInt(v614, v615, t1.ActionType.toNumber(p49.action_type))
				end

				if p49.action_params ~= nil then
					local v616 = p49.action_params:encode()
					local v617, v618 = proto.writeTag(buf, n32, 2, proto.wireTypes.lengthDelimited)

					buf, n32 = proto.writeBuffer(v617, v618, v616, buffer.len(v616))
				end

				local buf18 = buffer.create(n32)

				buffer.copy(buf18, 0, buf, 0, n32)

				return buf18
			end
			function t65.decode(p50: buffer) -- line: 7561
				-- upvalues: t65 (copy), proto (copy), t1 (copy)
				local v621 = t65.new()
				local n33 = 0

				while n33 < buffer.len(p50) do
					local v623, v624

					v623, v624, n33 = proto.readTag(p50, n33)

					if v624 == proto.wireTypes.varint then
						if v623 == 1 then
							local v625

							v625, n33 = proto.readVarIntI32(p50, n33)
							v621.action_type = t1.ActionType.fromNumber(v625) or v625
						else
							local v626

							v626, n33 = proto.readVarInt(p50, n33)
						end
					elseif v624 == proto.wireTypes.lengthDelimited then
						if v623 == 2 then
							local v627

							v627, n33 = proto.readBuffer(p50, n33)
							v621.action_params = t1.PlayButtonClickAction_Params.decode(v627)
						else
							local v628, v629 = proto.readVarInt(p50, n33)

							n33 = v629 + v628
						end
					elseif v624 == proto.wireTypes.i32 then
						local v630

						v630, n33 = proto.readFixed32(p50, n33)
					elseif v624 == proto.wireTypes.i64 then
						local v631

						v631, n33 = proto.readFixed64(p50, n33)
					else
						error("Unsupported wire type: " .. v624)
					end
				end

				return v621
			end
			function t65.jsonEncode(p51) -- line: 7609
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
			function t65.jsonDecode(t68: {[any]: any}) -- line: 7631
				-- upvalues: t65 (copy), t1 (copy)
				local v635 = t65.new()

				if t68.action_type ~= nil then
					v635.action_type = if typeof(t68.action_type) ~= "number" then t1.ActionType.fromName(t68.action_type) or t68.action_type else t1.ActionType.fromNumber(t68.action_type) or t68.action_type
				end

				if t68.actionType ~= nil then
					v635.action_type = if typeof(t68.actionType) ~= "number" then t1.ActionType.fromName(t68.actionType) or t68.actionType else t1.ActionType.fromNumber(t68.actionType) or t68.actionType
				end

				if t68.action_params ~= nil then
					v635.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.action_params)
				end

				if t68.actionParams ~= nil then
					v635.action_params = t1.PlayButtonClickAction_Params.jsonDecode(t68.actionParams)
				end

				return v635
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

			function t69.new(_: {[any]: any}?) -- line: 7671
				-- upvalues: t69 (copy)
				return (setmetatable({}, t69))
			end
			function t69.encode(_) -- line: 7677
				local buf = buffer.create(0)
				local buf19 = buffer.create(0)

				buffer.copy(buf19, 0, buf, 0, 0)

				return buf19
			end
			function t69.decode(p53: buffer) -- line: 7686
				-- upvalues: t69 (copy), proto (copy)
				local v641 = t69.new()
				local n34 = 0

				while n34 < buffer.len(p53) do
					local v643, v644

					v643, v644, n34 = proto.readTag(p53, n34)

					if v644 == proto.wireTypes.varint then
						local v645

						v645, n34 = proto.readVarInt(p53, n34)
					elseif v644 == proto.wireTypes.lengthDelimited then
						local v646, v647 = proto.readVarInt(p53, n34)

						n34 = v647 + v646
					elseif v644 == proto.wireTypes.i32 then
						local v648

						v648, n34 = proto.readFixed32(p53, n34)
					elseif v644 == proto.wireTypes.i64 then
						local v649

						v649, n34 = proto.readFixed64(p53, n34)
					else
						error("Unsupported wire type: " .. v644)
					end
				end

				return v641
			end
			function t69.jsonEncode(_) -- line: 7724
				return {}
			end
			function t69.jsonDecode(_: {[any]: any}) -- line: 7730
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

			function t72.new(t73: {[any]: any}?) -- line: 7750
				-- upvalues: t1 (copy), t72 (copy)
				return (setmetatable({
					action_type = if t73 ~= nil and t73.action_type ~= nil then t73.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t73 ~= nil and t73.action_params ~= nil then t73.action_params else nil
				}, t72))
			end
			function t72.encode(p55) -- line: 7759
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n35 = 0

				if p55.action_type ~= nil and (p55.action_type ~= nil and p55.action_type ~= 0 or p55.action_type ~= t1.ActionType.fromNumber(0)) then
					local v656, v657 = proto.writeTag(buf, n35, 1, proto.wireTypes.varint)

					buf, n35 = proto.writeVarInt(v656, v657, t1.ActionType.toNumber(p55.action_type))
				end

				if p55.action_params ~= nil then
					local v658 = p55.action_params:encode()
					local v659, v660 = proto.writeTag(buf, n35, 2, proto.wireTypes.lengthDelimited)

					buf, n35 = proto.writeBuffer(v659, v660, v658, buffer.len(v658))
				end

				local buf20 = buffer.create(n35)

				buffer.copy(buf20, 0, buf, 0, n35)

				return buf20
			end
			function t72.decode(p56: buffer) -- line: 7785
				-- upvalues: t72 (copy), proto (copy), t1 (copy)
				local v663 = t72.new()
				local n36 = 0

				while n36 < buffer.len(p56) do
					local v665, v666

					v665, v666, n36 = proto.readTag(p56, n36)

					if v666 == proto.wireTypes.varint then
						if v665 == 1 then
							local v667

							v667, n36 = proto.readVarIntI32(p56, n36)
							v663.action_type = t1.ActionType.fromNumber(v667) or v667
						else
							local v668

							v668, n36 = proto.readVarInt(p56, n36)
						end
					elseif v666 == proto.wireTypes.lengthDelimited then
						if v665 == 2 then
							local v669

							v669, n36 = proto.readBuffer(p56, n36)
							v663.action_params = t1.UpdateUserSettingsAction_Params.decode(v669)
						else
							local v670, v671 = proto.readVarInt(p56, n36)

							n36 = v671 + v670
						end
					elseif v666 == proto.wireTypes.i32 then
						local v672

						v672, n36 = proto.readFixed32(p56, n36)
					elseif v666 == proto.wireTypes.i64 then
						local v673

						v673, n36 = proto.readFixed64(p56, n36)
					else
						error("Unsupported wire type: " .. v666)
					end
				end

				return v663
			end
			function t72.jsonEncode(p57) -- line: 7833
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
			function t72.jsonDecode(t75: {[any]: any}) -- line: 7855
				-- upvalues: t72 (copy), t1 (copy)
				local v677 = t72.new()

				if t75.action_type ~= nil then
					v677.action_type = if typeof(t75.action_type) ~= "number" then t1.ActionType.fromName(t75.action_type) or t75.action_type else t1.ActionType.fromNumber(t75.action_type) or t75.action_type
				end

				if t75.actionType ~= nil then
					v677.action_type = if typeof(t75.actionType) ~= "number" then t1.ActionType.fromName(t75.actionType) or t75.actionType else t1.ActionType.fromNumber(t75.actionType) or t75.actionType
				end

				if t75.action_params ~= nil then
					v677.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.action_params)
				end

				if t75.actionParams ~= nil then
					v677.action_params = t1.UpdateUserSettingsAction_Params.jsonDecode(t75.actionParams)
				end

				return v677
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

			function t76.new(t77: {[any]: any}?) -- line: 7895
				-- upvalues: t76 (copy)
				return (setmetatable({
					settings = if t77 ~= nil and t77.settings ~= nil then t77.settings else nil,
					audit_data = if t77 ~= nil and t77.audit_data ~= nil then t77.audit_data else nil
				}, t76))
			end
			function t76.encode(p58) -- line: 7904
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n37 = 0

				if p58.settings ~= nil then
					local v682 = p58.settings:encode()
					local v683, v684 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v683, v684, v682, buffer.len(v682))
				end

				if p58.audit_data ~= nil then
					local v685 = p58.audit_data:encode()
					local v686, v687 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

					buf, n37 = proto.writeBuffer(v686, v687, v685, buffer.len(v685))
				end

				local buf21 = buffer.create(n37)

				buffer.copy(buf21, 0, buf, 0, n37)

				return buf21
			end
			function t76.decode(p59: buffer) -- line: 7925
				-- upvalues: t76 (copy), proto (copy), prop_types (copy)
				local v690 = t76.new()
				local n38 = 0

				while n38 < buffer.len(p59) do
					local v692, v693

					v692, v693, n38 = proto.readTag(p59, n38)

					if v693 == proto.wireTypes.varint then
						local v694

						v694, n38 = proto.readVarInt(p59, n38)
					elseif v693 == proto.wireTypes.lengthDelimited then
						if v692 == 1 then
							local v695

							v695, n38 = proto.readBuffer(p59, n38)
							v690.settings = prop_types.StructProp.decode(v695)
						elseif v692 == 2 then
							local v696

							v696, n38 = proto.readBuffer(p59, n38)
							v690.audit_data = prop_types.StringProp.decode(v696)
						else
							local v697, v698 = proto.readVarInt(p59, n38)

							n38 = v698 + v697
						end
					elseif v693 == proto.wireTypes.i32 then
						local v699

						v699, n38 = proto.readFixed32(p59, n38)
					elseif v693 == proto.wireTypes.i64 then
						local v700

						v700, n38 = proto.readFixed64(p59, n38)
					else
						error("Unsupported wire type: " .. v693)
					end
				end

				return v690
			end
			function t76.jsonEncode(p60) -- line: 7973
				local t78 = {}

				if p60.settings ~= nil then
					t78.settings = p60.settings:jsonEncode()
				end

				if p60.audit_data ~= nil then
					t78.auditData = p60.audit_data:jsonEncode()
				end

				return t78
			end
			function t76.jsonDecode(t79: {[any]: any}) -- line: 7987
				-- upvalues: t76 (copy), prop_types (copy)
				local v704 = t76.new()

				if t79.settings ~= nil then
					v704.settings = prop_types.StructProp.jsonDecode(t79.settings)
				end

				if t79.audit_data ~= nil then
					v704.audit_data = prop_types.StringProp.jsonDecode(t79.audit_data)
				end

				if t79.auditData ~= nil then
					v704.audit_data = prop_types.StringProp.jsonDecode(t79.auditData)
				end

				return v704
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

			function t80.new(t81: {[any]: any}?) -- line: 8019
				-- upvalues: t1 (copy), t80 (copy)
				return (setmetatable({
					action_type = if t81 ~= nil and t81.action_type ~= nil then t81.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t81 ~= nil and t81.action_params ~= nil then t81.action_params else nil
				}, t80))
			end
			function t80.encode(p61) -- line: 8028
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n39 = 0

				if p61.action_type ~= nil and (p61.action_type ~= nil and p61.action_type ~= 0 or p61.action_type ~= t1.ActionType.fromNumber(0)) then
					local v709, v710 = proto.writeTag(buf, n39, 1, proto.wireTypes.varint)

					buf, n39 = proto.writeVarInt(v709, v710, t1.ActionType.toNumber(p61.action_type))
				end

				if p61.action_params ~= nil then
					local v711 = p61.action_params:encode()
					local v712, v713 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

					buf, n39 = proto.writeBuffer(v712, v713, v711, buffer.len(v711))
				end

				local buf22 = buffer.create(n39)

				buffer.copy(buf22, 0, buf, 0, n39)

				return buf22
			end
			function t80.decode(p62: buffer) -- line: 8054
				-- upvalues: t80 (copy), proto (copy), t1 (copy)
				local v716 = t80.new()
				local n40 = 0

				while n40 < buffer.len(p62) do
					local v718, v719

					v718, v719, n40 = proto.readTag(p62, n40)

					if v719 == proto.wireTypes.varint then
						if v718 == 1 then
							local v720

							v720, n40 = proto.readVarIntI32(p62, n40)
							v716.action_type = t1.ActionType.fromNumber(v720) or v720
						else
							local v721

							v721, n40 = proto.readVarInt(p62, n40)
						end
					elseif v719 == proto.wireTypes.lengthDelimited then
						if v718 == 2 then
							local v722

							v722, n40 = proto.readBuffer(p62, n40)
							v716.action_params = t1.OpenTooltipAction_Params.decode(v722)
						else
							local v723, v724 = proto.readVarInt(p62, n40)

							n40 = v724 + v723
						end
					elseif v719 == proto.wireTypes.i32 then
						local v725

						v725, n40 = proto.readFixed32(p62, n40)
					elseif v719 == proto.wireTypes.i64 then
						local v726

						v726, n40 = proto.readFixed64(p62, n40)
					else
						error("Unsupported wire type: " .. v719)
					end
				end

				return v716
			end
			function t80.jsonEncode(p63) -- line: 8102
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
			function t80.jsonDecode(t83: {[any]: any}) -- line: 8124
				-- upvalues: t80 (copy), t1 (copy)
				local v730 = t80.new()

				if t83.action_type ~= nil then
					v730.action_type = if typeof(t83.action_type) ~= "number" then t1.ActionType.fromName(t83.action_type) or t83.action_type else t1.ActionType.fromNumber(t83.action_type) or t83.action_type
				end

				if t83.actionType ~= nil then
					v730.action_type = if typeof(t83.actionType) ~= "number" then t1.ActionType.fromName(t83.actionType) or t83.actionType else t1.ActionType.fromNumber(t83.actionType) or t83.actionType
				end

				if t83.action_params ~= nil then
					v730.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.action_params)
				end

				if t83.actionParams ~= nil then
					v730.action_params = t1.OpenTooltipAction_Params.jsonDecode(t83.actionParams)
				end

				return v730
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

			function t84.new(t85: {[any]: any}?) -- line: 8164
				-- upvalues: t84 (copy)
				return (setmetatable({
					tooltip_title = if t85 ~= nil and t85.tooltip_title ~= nil then t85.tooltip_title else nil,
					tooltip_info_text = if t85 ~= nil and t85.tooltip_info_text ~= nil then t85.tooltip_info_text else nil
				}, t84))
			end
			function t84.encode(p64) -- line: 8171
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n41 = 0

				if p64.tooltip_title ~= nil then
					local v735 = p64.tooltip_title:encode()
					local v736, v737 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v736, v737, v735, buffer.len(v735))
				end

				if p64.tooltip_info_text ~= nil then
					local v738 = p64.tooltip_info_text:encode()
					local v739, v740 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

					buf, n41 = proto.writeBuffer(v739, v740, v738, buffer.len(v738))
				end

				local buf23 = buffer.create(n41)

				buffer.copy(buf23, 0, buf, 0, n41)

				return buf23
			end
			function t84.decode(p65: buffer) -- line: 8192
				-- upvalues: t84 (copy), proto (copy), prop_types (copy)
				local v743 = t84.new()
				local n42 = 0

				while n42 < buffer.len(p65) do
					local v745, v746

					v745, v746, n42 = proto.readTag(p65, n42)

					if v746 == proto.wireTypes.varint then
						local v747

						v747, n42 = proto.readVarInt(p65, n42)
					elseif v746 == proto.wireTypes.lengthDelimited then
						if v745 == 1 then
							local v748

							v748, n42 = proto.readBuffer(p65, n42)
							v743.tooltip_title = prop_types.StringProp.decode(v748)
						elseif v745 == 2 then
							local v749

							v749, n42 = proto.readBuffer(p65, n42)
							v743.tooltip_info_text = prop_types.StringProp.decode(v749)
						else
							local v750, v751 = proto.readVarInt(p65, n42)

							n42 = v751 + v750
						end
					elseif v746 == proto.wireTypes.i32 then
						local v752

						v752, n42 = proto.readFixed32(p65, n42)
					elseif v746 == proto.wireTypes.i64 then
						local v753

						v753, n42 = proto.readFixed64(p65, n42)
					else
						error("Unsupported wire type: " .. v746)
					end
				end

				return v743
			end
			function t84.jsonEncode(p66) -- line: 8240
				local t86 = {}

				if p66.tooltip_title ~= nil then
					t86.tooltipTitle = p66.tooltip_title:jsonEncode()
				end

				if p66.tooltip_info_text ~= nil then
					t86.tooltipInfoText = p66.tooltip_info_text:jsonEncode()
				end

				return t86
			end
			function t84.jsonDecode(t87: {[any]: any}) -- line: 8254
				-- upvalues: t84 (copy), prop_types (copy)
				local v757 = t84.new()

				if t87.tooltip_title ~= nil then
					v757.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltip_title)
				end

				if t87.tooltipTitle ~= nil then
					v757.tooltip_title = prop_types.StringProp.jsonDecode(t87.tooltipTitle)
				end

				if t87.tooltip_info_text ~= nil then
					v757.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltip_info_text)
				end

				if t87.tooltipInfoText ~= nil then
					v757.tooltip_info_text = prop_types.StringProp.jsonDecode(t87.tooltipInfoText)
				end

				return v757
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

			function t88.new(t89: {[any]: any}?) -- line: 8294
				-- upvalues: t1 (copy), t88 (copy)
				return (setmetatable({
					action_type = if t89 ~= nil and t89.action_type ~= nil then t89.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t89 ~= nil and t89.action_params ~= nil then t89.action_params else nil
				}, t88))
			end
			function t88.encode(p67) -- line: 8303
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n43 = 0

				if p67.action_type ~= nil and (p67.action_type ~= nil and p67.action_type ~= 0 or p67.action_type ~= t1.ActionType.fromNumber(0)) then
					local v762, v763 = proto.writeTag(buf, n43, 1, proto.wireTypes.varint)

					buf, n43 = proto.writeVarInt(v762, v763, t1.ActionType.toNumber(p67.action_type))
				end

				if p67.action_params ~= nil then
					local v764 = p67.action_params:encode()
					local v765, v766 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

					buf, n43 = proto.writeBuffer(v765, v766, v764, buffer.len(v764))
				end

				local buf24 = buffer.create(n43)

				buffer.copy(buf24, 0, buf, 0, n43)

				return buf24
			end
			function t88.decode(p68: buffer) -- line: 8329
				-- upvalues: t88 (copy), proto (copy), t1 (copy)
				local v769 = t88.new()
				local n44 = 0

				while n44 < buffer.len(p68) do
					local v771, v772

					v771, v772, n44 = proto.readTag(p68, n44)

					if v772 == proto.wireTypes.varint then
						if v771 == 1 then
							local v773

							v773, n44 = proto.readVarIntI32(p68, n44)
							v769.action_type = t1.ActionType.fromNumber(v773) or v773
						else
							local v774

							v774, n44 = proto.readVarInt(p68, n44)
						end
					elseif v772 == proto.wireTypes.lengthDelimited then
						if v771 == 2 then
							local v775

							v775, n44 = proto.readBuffer(p68, n44)
							v769.action_params = t1.OpenBadgeDetailsAction_Params.decode(v775)
						else
							local v776, v777 = proto.readVarInt(p68, n44)

							n44 = v777 + v776
						end
					elseif v772 == proto.wireTypes.i32 then
						local v778

						v778, n44 = proto.readFixed32(p68, n44)
					elseif v772 == proto.wireTypes.i64 then
						local v779

						v779, n44 = proto.readFixed64(p68, n44)
					else
						error("Unsupported wire type: " .. v772)
					end
				end

				return v769
			end
			function t88.jsonEncode(p69) -- line: 8377
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
			function t88.jsonDecode(t91: {[any]: any}) -- line: 8399
				-- upvalues: t88 (copy), t1 (copy)
				local v783 = t88.new()

				if t91.action_type ~= nil then
					v783.action_type = if typeof(t91.action_type) ~= "number" then t1.ActionType.fromName(t91.action_type) or t91.action_type else t1.ActionType.fromNumber(t91.action_type) or t91.action_type
				end

				if t91.actionType ~= nil then
					v783.action_type = if typeof(t91.actionType) ~= "number" then t1.ActionType.fromName(t91.actionType) or t91.actionType else t1.ActionType.fromNumber(t91.actionType) or t91.actionType
				end

				if t91.action_params ~= nil then
					v783.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.action_params)
				end

				if t91.actionParams ~= nil then
					v783.action_params = t1.OpenBadgeDetailsAction_Params.jsonDecode(t91.actionParams)
				end

				return v783
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

			function t92.new(t93: {[any]: any}?) -- line: 8439
				-- upvalues: t92 (copy)
				return (setmetatable({
					badge_id = if t93 ~= nil and t93.badge_id ~= nil then t93.badge_id else nil,
					title_text = if t93 ~= nil and t93.title_text ~= nil then t93.title_text else nil
				}, t92))
			end
			function t92.encode(p70) -- line: 8448
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n45 = 0

				if p70.badge_id ~= nil then
					local v788 = p70.badge_id:encode()
					local v789, v790 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v789, v790, v788, buffer.len(v788))
				end

				if p70.title_text ~= nil then
					local v791 = p70.title_text:encode()
					local v792, v793 = proto.writeTag(buf, n45, 2, proto.wireTypes.lengthDelimited)

					buf, n45 = proto.writeBuffer(v792, v793, v791, buffer.len(v791))
				end

				local buf25 = buffer.create(n45)

				buffer.copy(buf25, 0, buf, 0, n45)

				return buf25
			end
			function t92.decode(p71: buffer) -- line: 8469
				-- upvalues: t92 (copy), proto (copy), prop_types (copy)
				local v796 = t92.new()
				local n46 = 0

				while n46 < buffer.len(p71) do
					local v798, v799

					v798, v799, n46 = proto.readTag(p71, n46)

					if v799 == proto.wireTypes.varint then
						local v800

						v800, n46 = proto.readVarInt(p71, n46)
					elseif v799 == proto.wireTypes.lengthDelimited then
						if v798 == 1 then
							local v801

							v801, n46 = proto.readBuffer(p71, n46)
							v796.badge_id = prop_types.StringProp.decode(v801)
						elseif v798 == 2 then
							local v802

							v802, n46 = proto.readBuffer(p71, n46)
							v796.title_text = prop_types.StringProp.decode(v802)
						else
							local v803, v804 = proto.readVarInt(p71, n46)

							n46 = v804 + v803
						end
					elseif v799 == proto.wireTypes.i32 then
						local v805

						v805, n46 = proto.readFixed32(p71, n46)
					elseif v799 == proto.wireTypes.i64 then
						local v806

						v806, n46 = proto.readFixed64(p71, n46)
					else
						error("Unsupported wire type: " .. v799)
					end
				end

				return v796
			end
			function t92.jsonEncode(p72) -- line: 8517
				local t94 = {}

				if p72.badge_id ~= nil then
					t94.badgeId = p72.badge_id:jsonEncode()
				end

				if p72.title_text ~= nil then
					t94.titleText = p72.title_text:jsonEncode()
				end

				return t94
			end
			function t92.jsonDecode(t95: {[any]: any}) -- line: 8531
				-- upvalues: t92 (copy), prop_types (copy)
				local v810 = t92.new()

				if t95.badge_id ~= nil then
					v810.badge_id = prop_types.StringProp.jsonDecode(t95.badge_id)
				end

				if t95.badgeId ~= nil then
					v810.badge_id = prop_types.StringProp.jsonDecode(t95.badgeId)
				end

				if t95.title_text ~= nil then
					v810.title_text = prop_types.StringProp.jsonDecode(t95.title_text)
				end

				if t95.titleText ~= nil then
					v810.title_text = prop_types.StringProp.jsonDecode(t95.titleText)
				end

				return v810
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

			function t96.new(t97: {[any]: any}?) -- line: 8567
				-- upvalues: t1 (copy), t96 (copy)
				return (setmetatable({
					action_type = if t97 ~= nil and t97.action_type ~= nil then t97.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t97 ~= nil and t97.action_params ~= nil then t97.action_params else nil
				}, t96))
			end
			function t96.encode(p73) -- line: 8576
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n47 = 0

				if p73.action_type ~= nil and (p73.action_type ~= nil and p73.action_type ~= 0 or p73.action_type ~= t1.ActionType.fromNumber(0)) then
					local v815, v816 = proto.writeTag(buf, n47, 1, proto.wireTypes.varint)

					buf, n47 = proto.writeVarInt(v815, v816, t1.ActionType.toNumber(p73.action_type))
				end

				if p73.action_params ~= nil then
					local v817 = p73.action_params:encode()
					local v818, v819 = proto.writeTag(buf, n47, 2, proto.wireTypes.lengthDelimited)

					buf, n47 = proto.writeBuffer(v818, v819, v817, buffer.len(v817))
				end

				local buf26 = buffer.create(n47)

				buffer.copy(buf26, 0, buf, 0, n47)

				return buf26
			end
			function t96.decode(p74: buffer) -- line: 8602
				-- upvalues: t96 (copy), proto (copy), t1 (copy)
				local v822 = t96.new()
				local n48 = 0

				while n48 < buffer.len(p74) do
					local v824, v825

					v824, v825, n48 = proto.readTag(p74, n48)

					if v825 == proto.wireTypes.varint then
						if v824 == 1 then
							local v826

							v826, n48 = proto.readVarIntI32(p74, n48)
							v822.action_type = t1.ActionType.fromNumber(v826) or v826
						else
							local v827

							v827, n48 = proto.readVarInt(p74, n48)
						end
					elseif v825 == proto.wireTypes.lengthDelimited then
						if v824 == 2 then
							local v828

							v828, n48 = proto.readBuffer(p74, n48)
							v822.action_params = t1.LoadMoreFromApiAction_Params.decode(v828)
						else
							local v829, v830 = proto.readVarInt(p74, n48)

							n48 = v830 + v829
						end
					elseif v825 == proto.wireTypes.i32 then
						local v831

						v831, n48 = proto.readFixed32(p74, n48)
					elseif v825 == proto.wireTypes.i64 then
						local v832

						v832, n48 = proto.readFixed64(p74, n48)
					else
						error("Unsupported wire type: " .. v825)
					end
				end

				return v822
			end
			function t96.jsonEncode(p75) -- line: 8650
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
			function t96.jsonDecode(t99: {[any]: any}) -- line: 8672
				-- upvalues: t96 (copy), t1 (copy)
				local v836 = t96.new()

				if t99.action_type ~= nil then
					v836.action_type = if typeof(t99.action_type) ~= "number" then t1.ActionType.fromName(t99.action_type) or t99.action_type else t1.ActionType.fromNumber(t99.action_type) or t99.action_type
				end

				if t99.actionType ~= nil then
					v836.action_type = if typeof(t99.actionType) ~= "number" then t1.ActionType.fromName(t99.actionType) or t99.actionType else t1.ActionType.fromNumber(t99.actionType) or t99.actionType
				end

				if t99.action_params ~= nil then
					v836.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.action_params)
				end

				if t99.actionParams ~= nil then
					v836.action_params = t1.LoadMoreFromApiAction_Params.jsonDecode(t99.actionParams)
				end

				return v836
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

			function t100.new(t101: {[any]: any}?) -- line: 8712
				-- upvalues: t100 (copy)
				return (setmetatable({
					surface_key = if t101 ~= nil and t101.surface_key ~= nil then t101.surface_key else nil,
					config_key = if t101 ~= nil and t101.config_key ~= nil then t101.config_key else nil
				}, t100))
			end
			function t100.encode(p76) -- line: 8721
				-- upvalues: proto (copy)
				local buf = buffer.create(0)
				local n49 = 0

				if p76.surface_key ~= nil then
					local v841 = p76.surface_key:encode()
					local v842, v843 = proto.writeTag(buf, n49, 1, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v842, v843, v841, buffer.len(v841))
				end

				if p76.config_key ~= nil then
					local v844 = p76.config_key:encode()
					local v845, v846 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

					buf, n49 = proto.writeBuffer(v845, v846, v844, buffer.len(v844))
				end

				local buf27 = buffer.create(n49)

				buffer.copy(buf27, 0, buf, 0, n49)

				return buf27
			end
			function t100.decode(p77: buffer) -- line: 8742
				-- upvalues: t100 (copy), proto (copy), prop_types (copy)
				local v849 = t100.new()
				local n50 = 0

				while n50 < buffer.len(p77) do
					local v851, v852

					v851, v852, n50 = proto.readTag(p77, n50)

					if v852 == proto.wireTypes.varint then
						local v853

						v853, n50 = proto.readVarInt(p77, n50)
					elseif v852 == proto.wireTypes.lengthDelimited then
						if v851 == 1 then
							local v854

							v854, n50 = proto.readBuffer(p77, n50)
							v849.surface_key = prop_types.StringProp.decode(v854)
						elseif v851 == 2 then
							local v855

							v855, n50 = proto.readBuffer(p77, n50)
							v849.config_key = prop_types.StringProp.decode(v855)
						else
							local v856, v857 = proto.readVarInt(p77, n50)

							n50 = v857 + v856
						end
					elseif v852 == proto.wireTypes.i32 then
						local v858

						v858, n50 = proto.readFixed32(p77, n50)
					elseif v852 == proto.wireTypes.i64 then
						local v859

						v859, n50 = proto.readFixed64(p77, n50)
					else
						error("Unsupported wire type: " .. v852)
					end
				end

				return v849
			end
			function t100.jsonEncode(p78) -- line: 8790
				local t102 = {}

				if p78.surface_key ~= nil then
					t102.surfaceKey = p78.surface_key:jsonEncode()
				end

				if p78.config_key ~= nil then
					t102.configKey = p78.config_key:jsonEncode()
				end

				return t102
			end
			function t100.jsonDecode(t103: {[any]: any}) -- line: 8804
				-- upvalues: t100 (copy), prop_types (copy)
				local v863 = t100.new()

				if t103.surface_key ~= nil then
					v863.surface_key = prop_types.StringProp.jsonDecode(t103.surface_key)
				end

				if t103.surfaceKey ~= nil then
					v863.surface_key = prop_types.StringProp.jsonDecode(t103.surfaceKey)
				end

				if t103.config_key ~= nil then
					v863.config_key = prop_types.StringProp.jsonDecode(t103.config_key)
				end

				if t103.configKey ~= nil then
					v863.config_key = prop_types.StringProp.jsonDecode(t103.configKey)
				end

				return v863
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

			function t104.new(t105: {[any]: any}?) -- line: 8841
				-- upvalues: t1 (copy), t104 (copy)
				return (setmetatable({
					action_type = if t105 ~= nil and t105.action_type ~= nil then t105.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
					action_params = if t105 ~= nil and t105.action_params ~= nil then t105.action_params else nil
				}, t104))
			end
			function t104.encode(p79) -- line: 8850
				-- upvalues: t1 (copy), proto (copy)
				local buf = buffer.create(0)
				local n51 = 0

				if p79.action_type ~= nil and (p79.action_type ~= nil and p79.action_type ~= 0 or p79.action_type ~= t1.ActionType.fromNumber(0)) then
					local v868, v869 = proto.writeTag(buf, n51, 1, proto.wireTypes.varint)

					buf, n51 = proto.writeVarInt(v868, v869, t1.ActionType.toNumber(p79.action_type))
				end

				if p79.action_params ~= nil then
					local v870 = p79.action_params:encode()
					local v871, v872 = proto.writeTag(buf, n51, 2, proto.wireTypes.lengthDelimited)

					buf, n51 = proto.writeBuffer(v871, v872, v870, buffer.len(v870))
				end

				local buf28 = buffer.create(n51)

				buffer.copy(buf28, 0, buf, 0, n51)

				return buf28
			end
			function t104.decode(p80: buffer) -- line: 8876
				-- upvalues: t104 (copy), proto (copy), t1 (copy)
				local v875 = t104.new()
				local n52 = 0

				while n52 < buffer.len(p80) do
					local v877, v878

					v877, v878, n52 = proto.readTag(p80, n52)

					if v878 == proto.wireTypes.varint then
						if v877 == 1 then
							local v879

							v879, n52 = proto.readVarIntI32(p80, n52)
							v875.action_type = t1.ActionType.fromNumber(v879) or v879
						else
							local v880

							v880, n52 = proto.readVarInt(p80, n52)
						end
					elseif v878 == proto.wireTypes.lengthDelimited then
						if v877 == 2 then
							local v881

							v881, n52 = proto.readBuffer(p80, n52)
							v875.action_params = t1.ShareAction_Params.decode(v881)
						else
							local v882, v883 = proto.readVarInt(p80, n52)

							n52 = v883 + v882
						end
					elseif v878 == proto.wireTypes.i32 then
						local v884

						v884, n52 = proto.readFixed32(p80, n52)
					elseif v878 == proto.wireTypes.i64 then
						local v885

						v885, n52 = proto.readFixed64(p80, n52)
					else
						error("Unsupported wire type: " .. v878)
					end
				end

				return v875
			end
			function t104.jsonEncode(p81) -- line: 8924
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
			function t104.jsonDecode(t107: {[any]: any}) -- line: 8946
				-- upvalues: t104 (copy), t1 (copy)
				local v889 = t104.new()

				if t107.action_type ~= nil then
					v889.action_type = if typeof(t107.action_type) ~= "number" then t1.ActionType.fromName(t107.action_type) or t107.action_type else t1.ActionType.fromNumber(t107.action_type) or t107.action_type
				end

				if t107.actionType ~= nil then
					v889.action_type = if typeof(t107.actionType) ~= "number" then t1.ActionType.fromName(t107.actionType) or t107.actionType else t1.ActionType.fromNumber(t107.actionType) or t107.actionType
				end

				if t107.action_params ~= nil then
					v889.action_params = t1.ShareAction_Params.jsonDecode(t107.action_params)
				end

				if t107.actionParams ~= nil then
					v889.action_params = t1.ShareAction_Params.jsonDecode(t107.actionParams)
				end

				return v889
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

		function t108.new(t109: {[any]: any}?) -- line: 8986
			-- upvalues: t108 (copy)
			return (setmetatable({
				oneof_prop = if t109 ~= nil and t109.oneof_prop ~= nil then t109.oneof_prop else nil
			}, t108))
		end
		function t108.encode(p82) -- line: 8994
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n53 = 0

			if p82.oneof_prop ~= nil then
				if p82.oneof_prop.type == "generic_share_link_data" then
					local v894 = p82.oneof_prop.value:encode()
					local v895, v896 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v895, v896, v894, buffer.len(v894))
				elseif p82.oneof_prop.type == "share_link_fetch_data" then
					local v897 = p82.oneof_prop.value:encode()
					local v898, v899 = proto.writeTag(buf, n53, 2, proto.wireTypes.lengthDelimited)

					buf, n53 = proto.writeBuffer(v898, v899, v897, buffer.len(v897))
				end
			end

			local buf29 = buffer.create(n53)

			buffer.copy(buf29, 0, buf, 0, n53)

			return buf29
		end
		function t108.decode(p83: buffer) -- line: 9015
			-- upvalues: t108 (copy), proto (copy), share_link_data (copy)
			local v902 = t108.new()
			local n54 = 0

			while n54 < buffer.len(p83) do
				local v904, v905

				v904, v905, n54 = proto.readTag(p83, n54)

				if v905 == proto.wireTypes.varint then
					local v906

					v906, n54 = proto.readVarInt(p83, n54)
				elseif v905 == proto.wireTypes.lengthDelimited then
					if v904 == 1 then
						local v907

						v907, n54 = proto.readBuffer(p83, n54)
						v902.oneof_prop = {
							type = "generic_share_link_data",
							value = share_link_data.GenericShareLinkData.decode(v907)
						}
					elseif v904 == 2 then
						local v908

						v908, n54 = proto.readBuffer(p83, n54)
						v902.oneof_prop = {
							type = "share_link_fetch_data",
							value = share_link_data.ShareLinkFetchData.decode(v908)
						}
					else
						local v909, v910 = proto.readVarInt(p83, n54)

						n54 = v910 + v909
					end
				elseif v905 == proto.wireTypes.i32 then
					local v911

					v911, n54 = proto.readFixed32(p83, n54)
				elseif v905 == proto.wireTypes.i64 then
					local v912

					v912, n54 = proto.readFixed64(p83, n54)
				else
					error("Unsupported wire type: " .. v905)
				end
			end

			return v902
		end
		function t108.jsonEncode(p84) -- line: 9071
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
		function t108.jsonDecode(t111: {[any]: any}) -- line: 9085
			-- upvalues: t108 (copy), share_link_data (copy)
			local v916 = t108.new()

			if t111.generic_share_link_data ~= nil then
				v916.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.generic_share_link_data)
				}
			end

			if t111.genericShareLinkData ~= nil then
				v916.oneof_prop = {
					type = "generic_share_link_data",
					value = share_link_data.GenericShareLinkData.jsonDecode(t111.genericShareLinkData)
				}
			end

			if t111.share_link_fetch_data ~= nil then
				v916.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.share_link_fetch_data)
				}
			end

			if t111.shareLinkFetchData ~= nil then
				v916.oneof_prop = {
					type = "share_link_fetch_data",
					value = share_link_data.ShareLinkFetchData.jsonDecode(t111.shareLinkFetchData)
				}
			end

			return v916
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

		function t112.new(t113: {[any]: any}?) -- line: 9141
			-- upvalues: t112 (copy)
			return (setmetatable({
				share_link_type = if t113 ~= nil and t113.share_link_type ~= nil then t113.share_link_type else nil,
				share_link_data = if t113 ~= nil and t113.share_link_data ~= nil then t113.share_link_data else nil,
				entry_point_key = if t113 ~= nil and t113.entry_point_key ~= nil then t113.entry_point_key else nil
			}, t112))
		end
		function t112.encode(p85) -- line: 9149
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n55 = 0

			if p85.share_link_type ~= nil then
				local v921 = p85.share_link_type:encode()
				local v922, v923 = proto.writeTag(buf, n55, 1, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v922, v923, v921, buffer.len(v921))
			end

			if p85.share_link_data ~= nil then
				local v924 = p85.share_link_data:encode()
				local v925, v926 = proto.writeTag(buf, n55, 2, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v925, v926, v924, buffer.len(v924))
			end

			if p85.entry_point_key ~= nil then
				local v927 = p85.entry_point_key:encode()
				local v928, v929 = proto.writeTag(buf, n55, 3, proto.wireTypes.lengthDelimited)

				buf, n55 = proto.writeBuffer(v928, v929, v927, buffer.len(v927))
			end

			local buf30 = buffer.create(n55)

			buffer.copy(buf30, 0, buf, 0, n55)

			return buf30
		end
		function t112.decode(p86: buffer) -- line: 9176
			-- upvalues: t112 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v932 = t112.new()
			local n56 = 0

			while n56 < buffer.len(p86) do
				local v934, v935

				v934, v935, n56 = proto.readTag(p86, n56)

				if v935 == proto.wireTypes.varint then
					local v936

					v936, n56 = proto.readVarInt(p86, n56)
				elseif v935 == proto.wireTypes.lengthDelimited then
					if v934 == 1 then
						local v937

						v937, n56 = proto.readBuffer(p86, n56)
						v932.share_link_type = prop_types.StringProp.decode(v937)
					elseif v934 == 2 then
						local v938

						v938, n56 = proto.readBuffer(p86, n56)
						v932.share_link_data = t1.ShareAction_ShareLinkData.decode(v938)
					elseif v934 == 3 then
						local v939

						v939, n56 = proto.readBuffer(p86, n56)
						v932.entry_point_key = prop_types.StringProp.decode(v939)
					else
						local v940, v941 = proto.readVarInt(p86, n56)

						n56 = v941 + v940
					end
				elseif v935 == proto.wireTypes.i32 then
					local v942

					v942, n56 = proto.readFixed32(p86, n56)
				elseif v935 == proto.wireTypes.i64 then
					local v943

					v943, n56 = proto.readFixed64(p86, n56)
				else
					error("Unsupported wire type: " .. v935)
				end
			end

			return v932
		end
		function t112.jsonEncode(p87) -- line: 9229
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
		function t112.jsonDecode(t115: {[any]: any}) -- line: 9247
			-- upvalues: t112 (copy), prop_types (copy), t1 (copy)
			local v947 = t112.new()

			if t115.share_link_type ~= nil then
				v947.share_link_type = prop_types.StringProp.jsonDecode(t115.share_link_type)
			end

			if t115.shareLinkType ~= nil then
				v947.share_link_type = prop_types.StringProp.jsonDecode(t115.shareLinkType)
			end

			if t115.share_link_data ~= nil then
				v947.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.share_link_data)
			end

			if t115.shareLinkData ~= nil then
				v947.share_link_data = t1.ShareAction_ShareLinkData.jsonDecode(t115.shareLinkData)
			end

			if t115.entry_point_key ~= nil then
				v947.entry_point_key = prop_types.StringProp.jsonDecode(t115.entry_point_key)
			end

			if t115.entryPointKey ~= nil then
				v947.entry_point_key = prop_types.StringProp.jsonDecode(t115.entryPointKey)
			end

			return v947
		end

		t112.descriptor = {
			name = "ShareAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ShareAction_Params = t112
		typeRegistry.default:register(t1.ShareAction_Params)

		local t116 = {}

		t116.__index = t116

		function t116.new(t117: {[any]: any}?) -- line: 9295
			-- upvalues: t1 (copy), t116 (copy)
			return (setmetatable({
				action_type = if t117 ~= nil and t117.action_type ~= nil then t117.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t117 ~= nil and t117.action_params ~= nil then t117.action_params else nil
			}, t116))
		end
		function t116.encode(p88) -- line: 9304
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n57 = 0

			if p88.action_type ~= nil and (p88.action_type ~= nil and p88.action_type ~= 0 or p88.action_type ~= t1.ActionType.fromNumber(0)) then
				local v952, v953 = proto.writeTag(buf, n57, 1, proto.wireTypes.varint)

				buf, n57 = proto.writeVarInt(v952, v953, t1.ActionType.toNumber(p88.action_type))
			end

			if p88.action_params ~= nil then
				local v954 = p88.action_params:encode()
				local v955, v956 = proto.writeTag(buf, n57, 2, proto.wireTypes.lengthDelimited)

				buf, n57 = proto.writeBuffer(v955, v956, v954, buffer.len(v954))
			end

			local buf31 = buffer.create(n57)

			buffer.copy(buf31, 0, buf, 0, n57)

			return buf31
		end
		function t116.decode(p89: buffer) -- line: 9330
			-- upvalues: t116 (copy), proto (copy), t1 (copy)
			local v959 = t116.new()
			local n58 = 0

			while n58 < buffer.len(p89) do
				local v961, v962

				v961, v962, n58 = proto.readTag(p89, n58)

				if v962 == proto.wireTypes.varint then
					if v961 == 1 then
						local v963

						v963, n58 = proto.readVarIntI32(p89, n58)
						v959.action_type = t1.ActionType.fromNumber(v963) or v963
					else
						local v964

						v964, n58 = proto.readVarInt(p89, n58)
					end
				elseif v962 == proto.wireTypes.lengthDelimited then
					if v961 == 2 then
						local v965

						v965, n58 = proto.readBuffer(p89, n58)
						v959.action_params = t1.OpenAbuseReportAction_Params.decode(v965)
					else
						local v966, v967 = proto.readVarInt(p89, n58)

						n58 = v967 + v966
					end
				elseif v962 == proto.wireTypes.i32 then
					local v968

					v968, n58 = proto.readFixed32(p89, n58)
				elseif v962 == proto.wireTypes.i64 then
					local v969

					v969, n58 = proto.readFixed64(p89, n58)
				else
					error("Unsupported wire type: " .. v962)
				end
			end

			return v959
		end
		function t116.jsonEncode(p90) -- line: 9378
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
		function t116.jsonDecode(t119: {[any]: any}) -- line: 9400
			-- upvalues: t116 (copy), t1 (copy)
			local v973 = t116.new()

			if t119.action_type ~= nil then
				v973.action_type = if typeof(t119.action_type) ~= "number" then t1.ActionType.fromName(t119.action_type) or t119.action_type else t1.ActionType.fromNumber(t119.action_type) or t119.action_type
			end

			if t119.actionType ~= nil then
				v973.action_type = if typeof(t119.actionType) ~= "number" then t1.ActionType.fromName(t119.actionType) or t119.actionType else t1.ActionType.fromNumber(t119.actionType) or t119.actionType
			end

			if t119.action_params ~= nil then
				v973.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.action_params)
			end

			if t119.actionParams ~= nil then
				v973.action_params = t1.OpenAbuseReportAction_Params.jsonDecode(t119.actionParams)
			end

			return v973
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

		function t120.new(t121: {[any]: any}?) -- line: 9440
			-- upvalues: t120 (copy)
			return (setmetatable({
				target_id = if t121 ~= nil and t121.target_id ~= nil then t121.target_id else nil,
				abuse_vector = if t121 ~= nil and t121.abuse_vector ~= nil then t121.abuse_vector else nil,
				asset_type_name = if t121 ~= nil and t121.asset_type_name ~= nil then t121.asset_type_name else nil,
				universe_id = if t121 ~= nil and t121.universe_id ~= nil then t121.universe_id else nil
			}, t120))
		end
		function t120.encode(p91) -- line: 9451
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n59 = 0

			if p91.target_id ~= nil then
				local v978 = p91.target_id:encode()
				local v979, v980 = proto.writeTag(buf, n59, 1, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v979, v980, v978, buffer.len(v978))
			end

			if p91.abuse_vector ~= nil then
				local v981 = p91.abuse_vector:encode()
				local v982, v983 = proto.writeTag(buf, n59, 2, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v982, v983, v981, buffer.len(v981))
			end

			if p91.asset_type_name ~= nil then
				local v984 = p91.asset_type_name:encode()
				local v985, v986 = proto.writeTag(buf, n59, 3, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v985, v986, v984, buffer.len(v984))
			end

			if p91.universe_id ~= nil then
				local v987 = p91.universe_id:encode()
				local v988, v989 = proto.writeTag(buf, n59, 4, proto.wireTypes.lengthDelimited)

				buf, n59 = proto.writeBuffer(v988, v989, v987, buffer.len(v987))
			end

			local buf32 = buffer.create(n59)

			buffer.copy(buf32, 0, buf, 0, n59)

			return buf32
		end
		function t120.decode(p92: buffer) -- line: 9484
			-- upvalues: t120 (copy), proto (copy), prop_types (copy)
			local v992 = t120.new()
			local n60 = 0

			while n60 < buffer.len(p92) do
				local v994, v995

				v994, v995, n60 = proto.readTag(p92, n60)

				if v995 == proto.wireTypes.varint then
					local v996

					v996, n60 = proto.readVarInt(p92, n60)
				elseif v995 == proto.wireTypes.lengthDelimited then
					if v994 == 1 then
						local v997

						v997, n60 = proto.readBuffer(p92, n60)
						v992.target_id = prop_types.StringProp.decode(v997)
					elseif v994 == 2 then
						local v998

						v998, n60 = proto.readBuffer(p92, n60)
						v992.abuse_vector = prop_types.StringProp.decode(v998)
					elseif v994 == 3 then
						local v999

						v999, n60 = proto.readBuffer(p92, n60)
						v992.asset_type_name = prop_types.StringProp.decode(v999)
					elseif v994 == 4 then
						local v1000

						v1000, n60 = proto.readBuffer(p92, n60)
						v992.universe_id = prop_types.StringProp.decode(v1000)
					else
						local v1001, v1002 = proto.readVarInt(p92, n60)

						n60 = v1002 + v1001
					end
				elseif v995 == proto.wireTypes.i32 then
					local v1003

					v1003, n60 = proto.readFixed32(p92, n60)
				elseif v995 == proto.wireTypes.i64 then
					local v1004

					v1004, n60 = proto.readFixed64(p92, n60)
				else
					error("Unsupported wire type: " .. v995)
				end
			end

			return v992
		end
		function t120.jsonEncode(p93) -- line: 9542
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
		function t120.jsonDecode(t123: {[any]: any}) -- line: 9564
			-- upvalues: t120 (copy), prop_types (copy)
			local v1008 = t120.new()

			if t123.target_id ~= nil then
				v1008.target_id = prop_types.StringProp.jsonDecode(t123.target_id)
			end

			if t123.targetId ~= nil then
				v1008.target_id = prop_types.StringProp.jsonDecode(t123.targetId)
			end

			if t123.abuse_vector ~= nil then
				v1008.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuse_vector)
			end

			if t123.abuseVector ~= nil then
				v1008.abuse_vector = prop_types.StringProp.jsonDecode(t123.abuseVector)
			end

			if t123.asset_type_name ~= nil then
				v1008.asset_type_name = prop_types.StringProp.jsonDecode(t123.asset_type_name)
			end

			if t123.assetTypeName ~= nil then
				v1008.asset_type_name = prop_types.StringProp.jsonDecode(t123.assetTypeName)
			end

			if t123.universe_id ~= nil then
				v1008.universe_id = prop_types.StringProp.jsonDecode(t123.universe_id)
			end

			if t123.universeId ~= nil then
				v1008.universe_id = prop_types.StringProp.jsonDecode(t123.universeId)
			end

			return v1008
		end

		t120.descriptor = {
			name = "OpenAbuseReportAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAbuseReportAction_Params = t120
		typeRegistry.default:register(t1.OpenAbuseReportAction_Params)

		local t124 = {}

		t124.__index = t124

		function t124.new(t125: {[any]: any}?) -- line: 9621
			-- upvalues: t1 (copy), t124 (copy)
			return (setmetatable({
				action_type = if t125 ~= nil and t125.action_type ~= nil then t125.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t125 ~= nil and t125.action_params ~= nil then t125.action_params else nil
			}, t124))
		end
		function t124.encode(p94) -- line: 9632
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n61 = 0

			if p94.action_type ~= nil and (p94.action_type ~= nil and p94.action_type ~= 0 or p94.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1013, v1014 = proto.writeTag(buf, n61, 1, proto.wireTypes.varint)

				buf, n61 = proto.writeVarInt(v1013, v1014, t1.ActionType.toNumber(p94.action_type))
			end

			if p94.action_params ~= nil then
				local v1015 = p94.action_params:encode()
				local v1016, v1017 = proto.writeTag(buf, n61, 2, proto.wireTypes.lengthDelimited)

				buf, n61 = proto.writeBuffer(v1016, v1017, v1015, buffer.len(v1015))
			end

			local buf33 = buffer.create(n61)

			buffer.copy(buf33, 0, buf, 0, n61)

			return buf33
		end
		function t124.decode(p95: buffer) -- line: 9658
			-- upvalues: t124 (copy), proto (copy), t1 (copy)
			local v1020 = t124.new()
			local n62 = 0

			while n62 < buffer.len(p95) do
				local v1022, v1023

				v1022, v1023, n62 = proto.readTag(p95, n62)

				if v1023 == proto.wireTypes.varint then
					if v1022 == 1 then
						local v1024

						v1024, n62 = proto.readVarIntI32(p95, n62)
						v1020.action_type = t1.ActionType.fromNumber(v1024) or v1024
					else
						local v1025

						v1025, n62 = proto.readVarInt(p95, n62)
					end
				elseif v1023 == proto.wireTypes.lengthDelimited then
					if v1022 == 2 then
						local v1026

						v1026, n62 = proto.readBuffer(p95, n62)
						v1020.action_params = t1.RemoveBadgeFromInventoryAction_Params.decode(v1026)
					else
						local v1027, v1028 = proto.readVarInt(p95, n62)

						n62 = v1028 + v1027
					end
				elseif v1023 == proto.wireTypes.i32 then
					local v1029

					v1029, n62 = proto.readFixed32(p95, n62)
				elseif v1023 == proto.wireTypes.i64 then
					local v1030

					v1030, n62 = proto.readFixed64(p95, n62)
				else
					error("Unsupported wire type: " .. v1023)
				end
			end

			return v1020
		end
		function t124.jsonEncode(p96) -- line: 9706
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
		function t124.jsonDecode(t127: {[any]: any}) -- line: 9728
			-- upvalues: t124 (copy), t1 (copy)
			local v1034 = t124.new()

			if t127.action_type ~= nil then
				v1034.action_type = if typeof(t127.action_type) ~= "number" then t1.ActionType.fromName(t127.action_type) or t127.action_type else t1.ActionType.fromNumber(t127.action_type) or t127.action_type
			end

			if t127.actionType ~= nil then
				v1034.action_type = if typeof(t127.actionType) ~= "number" then t1.ActionType.fromName(t127.actionType) or t127.actionType else t1.ActionType.fromNumber(t127.actionType) or t127.actionType
			end

			if t127.action_params ~= nil then
				v1034.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.action_params)
			end

			if t127.actionParams ~= nil then
				v1034.action_params = t1.RemoveBadgeFromInventoryAction_Params.jsonDecode(t127.actionParams)
			end

			return v1034
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

		function t128.new(t129: {[any]: any}?) -- line: 9768
			-- upvalues: t128 (copy)
			return (setmetatable({
				asset_id = if t129 ~= nil and t129.asset_id ~= nil then t129.asset_id else nil
			}, t128))
		end
		function t128.encode(p97) -- line: 9776
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n63 = 0

			if p97.asset_id ~= nil then
				local v1039 = p97.asset_id:encode()
				local v1040, v1041 = proto.writeTag(buf, n63, 1, proto.wireTypes.lengthDelimited)

				buf, n63 = proto.writeBuffer(v1040, v1041, v1039, buffer.len(v1039))
			end

			local buf34 = buffer.create(n63)

			buffer.copy(buf34, 0, buf, 0, n63)

			return buf34
		end
		function t128.decode(p98: buffer) -- line: 9791
			-- upvalues: t128 (copy), proto (copy), prop_types (copy)
			local v1044 = t128.new()
			local n64 = 0

			while n64 < buffer.len(p98) do
				local v1046, v1047

				v1046, v1047, n64 = proto.readTag(p98, n64)

				if v1047 == proto.wireTypes.varint then
					local v1048

					v1048, n64 = proto.readVarInt(p98, n64)
				elseif v1047 == proto.wireTypes.lengthDelimited then
					if v1046 == 1 then
						local v1049

						v1049, n64 = proto.readBuffer(p98, n64)
						v1044.asset_id = prop_types.StringProp.decode(v1049)
					else
						local v1050, v1051 = proto.readVarInt(p98, n64)

						n64 = v1051 + v1050
					end
				elseif v1047 == proto.wireTypes.i32 then
					local v1052

					v1052, n64 = proto.readFixed32(p98, n64)
				elseif v1047 == proto.wireTypes.i64 then
					local v1053

					v1053, n64 = proto.readFixed64(p98, n64)
				else
					error("Unsupported wire type: " .. v1047)
				end
			end

			return v1044
		end
		function t128.jsonEncode(p99) -- line: 9834
			local t130 = {}

			if p99.asset_id ~= nil then
				t130.assetId = p99.asset_id:jsonEncode()
			end

			return t130
		end
		function t128.jsonDecode(t131: {[any]: any}) -- line: 9844
			-- upvalues: t128 (copy), prop_types (copy)
			local v1057 = t128.new()

			if t131.asset_id ~= nil then
				v1057.asset_id = prop_types.StringProp.jsonDecode(t131.asset_id)
			end

			if t131.assetId ~= nil then
				v1057.asset_id = prop_types.StringProp.jsonDecode(t131.assetId)
			end

			return v1057
		end

		t128.descriptor = {
			name = "RemoveBadgeFromInventoryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RemoveBadgeFromInventoryAction_Params = t128
		typeRegistry.default:register(t1.RemoveBadgeFromInventoryAction_Params)

		local t132 = {}

		t132.__index = t132

		function t132.new(t133: {[any]: any}?) -- line: 9874
			-- upvalues: t1 (copy), t132 (copy)
			return (setmetatable({
				action_type = if t133 ~= nil and t133.action_type ~= nil then t133.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t133 ~= nil and t133.action_params ~= nil then t133.action_params else nil
			}, t132))
		end
		function t132.encode(p100) -- line: 9883
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n65 = 0

			if p100.action_type ~= nil and (p100.action_type ~= nil and p100.action_type ~= 0 or p100.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1062, v1063 = proto.writeTag(buf, n65, 1, proto.wireTypes.varint)

				buf, n65 = proto.writeVarInt(v1062, v1063, t1.ActionType.toNumber(p100.action_type))
			end

			if p100.action_params ~= nil then
				local v1064 = p100.action_params:encode()
				local v1065, v1066 = proto.writeTag(buf, n65, 2, proto.wireTypes.lengthDelimited)

				buf, n65 = proto.writeBuffer(v1065, v1066, v1064, buffer.len(v1064))
			end

			local buf35 = buffer.create(n65)

			buffer.copy(buf35, 0, buf, 0, n65)

			return buf35
		end
		function t132.decode(p101: buffer) -- line: 9909
			-- upvalues: t132 (copy), proto (copy), t1 (copy)
			local v1069 = t132.new()
			local n66 = 0

			while n66 < buffer.len(p101) do
				local v1071, v1072

				v1071, v1072, n66 = proto.readTag(p101, n66)

				if v1072 == proto.wireTypes.varint then
					if v1071 == 1 then
						local v1073

						v1073, n66 = proto.readVarIntI32(p101, n66)
						v1069.action_type = t1.ActionType.fromNumber(v1073) or v1073
					else
						local v1074

						v1074, n66 = proto.readVarInt(p101, n66)
					end
				elseif v1072 == proto.wireTypes.lengthDelimited then
					if v1071 == 2 then
						local v1075

						v1075, n66 = proto.readBuffer(p101, n66)
						v1069.action_params = t1.OpenProfileAction_Params.decode(v1075)
					else
						local v1076, v1077 = proto.readVarInt(p101, n66)

						n66 = v1077 + v1076
					end
				elseif v1072 == proto.wireTypes.i32 then
					local v1078

					v1078, n66 = proto.readFixed32(p101, n66)
				elseif v1072 == proto.wireTypes.i64 then
					local v1079

					v1079, n66 = proto.readFixed64(p101, n66)
				else
					error("Unsupported wire type: " .. v1072)
				end
			end

			return v1069
		end
		function t132.jsonEncode(p102) -- line: 9957
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
		function t132.jsonDecode(t135: {[any]: any}) -- line: 9979
			-- upvalues: t132 (copy), t1 (copy)
			local v1083 = t132.new()

			if t135.action_type ~= nil then
				v1083.action_type = if typeof(t135.action_type) ~= "number" then t1.ActionType.fromName(t135.action_type) or t135.action_type else t1.ActionType.fromNumber(t135.action_type) or t135.action_type
			end

			if t135.actionType ~= nil then
				v1083.action_type = if typeof(t135.actionType) ~= "number" then t1.ActionType.fromName(t135.actionType) or t135.actionType else t1.ActionType.fromNumber(t135.actionType) or t135.actionType
			end

			if t135.action_params ~= nil then
				v1083.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.action_params)
			end

			if t135.actionParams ~= nil then
				v1083.action_params = t1.OpenProfileAction_Params.jsonDecode(t135.actionParams)
			end

			return v1083
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

		function t136.new(t137: {[any]: any}?) -- line: 10019
			-- upvalues: t136 (copy)
			return (setmetatable({
				profile_id = if t137 ~= nil and t137.profile_id ~= nil then t137.profile_id else nil,
				profile_type = if t137 ~= nil and t137.profile_type ~= nil then t137.profile_type else nil,
				source = if t137 ~= nil and t137.source ~= nil then t137.source else nil
			}, t136))
		end
		function t136.encode(p103) -- line: 10027
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n67 = 0

			if p103.profile_id ~= nil then
				local v1088 = p103.profile_id:encode()
				local v1089, v1090 = proto.writeTag(buf, n67, 1, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1089, v1090, v1088, buffer.len(v1088))
			end

			if p103.profile_type ~= nil then
				local v1091 = p103.profile_type:encode()
				local v1092, v1093 = proto.writeTag(buf, n67, 2, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1092, v1093, v1091, buffer.len(v1091))
			end

			if p103.source ~= nil then
				local v1094 = p103.source:encode()
				local v1095, v1096 = proto.writeTag(buf, n67, 3, proto.wireTypes.lengthDelimited)

				buf, n67 = proto.writeBuffer(v1095, v1096, v1094, buffer.len(v1094))
			end

			local buf36 = buffer.create(n67)

			buffer.copy(buf36, 0, buf, 0, n67)

			return buf36
		end
		function t136.decode(p104: buffer) -- line: 10054
			-- upvalues: t136 (copy), proto (copy), prop_types (copy)
			local v1099 = t136.new()
			local n68 = 0

			while n68 < buffer.len(p104) do
				local v1101, v1102

				v1101, v1102, n68 = proto.readTag(p104, n68)

				if v1102 == proto.wireTypes.varint then
					local v1103

					v1103, n68 = proto.readVarInt(p104, n68)
				elseif v1102 == proto.wireTypes.lengthDelimited then
					if v1101 == 1 then
						local v1104

						v1104, n68 = proto.readBuffer(p104, n68)
						v1099.profile_id = prop_types.StringProp.decode(v1104)
					elseif v1101 == 2 then
						local v1105

						v1105, n68 = proto.readBuffer(p104, n68)
						v1099.profile_type = prop_types.StringProp.decode(v1105)
					elseif v1101 == 3 then
						local v1106

						v1106, n68 = proto.readBuffer(p104, n68)
						v1099.source = prop_types.StringProp.decode(v1106)
					else
						local v1107, v1108 = proto.readVarInt(p104, n68)

						n68 = v1108 + v1107
					end
				elseif v1102 == proto.wireTypes.i32 then
					local v1109

					v1109, n68 = proto.readFixed32(p104, n68)
				elseif v1102 == proto.wireTypes.i64 then
					local v1110

					v1110, n68 = proto.readFixed64(p104, n68)
				else
					error("Unsupported wire type: " .. v1102)
				end
			end

			return v1099
		end
		function t136.jsonEncode(p105) -- line: 10107
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
		function t136.jsonDecode(t139: {[any]: any}) -- line: 10125
			-- upvalues: t136 (copy), prop_types (copy)
			local v1114 = t136.new()

			if t139.profile_id ~= nil then
				v1114.profile_id = prop_types.StringProp.jsonDecode(t139.profile_id)
			end

			if t139.profileId ~= nil then
				v1114.profile_id = prop_types.StringProp.jsonDecode(t139.profileId)
			end

			if t139.profile_type ~= nil then
				v1114.profile_type = prop_types.StringProp.jsonDecode(t139.profile_type)
			end

			if t139.profileType ~= nil then
				v1114.profile_type = prop_types.StringProp.jsonDecode(t139.profileType)
			end

			if t139.source ~= nil then
				v1114.source = prop_types.StringProp.jsonDecode(t139.source)
			end

			return v1114
		end

		t136.descriptor = {
			name = "OpenProfileAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenProfileAction_Params = t136
		typeRegistry.default:register(t1.OpenProfileAction_Params)

		local t140 = {}

		t140.__index = t140

		function t140.new(t141: {[any]: any}?) -- line: 10167
			-- upvalues: t1 (copy), t140 (copy)
			return (setmetatable({
				action_type = if t141 ~= nil and t141.action_type ~= nil then t141.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t141 ~= nil and t141.action_params ~= nil then t141.action_params else nil
			}, t140))
		end
		function t140.encode(p106) -- line: 10178
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n69 = 0

			if p106.action_type ~= nil and (p106.action_type ~= nil and p106.action_type ~= 0 or p106.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1119, v1120 = proto.writeTag(buf, n69, 1, proto.wireTypes.varint)

				buf, n69 = proto.writeVarInt(v1119, v1120, t1.ActionType.toNumber(p106.action_type))
			end

			if p106.action_params ~= nil then
				local v1121 = p106.action_params:encode()
				local v1122, v1123 = proto.writeTag(buf, n69, 2, proto.wireTypes.lengthDelimited)

				buf, n69 = proto.writeBuffer(v1122, v1123, v1121, buffer.len(v1121))
			end

			local buf37 = buffer.create(n69)

			buffer.copy(buf37, 0, buf, 0, n69)

			return buf37
		end
		function t140.decode(p107: buffer) -- line: 10204
			-- upvalues: t140 (copy), proto (copy), t1 (copy)
			local v1126 = t140.new()
			local n70 = 0

			while n70 < buffer.len(p107) do
				local v1128, v1129

				v1128, v1129, n70 = proto.readTag(p107, n70)

				if v1129 == proto.wireTypes.varint then
					if v1128 == 1 then
						local v1130

						v1130, n70 = proto.readVarIntI32(p107, n70)
						v1126.action_type = t1.ActionType.fromNumber(v1130) or v1130
					else
						local v1131

						v1131, n70 = proto.readVarInt(p107, n70)
					end
				elseif v1129 == proto.wireTypes.lengthDelimited then
					if v1128 == 2 then
						local v1132

						v1132, n70 = proto.readBuffer(p107, n70)
						v1126.action_params = t1.OpenFacialAgeEstimationAction_Params.decode(v1132)
					else
						local v1133, v1134 = proto.readVarInt(p107, n70)

						n70 = v1134 + v1133
					end
				elseif v1129 == proto.wireTypes.i32 then
					local v1135

					v1135, n70 = proto.readFixed32(p107, n70)
				elseif v1129 == proto.wireTypes.i64 then
					local v1136

					v1136, n70 = proto.readFixed64(p107, n70)
				else
					error("Unsupported wire type: " .. v1129)
				end
			end

			return v1126
		end
		function t140.jsonEncode(p108) -- line: 10252
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
		function t140.jsonDecode(t143: {[any]: any}) -- line: 10274
			-- upvalues: t140 (copy), t1 (copy)
			local v1140 = t140.new()

			if t143.action_type ~= nil then
				v1140.action_type = if typeof(t143.action_type) ~= "number" then t1.ActionType.fromName(t143.action_type) or t143.action_type else t1.ActionType.fromNumber(t143.action_type) or t143.action_type
			end

			if t143.actionType ~= nil then
				v1140.action_type = if typeof(t143.actionType) ~= "number" then t1.ActionType.fromName(t143.actionType) or t143.actionType else t1.ActionType.fromNumber(t143.actionType) or t143.actionType
			end

			if t143.action_params ~= nil then
				v1140.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.action_params)
			end

			if t143.actionParams ~= nil then
				v1140.action_params = t1.OpenFacialAgeEstimationAction_Params.jsonDecode(t143.actionParams)
			end

			return v1140
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

		function t144.new(t145: {[any]: any}?) -- line: 10314
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
		function t144.encode(p109) -- line: 10327
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n71 = 0

			if p109.user_id ~= nil then
				local v1145 = p109.user_id:encode()
				local v1146, v1147 = proto.writeTag(buf, n71, 1, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1146, v1147, v1145, buffer.len(v1145))
			end

			if p109.source ~= nil then
				local v1148 = p109.source:encode()
				local v1149, v1150 = proto.writeTag(buf, n71, 2, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1149, v1150, v1148, buffer.len(v1148))
			end

			if p109.context ~= nil then
				local v1151 = p109.context:encode()
				local v1152, v1153 = proto.writeTag(buf, n71, 3, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1152, v1153, v1151, buffer.len(v1151))
			end

			if p109.is_in_experience ~= nil then
				local v1154 = p109.is_in_experience:encode()
				local v1155, v1156 = proto.writeTag(buf, n71, 4, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1155, v1156, v1154, buffer.len(v1154))
			end

			if p109.on_success ~= nil then
				local v1157 = p109.on_success:encode()
				local v1158, v1159 = proto.writeTag(buf, n71, 5, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1158, v1159, v1157, buffer.len(v1157))
			end

			if p109.on_failure ~= nil then
				local v1160 = p109.on_failure:encode()
				local v1161, v1162 = proto.writeTag(buf, n71, 6, proto.wireTypes.lengthDelimited)

				buf, n71 = proto.writeBuffer(v1161, v1162, v1160, buffer.len(v1160))
			end

			local buf38 = buffer.create(n71)

			buffer.copy(buf38, 0, buf, 0, n71)

			return buf38
		end
		function t144.decode(p110: buffer) -- line: 10372
			-- upvalues: t144 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1165 = t144.new()
			local n72 = 0

			while n72 < buffer.len(p110) do
				local v1167, v1168

				v1167, v1168, n72 = proto.readTag(p110, n72)

				if v1168 == proto.wireTypes.varint then
					local v1169

					v1169, n72 = proto.readVarInt(p110, n72)
				elseif v1168 == proto.wireTypes.lengthDelimited then
					if v1167 == 1 then
						local v1170

						v1170, n72 = proto.readBuffer(p110, n72)
						v1165.user_id = prop_types.StringProp.decode(v1170)
					elseif v1167 == 2 then
						local v1171

						v1171, n72 = proto.readBuffer(p110, n72)
						v1165.source = prop_types.StringProp.decode(v1171)
					elseif v1167 == 3 then
						local v1172

						v1172, n72 = proto.readBuffer(p110, n72)
						v1165.context = prop_types.StringProp.decode(v1172)
					elseif v1167 == 4 then
						local v1173

						v1173, n72 = proto.readBuffer(p110, n72)
						v1165.is_in_experience = prop_types.BoolProp.decode(v1173)
					elseif v1167 == 5 then
						local v1174

						v1174, n72 = proto.readBuffer(p110, n72)
						v1165.on_success = t1.ActionProp.decode(v1174)
					elseif v1167 == 6 then
						local v1175

						v1175, n72 = proto.readBuffer(p110, n72)
						v1165.on_failure = t1.ActionProp.decode(v1175)
					else
						local v1176, v1177 = proto.readVarInt(p110, n72)

						n72 = v1177 + v1176
					end
				elseif v1168 == proto.wireTypes.i32 then
					local v1178

					v1178, n72 = proto.readFixed32(p110, n72)
				elseif v1168 == proto.wireTypes.i64 then
					local v1179

					v1179, n72 = proto.readFixed64(p110, n72)
				else
					error("Unsupported wire type: " .. v1168)
				end
			end

			return v1165
		end
		function t144.jsonEncode(p111) -- line: 10440
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
		function t144.jsonDecode(t147: {[any]: any}) -- line: 10470
			-- upvalues: t144 (copy), prop_types (copy), t1 (copy)
			local v1183 = t144.new()

			if t147.user_id ~= nil then
				v1183.user_id = prop_types.StringProp.jsonDecode(t147.user_id)
			end

			if t147.userId ~= nil then
				v1183.user_id = prop_types.StringProp.jsonDecode(t147.userId)
			end

			if t147.source ~= nil then
				v1183.source = prop_types.StringProp.jsonDecode(t147.source)
			end

			if t147.context ~= nil then
				v1183.context = prop_types.StringProp.jsonDecode(t147.context)
			end

			if t147.is_in_experience ~= nil then
				v1183.is_in_experience = prop_types.BoolProp.jsonDecode(t147.is_in_experience)
			end

			if t147.isInExperience ~= nil then
				v1183.is_in_experience = prop_types.BoolProp.jsonDecode(t147.isInExperience)
			end

			if t147.on_success ~= nil then
				v1183.on_success = t1.ActionProp.jsonDecode(t147.on_success)
			end

			if t147.onSuccess ~= nil then
				v1183.on_success = t1.ActionProp.jsonDecode(t147.onSuccess)
			end

			if t147.on_failure ~= nil then
				v1183.on_failure = t1.ActionProp.jsonDecode(t147.on_failure)
			end

			if t147.onFailure ~= nil then
				v1183.on_failure = t1.ActionProp.jsonDecode(t147.onFailure)
			end

			return v1183
		end

		t144.descriptor = {
			name = "OpenFacialAgeEstimationAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFacialAgeEstimationAction_Params = t144
		typeRegistry.default:register(t1.OpenFacialAgeEstimationAction_Params)

		local t148 = {}

		t148.__index = t148

		function t148.new(t149: {[any]: any}?) -- line: 10534
			-- upvalues: t1 (copy), t148 (copy)
			return (setmetatable({
				action_type = if t149 ~= nil and t149.action_type ~= nil then t149.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t149 ~= nil and t149.action_params ~= nil then t149.action_params else nil
			}, t148))
		end
		function t148.encode(p112) -- line: 10545
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n73 = 0

			if p112.action_type ~= nil and (p112.action_type ~= nil and p112.action_type ~= 0 or p112.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1188, v1189 = proto.writeTag(buf, n73, 1, proto.wireTypes.varint)

				buf, n73 = proto.writeVarInt(v1188, v1189, t1.ActionType.toNumber(p112.action_type))
			end

			if p112.action_params ~= nil then
				local v1190 = p112.action_params:encode()
				local v1191, v1192 = proto.writeTag(buf, n73, 2, proto.wireTypes.lengthDelimited)

				buf, n73 = proto.writeBuffer(v1191, v1192, v1190, buffer.len(v1190))
			end

			local buf39 = buffer.create(n73)

			buffer.copy(buf39, 0, buf, 0, n73)

			return buf39
		end
		function t148.decode(p113: buffer) -- line: 10571
			-- upvalues: t148 (copy), proto (copy), t1 (copy)
			local v1195 = t148.new()
			local n74 = 0

			while n74 < buffer.len(p113) do
				local v1197, v1198

				v1197, v1198, n74 = proto.readTag(p113, n74)

				if v1198 == proto.wireTypes.varint then
					if v1197 == 1 then
						local v1199

						v1199, n74 = proto.readVarIntI32(p113, n74)
						v1195.action_type = t1.ActionType.fromNumber(v1199) or v1199
					else
						local v1200

						v1200, n74 = proto.readVarInt(p113, n74)
					end
				elseif v1198 == proto.wireTypes.lengthDelimited then
					if v1197 == 2 then
						local v1201

						v1201, n74 = proto.readBuffer(p113, n74)
						v1195.action_params = t1.OpenPhoneUpsellModalAction_Params.decode(v1201)
					else
						local v1202, v1203 = proto.readVarInt(p113, n74)

						n74 = v1203 + v1202
					end
				elseif v1198 == proto.wireTypes.i32 then
					local v1204

					v1204, n74 = proto.readFixed32(p113, n74)
				elseif v1198 == proto.wireTypes.i64 then
					local v1205

					v1205, n74 = proto.readFixed64(p113, n74)
				else
					error("Unsupported wire type: " .. v1198)
				end
			end

			return v1195
		end
		function t148.jsonEncode(p114) -- line: 10619
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
		function t148.jsonDecode(t151: {[any]: any}) -- line: 10641
			-- upvalues: t148 (copy), t1 (copy)
			local v1209 = t148.new()

			if t151.action_type ~= nil then
				v1209.action_type = if typeof(t151.action_type) ~= "number" then t1.ActionType.fromName(t151.action_type) or t151.action_type else t1.ActionType.fromNumber(t151.action_type) or t151.action_type
			end

			if t151.actionType ~= nil then
				v1209.action_type = if typeof(t151.actionType) ~= "number" then t1.ActionType.fromName(t151.actionType) or t151.actionType else t1.ActionType.fromNumber(t151.actionType) or t151.actionType
			end

			if t151.action_params ~= nil then
				v1209.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t151.action_params)
			end

			if t151.actionParams ~= nil then
				v1209.action_params = t1.OpenPhoneUpsellModalAction_Params.jsonDecode(t151.actionParams)
			end

			return v1209
		end

		t148.descriptor = {
			name = "OpenPhoneUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenPhoneUpsellModalAction"
		}
		t1.OpenPhoneUpsellModalAction = t148
	end

	typeRegistry.default:register(t1.OpenPhoneUpsellModalAction)

	do
		local t152 = {}

		t152.__index = t152

		function t152.new(t153: {[any]: any}?) -- line: 10681
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
		function t152.encode(p115) -- line: 10701
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n75 = 0

			if p115.voice_opt_in ~= nil then
				local v1214 = p115.voice_opt_in:encode()
				local v1215, v1216 = proto.writeTag(buf, n75, 1, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1215, v1216, v1214, buffer.len(v1214))
			end

			if p115.event_context ~= nil then
				local v1217 = p115.event_context:encode()
				local v1218, v1219 = proto.writeTag(buf, n75, 2, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1218, v1219, v1217, buffer.len(v1217))
			end

			if p115.origin ~= nil then
				local v1220 = p115.origin:encode()
				local v1221, v1222 = proto.writeTag(buf, n75, 3, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1221, v1222, v1220, buffer.len(v1220))
			end

			if p115.should_autofill_android_phone_number_at_launch ~= nil then
				local v1223 = p115.should_autofill_android_phone_number_at_launch:encode()
				local v1224, v1225 = proto.writeTag(buf, n75, 4, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1224, v1225, v1223, buffer.len(v1223))
			end

			if p115.add_phone_description_key ~= nil then
				local v1226 = p115.add_phone_description_key:encode()
				local v1227, v1228 = proto.writeTag(buf, n75, 5, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1227, v1228, v1226, buffer.len(v1226))
			end

			if p115.on_success ~= nil then
				local v1229 = p115.on_success:encode()
				local v1230, v1231 = proto.writeTag(buf, n75, 6, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1230, v1231, v1229, buffer.len(v1229))
			end

			if p115.on_failure ~= nil then
				local v1232 = p115.on_failure:encode()
				local v1233, v1234 = proto.writeTag(buf, n75, 7, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1233, v1234, v1232, buffer.len(v1232))
			end

			if p115.on_cancelled ~= nil then
				local v1235 = p115.on_cancelled:encode()
				local v1236, v1237 = proto.writeTag(buf, n75, 8, proto.wireTypes.lengthDelimited)

				buf, n75 = proto.writeBuffer(v1236, v1237, v1235, buffer.len(v1235))
			end

			local buf40 = buffer.create(n75)

			buffer.copy(buf40, 0, buf, 0, n75)

			return buf40
		end
		function t152.decode(p116: buffer) -- line: 10758
			-- upvalues: t152 (copy), proto (copy), prop_types (copy), t1 (copy)
			local v1240 = t152.new()
			local n76 = 0

			while n76 < buffer.len(p116) do
				local v1242, v1243

				v1242, v1243, n76 = proto.readTag(p116, n76)

				if v1243 == proto.wireTypes.varint then
					local v1244

					v1244, n76 = proto.readVarInt(p116, n76)
				elseif v1243 == proto.wireTypes.lengthDelimited then
					if v1242 == 1 then
						local v1245

						v1245, n76 = proto.readBuffer(p116, n76)
						v1240.voice_opt_in = prop_types.BoolProp.decode(v1245)
					elseif v1242 == 2 then
						local v1246

						v1246, n76 = proto.readBuffer(p116, n76)
						v1240.event_context = prop_types.StringProp.decode(v1246)
					elseif v1242 == 3 then
						local v1247

						v1247, n76 = proto.readBuffer(p116, n76)
						v1240.origin = prop_types.StringProp.decode(v1247)
					elseif v1242 == 4 then
						local v1248

						v1248, n76 = proto.readBuffer(p116, n76)
						v1240.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.decode(v1248)
					elseif v1242 == 5 then
						local v1249

						v1249, n76 = proto.readBuffer(p116, n76)
						v1240.add_phone_description_key = prop_types.StringProp.decode(v1249)
					elseif v1242 == 6 then
						local v1250

						v1250, n76 = proto.readBuffer(p116, n76)
						v1240.on_success = t1.ActionProp.decode(v1250)
					elseif v1242 == 7 then
						local v1251

						v1251, n76 = proto.readBuffer(p116, n76)
						v1240.on_failure = t1.ActionProp.decode(v1251)
					elseif v1242 == 8 then
						local v1252

						v1252, n76 = proto.readBuffer(p116, n76)
						v1240.on_cancelled = t1.ActionProp.decode(v1252)
					else
						local v1253, v1254 = proto.readVarInt(p116, n76)

						n76 = v1254 + v1253
					end
				elseif v1243 == proto.wireTypes.i32 then
					local v1255

					v1255, n76 = proto.readFixed32(p116, n76)
				elseif v1243 == proto.wireTypes.i64 then
					local v1256

					v1256, n76 = proto.readFixed64(p116, n76)
				else
					error("Unsupported wire type: " .. v1243)
				end
			end

			return v1240
		end
		function t152.jsonEncode(p117) -- line: 10838
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
		function t152.jsonDecode(t155: {[any]: any}) -- line: 10877
			-- upvalues: t152 (copy), prop_types (copy), t1 (copy)
			local v1260 = t152.new()

			if t155.voice_opt_in ~= nil then
				v1260.voice_opt_in = prop_types.BoolProp.jsonDecode(t155.voice_opt_in)
			end

			if t155.voiceOptIn ~= nil then
				v1260.voice_opt_in = prop_types.BoolProp.jsonDecode(t155.voiceOptIn)
			end

			if t155.event_context ~= nil then
				v1260.event_context = prop_types.StringProp.jsonDecode(t155.event_context)
			end

			if t155.eventContext ~= nil then
				v1260.event_context = prop_types.StringProp.jsonDecode(t155.eventContext)
			end

			if t155.origin ~= nil then
				v1260.origin = prop_types.StringProp.jsonDecode(t155.origin)
			end

			if t155.should_autofill_android_phone_number_at_launch ~= nil then
				v1260.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t155.should_autofill_android_phone_number_at_launch)
			end

			if t155.shouldAutofillAndroidPhoneNumberAtLaunch ~= nil then
				v1260.should_autofill_android_phone_number_at_launch = prop_types.BoolProp.jsonDecode(t155.shouldAutofillAndroidPhoneNumberAtLaunch)
			end

			if t155.add_phone_description_key ~= nil then
				v1260.add_phone_description_key = prop_types.StringProp.jsonDecode(t155.add_phone_description_key)
			end

			if t155.addPhoneDescriptionKey ~= nil then
				v1260.add_phone_description_key = prop_types.StringProp.jsonDecode(t155.addPhoneDescriptionKey)
			end

			if t155.on_success ~= nil then
				v1260.on_success = t1.ActionProp.jsonDecode(t155.on_success)
			end

			if t155.onSuccess ~= nil then
				v1260.on_success = t1.ActionProp.jsonDecode(t155.onSuccess)
			end

			if t155.on_failure ~= nil then
				v1260.on_failure = t1.ActionProp.jsonDecode(t155.on_failure)
			end

			if t155.onFailure ~= nil then
				v1260.on_failure = t1.ActionProp.jsonDecode(t155.onFailure)
			end

			if t155.on_cancelled ~= nil then
				v1260.on_cancelled = t1.ActionProp.jsonDecode(t155.on_cancelled)
			end

			if t155.onCancelled ~= nil then
				v1260.on_cancelled = t1.ActionProp.jsonDecode(t155.onCancelled)
			end

			return v1260
		end

		t152.descriptor = {
			name = "OpenPhoneUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPhoneUpsellModalAction_Params = t152
		typeRegistry.default:register(t1.OpenPhoneUpsellModalAction_Params)

		local t156 = {}

		t156.__index = t156

		function t156.new(t157: {[any]: any}?) -- line: 10970
			-- upvalues: t1 (copy), t156 (copy)
			return (setmetatable({
				action_type = if t157 ~= nil and t157.action_type ~= nil then t157.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t157 ~= nil and t157.action_params ~= nil then t157.action_params else nil
			}, t156))
		end
		function t156.encode(p118) -- line: 10981
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
		function t156.decode(p119: buffer) -- line: 11007
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
						v1272.action_params = t1.OpenEmailUpsellModalAction_Params.decode(v1278)
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
		function t156.jsonEncode(p120) -- line: 11055
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
		function t156.jsonDecode(t159: {[any]: any}) -- line: 11077
			-- upvalues: t156 (copy), t1 (copy)
			local v1286 = t156.new()

			if t159.action_type ~= nil then
				v1286.action_type = if typeof(t159.action_type) ~= "number" then t1.ActionType.fromName(t159.action_type) or t159.action_type else t1.ActionType.fromNumber(t159.action_type) or t159.action_type
			end

			if t159.actionType ~= nil then
				v1286.action_type = if typeof(t159.actionType) ~= "number" then t1.ActionType.fromName(t159.actionType) or t159.actionType else t1.ActionType.fromNumber(t159.actionType) or t159.actionType
			end

			if t159.action_params ~= nil then
				v1286.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t159.action_params)
			end

			if t159.actionParams ~= nil then
				v1286.action_params = t1.OpenEmailUpsellModalAction_Params.jsonDecode(t159.actionParams)
			end

			return v1286
		end

		t156.descriptor = {
			name = "OpenEmailUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenEmailUpsellModalAction"
		}
		t1.OpenEmailUpsellModalAction = t156
	end

	typeRegistry.default:register(t1.OpenEmailUpsellModalAction)

	do
		local t160 = {}

		t160.__index = t160

		function t160.new(t161: {[any]: any}?) -- line: 11117
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
		function t160.encode(p121) -- line: 11139
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n79 = 0

			if p121.add_email_over13_text_key ~= nil then
				local v1291 = p121.add_email_over13_text_key:encode()
				local v1292, v1293 = proto.writeTag(buf, n79, 1, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1292, v1293, v1291, buffer.len(v1291))
			end

			if p121.add_email_title_key ~= nil then
				local v1294 = p121.add_email_title_key:encode()
				local v1295, v1296 = proto.writeTag(buf, n79, 2, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1295, v1296, v1294, buffer.len(v1294))
			end

			if p121.is_email_modal_called_from_home_page ~= nil then
				local v1297 = p121.is_email_modal_called_from_home_page:encode()
				local v1298, v1299 = proto.writeTag(buf, n79, 3, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1298, v1299, v1297, buffer.len(v1297))
			end

			if p121.event_context ~= nil then
				local v1300 = p121.event_context:encode()
				local v1301, v1302 = proto.writeTag(buf, n79, 4, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1301, v1302, v1300, buffer.len(v1300))
			end

			if p121.origin ~= nil then
				local v1303 = p121.origin:encode()
				local v1304, v1305 = proto.writeTag(buf, n79, 5, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1304, v1305, v1303, buffer.len(v1303))
			end

			if p121.section ~= nil then
				local v1306 = p121.section:encode()
				local v1307, v1308 = proto.writeTag(buf, n79, 6, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1307, v1308, v1306, buffer.len(v1306))
			end

			if p121.on_success ~= nil then
				local v1309 = p121.on_success:encode()
				local v1310, v1311 = proto.writeTag(buf, n79, 7, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1310, v1311, v1309, buffer.len(v1309))
			end

			if p121.on_failure ~= nil then
				local v1312 = p121.on_failure:encode()
				local v1313, v1314 = proto.writeTag(buf, n79, 8, proto.wireTypes.lengthDelimited)

				buf, n79 = proto.writeBuffer(v1313, v1314, v1312, buffer.len(v1312))
			end

			local buf42 = buffer.create(n79)

			buffer.copy(buf42, 0, buf, 0, n79)

			return buf42
		end
		function t160.decode(p122: buffer) -- line: 11196
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
						v1317.add_email_over13_text_key = prop_types.StringProp.decode(v1322)
					elseif v1319 == 2 then
						local v1323

						v1323, n80 = proto.readBuffer(p122, n80)
						v1317.add_email_title_key = prop_types.StringProp.decode(v1323)
					elseif v1319 == 3 then
						local v1324

						v1324, n80 = proto.readBuffer(p122, n80)
						v1317.is_email_modal_called_from_home_page = prop_types.BoolProp.decode(v1324)
					elseif v1319 == 4 then
						local v1325

						v1325, n80 = proto.readBuffer(p122, n80)
						v1317.event_context = prop_types.StringProp.decode(v1325)
					elseif v1319 == 5 then
						local v1326

						v1326, n80 = proto.readBuffer(p122, n80)
						v1317.origin = prop_types.StringProp.decode(v1326)
					elseif v1319 == 6 then
						local v1327

						v1327, n80 = proto.readBuffer(p122, n80)
						v1317.section = prop_types.StringProp.decode(v1327)
					elseif v1319 == 7 then
						local v1328

						v1328, n80 = proto.readBuffer(p122, n80)
						v1317.on_success = t1.ActionProp.decode(v1328)
					elseif v1319 == 8 then
						local v1329

						v1329, n80 = proto.readBuffer(p122, n80)
						v1317.on_failure = t1.ActionProp.decode(v1329)
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
		function t160.jsonEncode(p123) -- line: 11277
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
		function t160.jsonDecode(t163: {[any]: any}) -- line: 11315
			-- upvalues: t160 (copy), prop_types (copy), t1 (copy)
			local v1337 = t160.new()

			if t163.add_email_over13_text_key ~= nil then
				v1337.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t163.add_email_over13_text_key)
			end

			if t163.addEmailOver13TextKey ~= nil then
				v1337.add_email_over13_text_key = prop_types.StringProp.jsonDecode(t163.addEmailOver13TextKey)
			end

			if t163.add_email_title_key ~= nil then
				v1337.add_email_title_key = prop_types.StringProp.jsonDecode(t163.add_email_title_key)
			end

			if t163.addEmailTitleKey ~= nil then
				v1337.add_email_title_key = prop_types.StringProp.jsonDecode(t163.addEmailTitleKey)
			end

			if t163.is_email_modal_called_from_home_page ~= nil then
				v1337.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t163.is_email_modal_called_from_home_page)
			end

			if t163.isEmailModalCalledFromHomePage ~= nil then
				v1337.is_email_modal_called_from_home_page = prop_types.BoolProp.jsonDecode(t163.isEmailModalCalledFromHomePage)
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

			if t163.section ~= nil then
				v1337.section = prop_types.StringProp.jsonDecode(t163.section)
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

			return v1337
		end

		t160.descriptor = {
			name = "OpenEmailUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEmailUpsellModalAction_Params = t160
		typeRegistry.default:register(t1.OpenEmailUpsellModalAction_Params)

		local t164 = {}

		t164.__index = t164

		function t164.new(t165: {[any]: any}?) -- line: 11405
			-- upvalues: t1 (copy), t164 (copy)
			return (setmetatable({
				action_type = if t165 ~= nil and t165.action_type ~= nil then t165.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t165 ~= nil and t165.action_params ~= nil then t165.action_params else nil
			}, t164))
		end
		function t164.encode(p124) -- line: 11416
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
		function t164.decode(p125: buffer) -- line: 11442
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
						v1349.action_params = t1.OpenAddConnectionsPageAction_Params.decode(v1355)
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
		function t164.jsonEncode(p126) -- line: 11490
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
		function t164.jsonDecode(t167: {[any]: any}) -- line: 11512
			-- upvalues: t164 (copy), t1 (copy)
			local v1363 = t164.new()

			if t167.action_type ~= nil then
				v1363.action_type = if typeof(t167.action_type) ~= "number" then t1.ActionType.fromName(t167.action_type) or t167.action_type else t1.ActionType.fromNumber(t167.action_type) or t167.action_type
			end

			if t167.actionType ~= nil then
				v1363.action_type = if typeof(t167.actionType) ~= "number" then t1.ActionType.fromName(t167.actionType) or t167.actionType else t1.ActionType.fromNumber(t167.actionType) or t167.actionType
			end

			if t167.action_params ~= nil then
				v1363.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t167.action_params)
			end

			if t167.actionParams ~= nil then
				v1363.action_params = t1.OpenAddConnectionsPageAction_Params.jsonDecode(t167.actionParams)
			end

			return v1363
		end

		t164.descriptor = {
			name = "OpenAddConnectionsPageAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenAddConnectionsPageAction"
		}
		t1.OpenAddConnectionsPageAction = t164
	end

	typeRegistry.default:register(t1.OpenAddConnectionsPageAction)

	do
		local t168 = {}

		t168.__index = t168

		function t168.new(t169: {[any]: any}?) -- line: 11552
			-- upvalues: t168 (copy)
			return (setmetatable({
				user_id = if t169 ~= nil and t169.user_id ~= nil then t169.user_id else nil,
				source = if t169 ~= nil and t169.source ~= nil then t169.source else nil
			}, t168))
		end
		function t168.encode(p127) -- line: 11561
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n83 = 0

			if p127.user_id ~= nil then
				local v1368 = p127.user_id:encode()
				local v1369, v1370 = proto.writeTag(buf, n83, 1, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1369, v1370, v1368, buffer.len(v1368))
			end

			if p127.source ~= nil then
				local v1371 = p127.source:encode()
				local v1372, v1373 = proto.writeTag(buf, n83, 2, proto.wireTypes.lengthDelimited)

				buf, n83 = proto.writeBuffer(v1372, v1373, v1371, buffer.len(v1371))
			end

			local buf44 = buffer.create(n83)

			buffer.copy(buf44, 0, buf, 0, n83)

			return buf44
		end
		function t168.decode(p128: buffer) -- line: 11582
			-- upvalues: t168 (copy), proto (copy), prop_types (copy)
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
						v1376.user_id = prop_types.StringProp.decode(v1381)
					elseif v1378 == 2 then
						local v1382

						v1382, n84 = proto.readBuffer(p128, n84)
						v1376.source = prop_types.StringProp.decode(v1382)
					else
						local v1383, v1384 = proto.readVarInt(p128, n84)

						n84 = v1384 + v1383
					end
				elseif v1379 == proto.wireTypes.i32 then
					local v1385

					v1385, n84 = proto.readFixed32(p128, n84)
				elseif v1379 == proto.wireTypes.i64 then
					local v1386

					v1386, n84 = proto.readFixed64(p128, n84)
				else
					error("Unsupported wire type: " .. v1379)
				end
			end

			return v1376
		end
		function t168.jsonEncode(p129) -- line: 11630
			local t170 = {}

			if p129.user_id ~= nil then
				t170.userId = p129.user_id:jsonEncode()
			end

			if p129.source ~= nil then
				t170.source = p129.source:jsonEncode()
			end

			return t170
		end
		function t168.jsonDecode(t171: {[any]: any}) -- line: 11644
			-- upvalues: t168 (copy), prop_types (copy)
			local v1390 = t168.new()

			if t171.user_id ~= nil then
				v1390.user_id = prop_types.StringProp.jsonDecode(t171.user_id)
			end

			if t171.userId ~= nil then
				v1390.user_id = prop_types.StringProp.jsonDecode(t171.userId)
			end

			if t171.source ~= nil then
				v1390.source = prop_types.StringProp.jsonDecode(t171.source)
			end

			return v1390
		end

		t168.descriptor = {
			name = "OpenAddConnectionsPageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAddConnectionsPageAction_Params = t168
		typeRegistry.default:register(t1.OpenAddConnectionsPageAction_Params)

		local t172 = {}

		t172.__index = t172

		function t172.new(t173: {[any]: any}?) -- line: 11678
			-- upvalues: t1 (copy), t172 (copy)
			return (setmetatable({
				action_type = if t173 ~= nil and t173.action_type ~= nil then t173.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t173 ~= nil and t173.action_params ~= nil then t173.action_params else nil
			}, t172))
		end
		function t172.encode(p130) -- line: 11687
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n85 = 0

			if p130.action_type ~= nil and (p130.action_type ~= nil and p130.action_type ~= 0 or p130.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1395, v1396 = proto.writeTag(buf, n85, 1, proto.wireTypes.varint)

				buf, n85 = proto.writeVarInt(v1395, v1396, t1.ActionType.toNumber(p130.action_type))
			end

			if p130.action_params ~= nil then
				local v1397 = p130.action_params:encode()
				local v1398, v1399 = proto.writeTag(buf, n85, 2, proto.wireTypes.lengthDelimited)

				buf, n85 = proto.writeBuffer(v1398, v1399, v1397, buffer.len(v1397))
			end

			local buf45 = buffer.create(n85)

			buffer.copy(buf45, 0, buf, 0, n85)

			return buf45
		end
		function t172.decode(p131: buffer) -- line: 11713
			-- upvalues: t172 (copy), proto (copy), t1 (copy)
			local v1402 = t172.new()
			local n86 = 0

			while n86 < buffer.len(p131) do
				local v1404, v1405

				v1404, v1405, n86 = proto.readTag(p131, n86)

				if v1405 == proto.wireTypes.varint then
					if v1404 == 1 then
						local v1406

						v1406, n86 = proto.readVarIntI32(p131, n86)
						v1402.action_type = t1.ActionType.fromNumber(v1406) or v1406
					else
						local v1407

						v1407, n86 = proto.readVarInt(p131, n86)
					end
				elseif v1405 == proto.wireTypes.lengthDelimited then
					if v1404 == 2 then
						local v1408

						v1408, n86 = proto.readBuffer(p131, n86)
						v1402.action_params = t1.OpenMarketplaceAction_Params.decode(v1408)
					else
						local v1409, v1410 = proto.readVarInt(p131, n86)

						n86 = v1410 + v1409
					end
				elseif v1405 == proto.wireTypes.i32 then
					local v1411

					v1411, n86 = proto.readFixed32(p131, n86)
				elseif v1405 == proto.wireTypes.i64 then
					local v1412

					v1412, n86 = proto.readFixed64(p131, n86)
				else
					error("Unsupported wire type: " .. v1405)
				end
			end

			return v1402
		end
		function t172.jsonEncode(p132) -- line: 11761
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
		function t172.jsonDecode(t175: {[any]: any}) -- line: 11783
			-- upvalues: t172 (copy), t1 (copy)
			local v1416 = t172.new()

			if t175.action_type ~= nil then
				v1416.action_type = if typeof(t175.action_type) ~= "number" then t1.ActionType.fromName(t175.action_type) or t175.action_type else t1.ActionType.fromNumber(t175.action_type) or t175.action_type
			end

			if t175.actionType ~= nil then
				v1416.action_type = if typeof(t175.actionType) ~= "number" then t1.ActionType.fromName(t175.actionType) or t175.actionType else t1.ActionType.fromNumber(t175.actionType) or t175.actionType
			end

			if t175.action_params ~= nil then
				v1416.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t175.action_params)
			end

			if t175.actionParams ~= nil then
				v1416.action_params = t1.OpenMarketplaceAction_Params.jsonDecode(t175.actionParams)
			end

			return v1416
		end

		t172.descriptor = {
			name = "OpenMarketplaceAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceAction"
		}
		t1.OpenMarketplaceAction = t172
	end

	typeRegistry.default:register(t1.OpenMarketplaceAction)

	do
		local t176 = {}

		t176.__index = t176

		function t176.new(t177: {[any]: any}?) -- line: 11823
			-- upvalues: t176 (copy)
			return (setmetatable({
				user_id = if t177 ~= nil and t177.user_id ~= nil then t177.user_id else nil,
				source = if t177 ~= nil and t177.source ~= nil then t177.source else nil
			}, t176))
		end
		function t176.encode(p133) -- line: 11832
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n87 = 0

			if p133.user_id ~= nil then
				local v1421 = p133.user_id:encode()
				local v1422, v1423 = proto.writeTag(buf, n87, 1, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1422, v1423, v1421, buffer.len(v1421))
			end

			if p133.source ~= nil then
				local v1424 = p133.source:encode()
				local v1425, v1426 = proto.writeTag(buf, n87, 2, proto.wireTypes.lengthDelimited)

				buf, n87 = proto.writeBuffer(v1425, v1426, v1424, buffer.len(v1424))
			end

			local buf46 = buffer.create(n87)

			buffer.copy(buf46, 0, buf, 0, n87)

			return buf46
		end
		function t176.decode(p134: buffer) -- line: 11853
			-- upvalues: t176 (copy), proto (copy), prop_types (copy)
			local v1429 = t176.new()
			local n88 = 0

			while n88 < buffer.len(p134) do
				local v1431, v1432

				v1431, v1432, n88 = proto.readTag(p134, n88)

				if v1432 == proto.wireTypes.varint then
					local v1433

					v1433, n88 = proto.readVarInt(p134, n88)
				elseif v1432 == proto.wireTypes.lengthDelimited then
					if v1431 == 1 then
						local v1434

						v1434, n88 = proto.readBuffer(p134, n88)
						v1429.user_id = prop_types.StringProp.decode(v1434)
					elseif v1431 == 2 then
						local v1435

						v1435, n88 = proto.readBuffer(p134, n88)
						v1429.source = prop_types.StringProp.decode(v1435)
					else
						local v1436, v1437 = proto.readVarInt(p134, n88)

						n88 = v1437 + v1436
					end
				elseif v1432 == proto.wireTypes.i32 then
					local v1438

					v1438, n88 = proto.readFixed32(p134, n88)
				elseif v1432 == proto.wireTypes.i64 then
					local v1439

					v1439, n88 = proto.readFixed64(p134, n88)
				else
					error("Unsupported wire type: " .. v1432)
				end
			end

			return v1429
		end
		function t176.jsonEncode(p135) -- line: 11901
			local t178 = {}

			if p135.user_id ~= nil then
				t178.userId = p135.user_id:jsonEncode()
			end

			if p135.source ~= nil then
				t178.source = p135.source:jsonEncode()
			end

			return t178
		end
		function t176.jsonDecode(t179: {[any]: any}) -- line: 11915
			-- upvalues: t176 (copy), prop_types (copy)
			local v1443 = t176.new()

			if t179.user_id ~= nil then
				v1443.user_id = prop_types.StringProp.jsonDecode(t179.user_id)
			end

			if t179.userId ~= nil then
				v1443.user_id = prop_types.StringProp.jsonDecode(t179.userId)
			end

			if t179.source ~= nil then
				v1443.source = prop_types.StringProp.jsonDecode(t179.source)
			end

			return v1443
		end

		t176.descriptor = {
			name = "OpenMarketplaceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceAction_Params = t176
		typeRegistry.default:register(t1.OpenMarketplaceAction_Params)

		local t180 = {}

		t180.__index = t180

		function t180.new(t181: {[any]: any}?) -- line: 11947
			-- upvalues: t1 (copy), t180 (copy)
			return (setmetatable({
				action_type = if t181 ~= nil and t181.action_type ~= nil then t181.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t181 ~= nil and t181.action_params ~= nil then t181.action_params else nil
			}, t180))
		end
		function t180.encode(p136) -- line: 11958
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n89 = 0

			if p136.action_type ~= nil and (p136.action_type ~= nil and p136.action_type ~= 0 or p136.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1448, v1449 = proto.writeTag(buf, n89, 1, proto.wireTypes.varint)

				buf, n89 = proto.writeVarInt(v1448, v1449, t1.ActionType.toNumber(p136.action_type))
			end

			if p136.action_params ~= nil then
				local v1450 = p136.action_params:encode()
				local v1451, v1452 = proto.writeTag(buf, n89, 2, proto.wireTypes.lengthDelimited)

				buf, n89 = proto.writeBuffer(v1451, v1452, v1450, buffer.len(v1450))
			end

			local buf47 = buffer.create(n89)

			buffer.copy(buf47, 0, buf, 0, n89)

			return buf47
		end
		function t180.decode(p137: buffer) -- line: 11984
			-- upvalues: t180 (copy), proto (copy), t1 (copy)
			local v1455 = t180.new()
			local n90 = 0

			while n90 < buffer.len(p137) do
				local v1457, v1458

				v1457, v1458, n90 = proto.readTag(p137, n90)

				if v1458 == proto.wireTypes.varint then
					if v1457 == 1 then
						local v1459

						v1459, n90 = proto.readVarIntI32(p137, n90)
						v1455.action_type = t1.ActionType.fromNumber(v1459) or v1459
					else
						local v1460

						v1460, n90 = proto.readVarInt(p137, n90)
					end
				elseif v1458 == proto.wireTypes.lengthDelimited then
					if v1457 == 2 then
						local v1461

						v1461, n90 = proto.readBuffer(p137, n90)
						v1455.action_params = t1.HideProfileCompletionAction_Params.decode(v1461)
					else
						local v1462, v1463 = proto.readVarInt(p137, n90)

						n90 = v1463 + v1462
					end
				elseif v1458 == proto.wireTypes.i32 then
					local v1464

					v1464, n90 = proto.readFixed32(p137, n90)
				elseif v1458 == proto.wireTypes.i64 then
					local v1465

					v1465, n90 = proto.readFixed64(p137, n90)
				else
					error("Unsupported wire type: " .. v1458)
				end
			end

			return v1455
		end
		function t180.jsonEncode(p138) -- line: 12032
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
		function t180.jsonDecode(t183: {[any]: any}) -- line: 12054
			-- upvalues: t180 (copy), t1 (copy)
			local v1469 = t180.new()

			if t183.action_type ~= nil then
				v1469.action_type = if typeof(t183.action_type) ~= "number" then t1.ActionType.fromName(t183.action_type) or t183.action_type else t1.ActionType.fromNumber(t183.action_type) or t183.action_type
			end

			if t183.actionType ~= nil then
				v1469.action_type = if typeof(t183.actionType) ~= "number" then t1.ActionType.fromName(t183.actionType) or t183.actionType else t1.ActionType.fromNumber(t183.actionType) or t183.actionType
			end

			if t183.action_params ~= nil then
				v1469.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t183.action_params)
			end

			if t183.actionParams ~= nil then
				v1469.action_params = t1.HideProfileCompletionAction_Params.jsonDecode(t183.actionParams)
			end

			return v1469
		end

		t180.descriptor = {
			name = "HideProfileCompletionAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.HideProfileCompletionAction"
		}
		t1.HideProfileCompletionAction = t180
	end

	typeRegistry.default:register(t1.HideProfileCompletionAction)

	do
		local t184 = {}

		t184.__index = t184

		function t184.new(t185: {[any]: any}?) -- line: 12094
			-- upvalues: t184 (copy)
			return (setmetatable({
				user_id = if t185 ~= nil and t185.user_id ~= nil then t185.user_id else nil,
				prompt_id = if t185 ~= nil and t185.prompt_id ~= nil then t185.prompt_id else nil,
				source = if t185 ~= nil and t185.source ~= nil then t185.source else nil,
				prompt_type = if t185 ~= nil and t185.prompt_type ~= nil then t185.prompt_type else nil
			}, t184))
		end
		function t184.encode(p139) -- line: 12105
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n91 = 0

			if p139.user_id ~= nil then
				local v1474 = p139.user_id:encode()
				local v1475, v1476 = proto.writeTag(buf, n91, 1, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1475, v1476, v1474, buffer.len(v1474))
			end

			if p139.prompt_id ~= nil then
				local v1477 = p139.prompt_id:encode()
				local v1478, v1479 = proto.writeTag(buf, n91, 2, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1478, v1479, v1477, buffer.len(v1477))
			end

			if p139.source ~= nil then
				local v1480 = p139.source:encode()
				local v1481, v1482 = proto.writeTag(buf, n91, 3, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1481, v1482, v1480, buffer.len(v1480))
			end

			if p139.prompt_type ~= nil then
				local v1483 = p139.prompt_type:encode()
				local v1484, v1485 = proto.writeTag(buf, n91, 4, proto.wireTypes.lengthDelimited)

				buf, n91 = proto.writeBuffer(v1484, v1485, v1483, buffer.len(v1483))
			end

			local buf48 = buffer.create(n91)

			buffer.copy(buf48, 0, buf, 0, n91)

			return buf48
		end
		function t184.decode(p140: buffer) -- line: 12138
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
						v1488.prompt_id = prop_types.StringProp.decode(v1494)
					elseif v1490 == 3 then
						local v1495

						v1495, n92 = proto.readBuffer(p140, n92)
						v1488.source = prop_types.StringProp.decode(v1495)
					elseif v1490 == 4 then
						local v1496

						v1496, n92 = proto.readBuffer(p140, n92)
						v1488.prompt_type = prop_types.StringProp.decode(v1496)
					else
						local v1497, v1498 = proto.readVarInt(p140, n92)

						n92 = v1498 + v1497
					end
				elseif v1491 == proto.wireTypes.i32 then
					local v1499

					v1499, n92 = proto.readFixed32(p140, n92)
				elseif v1491 == proto.wireTypes.i64 then
					local v1500

					v1500, n92 = proto.readFixed64(p140, n92)
				else
					error("Unsupported wire type: " .. v1491)
				end
			end

			return v1488
		end
		function t184.jsonEncode(p141) -- line: 12196
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
		function t184.jsonDecode(t187: {[any]: any}) -- line: 12218
			-- upvalues: t184 (copy), prop_types (copy)
			local v1504 = t184.new()

			if t187.user_id ~= nil then
				v1504.user_id = prop_types.StringProp.jsonDecode(t187.user_id)
			end

			if t187.userId ~= nil then
				v1504.user_id = prop_types.StringProp.jsonDecode(t187.userId)
			end

			if t187.prompt_id ~= nil then
				v1504.prompt_id = prop_types.StringProp.jsonDecode(t187.prompt_id)
			end

			if t187.promptId ~= nil then
				v1504.prompt_id = prop_types.StringProp.jsonDecode(t187.promptId)
			end

			if t187.source ~= nil then
				v1504.source = prop_types.StringProp.jsonDecode(t187.source)
			end

			if t187.prompt_type ~= nil then
				v1504.prompt_type = prop_types.StringProp.jsonDecode(t187.prompt_type)
			end

			if t187.promptType ~= nil then
				v1504.prompt_type = prop_types.StringProp.jsonDecode(t187.promptType)
			end

			return v1504
		end

		t184.descriptor = {
			name = "HideProfileCompletionAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.HideProfileCompletionAction_Params = t184
		typeRegistry.default:register(t1.HideProfileCompletionAction_Params)

		local t188 = {}

		t188.__index = t188

		function t188.new(t189: {[any]: any}?) -- line: 12269
			-- upvalues: t1 (copy), t188 (copy)
			return (setmetatable({
				action_type = if t189 ~= nil and t189.action_type ~= nil then t189.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t189 ~= nil and t189.action_params ~= nil then t189.action_params else nil
			}, t188))
		end
		function t188.encode(p142) -- line: 12280
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n93 = 0

			if p142.action_type ~= nil and (p142.action_type ~= nil and p142.action_type ~= 0 or p142.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1509, v1510 = proto.writeTag(buf, n93, 1, proto.wireTypes.varint)

				buf, n93 = proto.writeVarInt(v1509, v1510, t1.ActionType.toNumber(p142.action_type))
			end

			if p142.action_params ~= nil then
				local v1511 = p142.action_params:encode()
				local v1512, v1513 = proto.writeTag(buf, n93, 2, proto.wireTypes.lengthDelimited)

				buf, n93 = proto.writeBuffer(v1512, v1513, v1511, buffer.len(v1511))
			end

			local buf49 = buffer.create(n93)

			buffer.copy(buf49, 0, buf, 0, n93)

			return buf49
		end
		function t188.decode(p143: buffer) -- line: 12306
			-- upvalues: t188 (copy), proto (copy), t1 (copy)
			local v1516 = t188.new()
			local n94 = 0

			while n94 < buffer.len(p143) do
				local v1518, v1519

				v1518, v1519, n94 = proto.readTag(p143, n94)

				if v1519 == proto.wireTypes.varint then
					if v1518 == 1 then
						local v1520

						v1520, n94 = proto.readVarIntI32(p143, n94)
						v1516.action_type = t1.ActionType.fromNumber(v1520) or v1520
					else
						local v1521

						v1521, n94 = proto.readVarInt(p143, n94)
					end
				elseif v1519 == proto.wireTypes.lengthDelimited then
					if v1518 == 2 then
						local v1522

						v1522, n94 = proto.readBuffer(p143, n94)
						v1516.action_params = t1.SelectMarketplaceCatalogCategory_Params.decode(v1522)
					else
						local v1523, v1524 = proto.readVarInt(p143, n94)

						n94 = v1524 + v1523
					end
				elseif v1519 == proto.wireTypes.i32 then
					local v1525

					v1525, n94 = proto.readFixed32(p143, n94)
				elseif v1519 == proto.wireTypes.i64 then
					local v1526

					v1526, n94 = proto.readFixed64(p143, n94)
				else
					error("Unsupported wire type: " .. v1519)
				end
			end

			return v1516
		end
		function t188.jsonEncode(p144) -- line: 12354
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
		function t188.jsonDecode(t191: {[any]: any}) -- line: 12376
			-- upvalues: t188 (copy), t1 (copy)
			local v1530 = t188.new()

			if t191.action_type ~= nil then
				v1530.action_type = if typeof(t191.action_type) ~= "number" then t1.ActionType.fromName(t191.action_type) or t191.action_type else t1.ActionType.fromNumber(t191.action_type) or t191.action_type
			end

			if t191.actionType ~= nil then
				v1530.action_type = if typeof(t191.actionType) ~= "number" then t1.ActionType.fromName(t191.actionType) or t191.actionType else t1.ActionType.fromNumber(t191.actionType) or t191.actionType
			end

			if t191.action_params ~= nil then
				v1530.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t191.action_params)
			end

			if t191.actionParams ~= nil then
				v1530.action_params = t1.SelectMarketplaceCatalogCategory_Params.jsonDecode(t191.actionParams)
			end

			return v1530
		end

		t188.descriptor = {
			name = "SelectMarketplaceCatalogCategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogCategory"
		}
		t1.SelectMarketplaceCatalogCategory = t188
	end

	typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory)

	do
		local t192 = {}

		t192.__index = t192

		function t192.new(t193: {[any]: any}?) -- line: 12418
			-- upvalues: t192 (copy)
			return (setmetatable({
				category_id = if t193 ~= nil and t193.category_id ~= nil then t193.category_id else nil
			}, t192))
		end
		function t192.encode(p145) -- line: 12426
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n95 = 0

			if p145.category_id ~= nil then
				local v1535 = p145.category_id:encode()
				local v1536, v1537 = proto.writeTag(buf, n95, 1, proto.wireTypes.lengthDelimited)

				buf, n95 = proto.writeBuffer(v1536, v1537, v1535, buffer.len(v1535))
			end

			local buf50 = buffer.create(n95)

			buffer.copy(buf50, 0, buf, 0, n95)

			return buf50
		end
		function t192.decode(p146: buffer) -- line: 12441
			-- upvalues: t192 (copy), proto (copy), prop_types (copy)
			local v1540 = t192.new()
			local n96 = 0

			while n96 < buffer.len(p146) do
				local v1542, v1543

				v1542, v1543, n96 = proto.readTag(p146, n96)

				if v1543 == proto.wireTypes.varint then
					local v1544

					v1544, n96 = proto.readVarInt(p146, n96)
				elseif v1543 == proto.wireTypes.lengthDelimited then
					if v1542 == 1 then
						local v1545

						v1545, n96 = proto.readBuffer(p146, n96)
						v1540.category_id = prop_types.StringProp.decode(v1545)
					else
						local v1546, v1547 = proto.readVarInt(p146, n96)

						n96 = v1547 + v1546
					end
				elseif v1543 == proto.wireTypes.i32 then
					local v1548

					v1548, n96 = proto.readFixed32(p146, n96)
				elseif v1543 == proto.wireTypes.i64 then
					local v1549

					v1549, n96 = proto.readFixed64(p146, n96)
				else
					error("Unsupported wire type: " .. v1543)
				end
			end

			return v1540
		end
		function t192.jsonEncode(p147) -- line: 12484
			local t194 = {}

			if p147.category_id ~= nil then
				t194.categoryId = p147.category_id:jsonEncode()
			end

			return t194
		end
		function t192.jsonDecode(t195: {[any]: any}) -- line: 12494
			-- upvalues: t192 (copy), prop_types (copy)
			local v1553 = t192.new()

			if t195.category_id ~= nil then
				v1553.category_id = prop_types.StringProp.jsonDecode(t195.category_id)
			end

			if t195.categoryId ~= nil then
				v1553.category_id = prop_types.StringProp.jsonDecode(t195.categoryId)
			end

			return v1553
		end

		t192.descriptor = {
			name = "SelectMarketplaceCatalogCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogCategory_Params = t192
		typeRegistry.default:register(t1.SelectMarketplaceCatalogCategory_Params)

		local t196 = {}

		t196.__index = t196

		function t196.new(t197: {[any]: any}?) -- line: 12525
			-- upvalues: t1 (copy), t196 (copy)
			return (setmetatable({
				action_type = if t197 ~= nil and t197.action_type ~= nil then t197.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t197 ~= nil and t197.action_params ~= nil then t197.action_params else nil
			}, t196))
		end
		function t196.encode(p148) -- line: 12536
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n97 = 0

			if p148.action_type ~= nil and (p148.action_type ~= nil and p148.action_type ~= 0 or p148.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1558, v1559 = proto.writeTag(buf, n97, 1, proto.wireTypes.varint)

				buf, n97 = proto.writeVarInt(v1558, v1559, t1.ActionType.toNumber(p148.action_type))
			end

			if p148.action_params ~= nil then
				local v1560 = p148.action_params:encode()
				local v1561, v1562 = proto.writeTag(buf, n97, 2, proto.wireTypes.lengthDelimited)

				buf, n97 = proto.writeBuffer(v1561, v1562, v1560, buffer.len(v1560))
			end

			local buf51 = buffer.create(n97)

			buffer.copy(buf51, 0, buf, 0, n97)

			return buf51
		end
		function t196.decode(p149: buffer) -- line: 12562
			-- upvalues: t196 (copy), proto (copy), t1 (copy)
			local v1565 = t196.new()
			local n98 = 0

			while n98 < buffer.len(p149) do
				local v1567, v1568

				v1567, v1568, n98 = proto.readTag(p149, n98)

				if v1568 == proto.wireTypes.varint then
					if v1567 == 1 then
						local v1569

						v1569, n98 = proto.readVarIntI32(p149, n98)
						v1565.action_type = t1.ActionType.fromNumber(v1569) or v1569
					else
						local v1570

						v1570, n98 = proto.readVarInt(p149, n98)
					end
				elseif v1568 == proto.wireTypes.lengthDelimited then
					if v1567 == 2 then
						local v1571

						v1571, n98 = proto.readBuffer(p149, n98)
						v1565.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.decode(v1571)
					else
						local v1572, v1573 = proto.readVarInt(p149, n98)

						n98 = v1573 + v1572
					end
				elseif v1568 == proto.wireTypes.i32 then
					local v1574

					v1574, n98 = proto.readFixed32(p149, n98)
				elseif v1568 == proto.wireTypes.i64 then
					local v1575

					v1575, n98 = proto.readFixed64(p149, n98)
				else
					error("Unsupported wire type: " .. v1568)
				end
			end

			return v1565
		end
		function t196.jsonEncode(p150) -- line: 12610
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
		function t196.jsonDecode(t199: {[any]: any}) -- line: 12632
			-- upvalues: t196 (copy), t1 (copy)
			local v1579 = t196.new()

			if t199.action_type ~= nil then
				v1579.action_type = if typeof(t199.action_type) ~= "number" then t1.ActionType.fromName(t199.action_type) or t199.action_type else t1.ActionType.fromNumber(t199.action_type) or t199.action_type
			end

			if t199.actionType ~= nil then
				v1579.action_type = if typeof(t199.actionType) ~= "number" then t1.ActionType.fromName(t199.actionType) or t199.actionType else t1.ActionType.fromNumber(t199.actionType) or t199.actionType
			end

			if t199.action_params ~= nil then
				v1579.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t199.action_params)
			end

			if t199.actionParams ~= nil then
				v1579.action_params = t1.SelectMarketplaceCatalogSubcategory_Params.jsonDecode(t199.actionParams)
			end

			return v1579
		end

		t196.descriptor = {
			name = "SelectMarketplaceCatalogSubcategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceCatalogSubcategory"
		}
		t1.SelectMarketplaceCatalogSubcategory = t196
	end

	typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory)

	do
		local t200 = {}

		t200.__index = t200

		function t200.new(t201: {[any]: any}?) -- line: 12674
			-- upvalues: t200 (copy)
			return (setmetatable({
				subcategory_id = if t201 ~= nil and t201.subcategory_id ~= nil then t201.subcategory_id else nil
			}, t200))
		end
		function t200.encode(p151) -- line: 12682
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n99 = 0

			if p151.subcategory_id ~= nil then
				local v1584 = p151.subcategory_id:encode()
				local v1585, v1586 = proto.writeTag(buf, n99, 1, proto.wireTypes.lengthDelimited)

				buf, n99 = proto.writeBuffer(v1585, v1586, v1584, buffer.len(v1584))
			end

			local buf52 = buffer.create(n99)

			buffer.copy(buf52, 0, buf, 0, n99)

			return buf52
		end
		function t200.decode(p152: buffer) -- line: 12699
			-- upvalues: t200 (copy), proto (copy), prop_types (copy)
			local v1589 = t200.new()
			local n100 = 0

			while n100 < buffer.len(p152) do
				local v1591, v1592

				v1591, v1592, n100 = proto.readTag(p152, n100)

				if v1592 == proto.wireTypes.varint then
					local v1593

					v1593, n100 = proto.readVarInt(p152, n100)
				elseif v1592 == proto.wireTypes.lengthDelimited then
					if v1591 == 1 then
						local v1594

						v1594, n100 = proto.readBuffer(p152, n100)
						v1589.subcategory_id = prop_types.StringProp.decode(v1594)
					else
						local v1595, v1596 = proto.readVarInt(p152, n100)

						n100 = v1596 + v1595
					end
				elseif v1592 == proto.wireTypes.i32 then
					local v1597

					v1597, n100 = proto.readFixed32(p152, n100)
				elseif v1592 == proto.wireTypes.i64 then
					local v1598

					v1598, n100 = proto.readFixed64(p152, n100)
				else
					error("Unsupported wire type: " .. v1592)
				end
			end

			return v1589
		end
		function t200.jsonEncode(p153) -- line: 12744
			local t202 = {}

			if p153.subcategory_id ~= nil then
				t202.subcategoryId = p153.subcategory_id:jsonEncode()
			end

			return t202
		end
		function t200.jsonDecode(t203: {[any]: any}) -- line: 12756
			-- upvalues: t200 (copy), prop_types (copy)
			local v1602 = t200.new()

			if t203.subcategory_id ~= nil then
				v1602.subcategory_id = prop_types.StringProp.jsonDecode(t203.subcategory_id)
			end

			if t203.subcategoryId ~= nil then
				v1602.subcategory_id = prop_types.StringProp.jsonDecode(t203.subcategoryId)
			end

			return v1602
		end

		t200.descriptor = {
			name = "SelectMarketplaceCatalogSubcategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceCatalogSubcategory_Params = t200
		typeRegistry.default:register(t1.SelectMarketplaceCatalogSubcategory_Params)

		local t204 = {}

		t204.__index = t204

		function t204.new(t205: {[any]: any}?) -- line: 12788
			-- upvalues: t1 (copy), t204 (copy)
			return (setmetatable({
				action_type = if t205 ~= nil and t205.action_type ~= nil then t205.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t205 ~= nil and t205.action_params ~= nil then t205.action_params else nil
			}, t204))
		end
		function t204.encode(p154) -- line: 12799
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n101 = 0

			if p154.action_type ~= nil and (p154.action_type ~= nil and p154.action_type ~= 0 or p154.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1607, v1608 = proto.writeTag(buf, n101, 1, proto.wireTypes.varint)

				buf, n101 = proto.writeVarInt(v1607, v1608, t1.ActionType.toNumber(p154.action_type))
			end

			if p154.action_params ~= nil then
				local v1609 = p154.action_params:encode()
				local v1610, v1611 = proto.writeTag(buf, n101, 2, proto.wireTypes.lengthDelimited)

				buf, n101 = proto.writeBuffer(v1610, v1611, v1609, buffer.len(v1609))
			end

			local buf53 = buffer.create(n101)

			buffer.copy(buf53, 0, buf, 0, n101)

			return buf53
		end
		function t204.decode(p155: buffer) -- line: 12825
			-- upvalues: t204 (copy), proto (copy), t1 (copy)
			local v1614 = t204.new()
			local n102 = 0

			while n102 < buffer.len(p155) do
				local v1616, v1617

				v1616, v1617, n102 = proto.readTag(p155, n102)

				if v1617 == proto.wireTypes.varint then
					if v1616 == 1 then
						local v1618

						v1618, n102 = proto.readVarIntI32(p155, n102)
						v1614.action_type = t1.ActionType.fromNumber(v1618) or v1618
					else
						local v1619

						v1619, n102 = proto.readVarInt(p155, n102)
					end
				elseif v1617 == proto.wireTypes.lengthDelimited then
					if v1616 == 2 then
						local v1620

						v1620, n102 = proto.readBuffer(p155, n102)
						v1614.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.decode(v1620)
					else
						local v1621, v1622 = proto.readVarInt(p155, n102)

						n102 = v1622 + v1621
					end
				elseif v1617 == proto.wireTypes.i32 then
					local v1623

					v1623, n102 = proto.readFixed32(p155, n102)
				elseif v1617 == proto.wireTypes.i64 then
					local v1624

					v1624, n102 = proto.readFixed64(p155, n102)
				else
					error("Unsupported wire type: " .. v1617)
				end
			end

			return v1614
		end
		function t204.jsonEncode(p156) -- line: 12873
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
		function t204.jsonDecode(t207: {[any]: any}) -- line: 12895
			-- upvalues: t204 (copy), t1 (copy)
			local v1628 = t204.new()

			if t207.action_type ~= nil then
				v1628.action_type = if typeof(t207.action_type) ~= "number" then t1.ActionType.fromName(t207.action_type) or t207.action_type else t1.ActionType.fromNumber(t207.action_type) or t207.action_type
			end

			if t207.actionType ~= nil then
				v1628.action_type = if typeof(t207.actionType) ~= "number" then t1.ActionType.fromName(t207.actionType) or t207.actionType else t1.ActionType.fromNumber(t207.actionType) or t207.actionType
			end

			if t207.action_params ~= nil then
				v1628.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t207.action_params)
			end

			if t207.actionParams ~= nil then
				v1628.action_params = t1.OpenMarketplaceCatalogSeeAll_Params.jsonDecode(t207.actionParams)
			end

			return v1628
		end

		t204.descriptor = {
			name = "OpenMarketplaceCatalogSeeAll",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogSeeAll"
		}
		t1.OpenMarketplaceCatalogSeeAll = t204
	end

	typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll)

	do
		local t208 = {}

		t208.__index = t208

		function t208.new(t209: {[any]: any}?) -- line: 12935
			-- upvalues: t208 (copy)
			return (setmetatable({
				sort_id = if t209 ~= nil and t209.sort_id ~= nil then t209.sort_id else nil,
				title = if t209 ~= nil and t209.title ~= nil then t209.title else nil,
				description = if t209 ~= nil and t209.description ~= nil then t209.description else nil,
				tooltip_text = if t209 ~= nil and t209.tooltip_text ~= nil then t209.tooltip_text else nil
			}, t208))
		end
		function t208.encode(p157) -- line: 12946
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n103 = 0

			if p157.sort_id ~= nil then
				local v1633 = p157.sort_id:encode()
				local v1634, v1635 = proto.writeTag(buf, n103, 1, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1634, v1635, v1633, buffer.len(v1633))
			end

			if p157.title ~= nil then
				local v1636 = p157.title:encode()
				local v1637, v1638 = proto.writeTag(buf, n103, 2, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1637, v1638, v1636, buffer.len(v1636))
			end

			if p157.description ~= nil then
				local v1639 = p157.description:encode()
				local v1640, v1641 = proto.writeTag(buf, n103, 3, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1640, v1641, v1639, buffer.len(v1639))
			end

			if p157.tooltip_text ~= nil then
				local v1642 = p157.tooltip_text:encode()
				local v1643, v1644 = proto.writeTag(buf, n103, 4, proto.wireTypes.lengthDelimited)

				buf, n103 = proto.writeBuffer(v1643, v1644, v1642, buffer.len(v1642))
			end

			local buf54 = buffer.create(n103)

			buffer.copy(buf54, 0, buf, 0, n103)

			return buf54
		end
		function t208.decode(p158: buffer) -- line: 12979
			-- upvalues: t208 (copy), proto (copy), prop_types (copy)
			local v1647 = t208.new()
			local n104 = 0

			while n104 < buffer.len(p158) do
				local v1649, v1650

				v1649, v1650, n104 = proto.readTag(p158, n104)

				if v1650 == proto.wireTypes.varint then
					local v1651

					v1651, n104 = proto.readVarInt(p158, n104)
				elseif v1650 == proto.wireTypes.lengthDelimited then
					if v1649 == 1 then
						local v1652

						v1652, n104 = proto.readBuffer(p158, n104)
						v1647.sort_id = prop_types.StringProp.decode(v1652)
					elseif v1649 == 2 then
						local v1653

						v1653, n104 = proto.readBuffer(p158, n104)
						v1647.title = prop_types.StringProp.decode(v1653)
					elseif v1649 == 3 then
						local v1654

						v1654, n104 = proto.readBuffer(p158, n104)
						v1647.description = prop_types.StringProp.decode(v1654)
					elseif v1649 == 4 then
						local v1655

						v1655, n104 = proto.readBuffer(p158, n104)
						v1647.tooltip_text = prop_types.StringProp.decode(v1655)
					else
						local v1656, v1657 = proto.readVarInt(p158, n104)

						n104 = v1657 + v1656
					end
				elseif v1650 == proto.wireTypes.i32 then
					local v1658

					v1658, n104 = proto.readFixed32(p158, n104)
				elseif v1650 == proto.wireTypes.i64 then
					local v1659

					v1659, n104 = proto.readFixed64(p158, n104)
				else
					error("Unsupported wire type: " .. v1650)
				end
			end

			return v1647
		end
		function t208.jsonEncode(p159) -- line: 13037
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
		function t208.jsonDecode(t211: {[any]: any}) -- line: 13059
			-- upvalues: t208 (copy), prop_types (copy)
			local v1663 = t208.new()

			if t211.sort_id ~= nil then
				v1663.sort_id = prop_types.StringProp.jsonDecode(t211.sort_id)
			end

			if t211.sortId ~= nil then
				v1663.sort_id = prop_types.StringProp.jsonDecode(t211.sortId)
			end

			if t211.title ~= nil then
				v1663.title = prop_types.StringProp.jsonDecode(t211.title)
			end

			if t211.description ~= nil then
				v1663.description = prop_types.StringProp.jsonDecode(t211.description)
			end

			if t211.tooltip_text ~= nil then
				v1663.tooltip_text = prop_types.StringProp.jsonDecode(t211.tooltip_text)
			end

			if t211.tooltipText ~= nil then
				v1663.tooltip_text = prop_types.StringProp.jsonDecode(t211.tooltipText)
			end

			return v1663
		end

		t208.descriptor = {
			name = "OpenMarketplaceCatalogSeeAll_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenMarketplaceCatalogSeeAll_Params = t208
		typeRegistry.default:register(t1.OpenMarketplaceCatalogSeeAll_Params)

		local t212 = {}

		t212.__index = t212

		function t212.new(t213: {[any]: any}?) -- line: 13108
			-- upvalues: t1 (copy), t212 (copy)
			return (setmetatable({
				action_type = if t213 ~= nil and t213.action_type ~= nil then t213.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t213 ~= nil and t213.action_params ~= nil then t213.action_params else nil
			}, t212))
		end
		function t212.encode(p160) -- line: 13119
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n105 = 0

			if p160.action_type ~= nil and (p160.action_type ~= nil and p160.action_type ~= 0 or p160.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1668, v1669 = proto.writeTag(buf, n105, 1, proto.wireTypes.varint)

				buf, n105 = proto.writeVarInt(v1668, v1669, t1.ActionType.toNumber(p160.action_type))
			end

			if p160.action_params ~= nil then
				local v1670 = p160.action_params:encode()
				local v1671, v1672 = proto.writeTag(buf, n105, 2, proto.wireTypes.lengthDelimited)

				buf, n105 = proto.writeBuffer(v1671, v1672, v1670, buffer.len(v1670))
			end

			local buf55 = buffer.create(n105)

			buffer.copy(buf55, 0, buf, 0, n105)

			return buf55
		end
		function t212.decode(p161: buffer) -- line: 13145
			-- upvalues: t212 (copy), proto (copy), t1 (copy)
			local v1675 = t212.new()
			local n106 = 0

			while n106 < buffer.len(p161) do
				local v1677, v1678

				v1677, v1678, n106 = proto.readTag(p161, n106)

				if v1678 == proto.wireTypes.varint then
					if v1677 == 1 then
						local v1679

						v1679, n106 = proto.readVarIntI32(p161, n106)
						v1675.action_type = t1.ActionType.fromNumber(v1679) or v1679
					else
						local v1680

						v1680, n106 = proto.readVarInt(p161, n106)
					end
				elseif v1678 == proto.wireTypes.lengthDelimited then
					if v1677 == 2 then
						local v1681

						v1681, n106 = proto.readBuffer(p161, n106)
						v1675.action_params = t1.CloseMarketplaceCategoryTooltip_Params.decode(v1681)
					else
						local v1682, v1683 = proto.readVarInt(p161, n106)

						n106 = v1683 + v1682
					end
				elseif v1678 == proto.wireTypes.i32 then
					local v1684

					v1684, n106 = proto.readFixed32(p161, n106)
				elseif v1678 == proto.wireTypes.i64 then
					local v1685

					v1685, n106 = proto.readFixed64(p161, n106)
				else
					error("Unsupported wire type: " .. v1678)
				end
			end

			return v1675
		end
		function t212.jsonEncode(p162) -- line: 13193
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
		function t212.jsonDecode(t215: {[any]: any}) -- line: 13215
			-- upvalues: t212 (copy), t1 (copy)
			local v1689 = t212.new()

			if t215.action_type ~= nil then
				v1689.action_type = if typeof(t215.action_type) ~= "number" then t1.ActionType.fromName(t215.action_type) or t215.action_type else t1.ActionType.fromNumber(t215.action_type) or t215.action_type
			end

			if t215.actionType ~= nil then
				v1689.action_type = if typeof(t215.actionType) ~= "number" then t1.ActionType.fromName(t215.actionType) or t215.actionType else t1.ActionType.fromNumber(t215.actionType) or t215.actionType
			end

			if t215.action_params ~= nil then
				v1689.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t215.action_params)
			end

			if t215.actionParams ~= nil then
				v1689.action_params = t1.CloseMarketplaceCategoryTooltip_Params.jsonDecode(t215.actionParams)
			end

			return v1689
		end

		t212.descriptor = {
			name = "CloseMarketplaceCategoryTooltip",
			fullName = "roblox.apppageplatform.shared.v1beta1.CloseMarketplaceCategoryTooltip"
		}
		t1.CloseMarketplaceCategoryTooltip = t212
	end

	typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip)

	do
		local t216 = {}

		t216.__index = t216

		function t216.new(t217: {[any]: any}?) -- line: 13255
			-- upvalues: t216 (copy)
			return (setmetatable({
				tooltip_id = if t217 ~= nil and t217.tooltip_id ~= nil then t217.tooltip_id else nil
			}, t216))
		end
		function t216.encode(p163) -- line: 13263
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n107 = 0

			if p163.tooltip_id ~= nil then
				local v1694 = p163.tooltip_id:encode()
				local v1695, v1696 = proto.writeTag(buf, n107, 1, proto.wireTypes.lengthDelimited)

				buf, n107 = proto.writeBuffer(v1695, v1696, v1694, buffer.len(v1694))
			end

			local buf56 = buffer.create(n107)

			buffer.copy(buf56, 0, buf, 0, n107)

			return buf56
		end
		function t216.decode(p164: buffer) -- line: 13278
			-- upvalues: t216 (copy), proto (copy), prop_types (copy)
			local v1699 = t216.new()
			local n108 = 0

			while n108 < buffer.len(p164) do
				local v1701, v1702

				v1701, v1702, n108 = proto.readTag(p164, n108)

				if v1702 == proto.wireTypes.varint then
					local v1703

					v1703, n108 = proto.readVarInt(p164, n108)
				elseif v1702 == proto.wireTypes.lengthDelimited then
					if v1701 == 1 then
						local v1704

						v1704, n108 = proto.readBuffer(p164, n108)
						v1699.tooltip_id = prop_types.StringProp.decode(v1704)
					else
						local v1705, v1706 = proto.readVarInt(p164, n108)

						n108 = v1706 + v1705
					end
				elseif v1702 == proto.wireTypes.i32 then
					local v1707

					v1707, n108 = proto.readFixed32(p164, n108)
				elseif v1702 == proto.wireTypes.i64 then
					local v1708

					v1708, n108 = proto.readFixed64(p164, n108)
				else
					error("Unsupported wire type: " .. v1702)
				end
			end

			return v1699
		end
		function t216.jsonEncode(p165) -- line: 13321
			local t218 = {}

			if p165.tooltip_id ~= nil then
				t218.tooltipId = p165.tooltip_id:jsonEncode()
			end

			return t218
		end
		function t216.jsonDecode(t219: {[any]: any}) -- line: 13331
			-- upvalues: t216 (copy), prop_types (copy)
			local v1712 = t216.new()

			if t219.tooltip_id ~= nil then
				v1712.tooltip_id = prop_types.StringProp.jsonDecode(t219.tooltip_id)
			end

			if t219.tooltipId ~= nil then
				v1712.tooltip_id = prop_types.StringProp.jsonDecode(t219.tooltipId)
			end

			return v1712
		end

		t216.descriptor = {
			name = "CloseMarketplaceCategoryTooltip_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CloseMarketplaceCategoryTooltip_Params = t216
		typeRegistry.default:register(t1.CloseMarketplaceCategoryTooltip_Params)

		local t220 = {}

		t220.__index = t220

		function t220.new(t221: {[any]: any}?) -- line: 13361
			-- upvalues: t1 (copy), t220 (copy)
			return (setmetatable({
				action_type = if t221 ~= nil and t221.action_type ~= nil then t221.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t221 ~= nil and t221.action_params ~= nil then t221.action_params else nil
			}, t220))
		end
		function t220.encode(p166) -- line: 13370
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n109 = 0

			if p166.action_type ~= nil and (p166.action_type ~= nil and p166.action_type ~= 0 or p166.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1717, v1718 = proto.writeTag(buf, n109, 1, proto.wireTypes.varint)

				buf, n109 = proto.writeVarInt(v1717, v1718, t1.ActionType.toNumber(p166.action_type))
			end

			if p166.action_params ~= nil then
				local v1719 = p166.action_params:encode()
				local v1720, v1721 = proto.writeTag(buf, n109, 2, proto.wireTypes.lengthDelimited)

				buf, n109 = proto.writeBuffer(v1720, v1721, v1719, buffer.len(v1719))
			end

			local buf57 = buffer.create(n109)

			buffer.copy(buf57, 0, buf, 0, n109)

			return buf57
		end
		function t220.decode(p167: buffer) -- line: 13396
			-- upvalues: t220 (copy), proto (copy), t1 (copy)
			local v1724 = t220.new()
			local n110 = 0

			while n110 < buffer.len(p167) do
				local v1726, v1727

				v1726, v1727, n110 = proto.readTag(p167, n110)

				if v1727 == proto.wireTypes.varint then
					if v1726 == 1 then
						local v1728

						v1728, n110 = proto.readVarIntI32(p167, n110)
						v1724.action_type = t1.ActionType.fromNumber(v1728) or v1728
					else
						local v1729

						v1729, n110 = proto.readVarInt(p167, n110)
					end
				elseif v1727 == proto.wireTypes.lengthDelimited then
					if v1726 == 2 then
						local v1730

						v1730, n110 = proto.readBuffer(p167, n110)
						v1724.action_params = t1.ResizeMarketplaceCatalog_Params.decode(v1730)
					else
						local v1731, v1732 = proto.readVarInt(p167, n110)

						n110 = v1732 + v1731
					end
				elseif v1727 == proto.wireTypes.i32 then
					local v1733

					v1733, n110 = proto.readFixed32(p167, n110)
				elseif v1727 == proto.wireTypes.i64 then
					local v1734

					v1734, n110 = proto.readFixed64(p167, n110)
				else
					error("Unsupported wire type: " .. v1727)
				end
			end

			return v1724
		end
		function t220.jsonEncode(p168) -- line: 13444
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
		function t220.jsonDecode(t223: {[any]: any}) -- line: 13466
			-- upvalues: t220 (copy), t1 (copy)
			local v1738 = t220.new()

			if t223.action_type ~= nil then
				v1738.action_type = if typeof(t223.action_type) ~= "number" then t1.ActionType.fromName(t223.action_type) or t223.action_type else t1.ActionType.fromNumber(t223.action_type) or t223.action_type
			end

			if t223.actionType ~= nil then
				v1738.action_type = if typeof(t223.actionType) ~= "number" then t1.ActionType.fromName(t223.actionType) or t223.actionType else t1.ActionType.fromNumber(t223.actionType) or t223.actionType
			end

			if t223.action_params ~= nil then
				v1738.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t223.action_params)
			end

			if t223.actionParams ~= nil then
				v1738.action_params = t1.ResizeMarketplaceCatalog_Params.jsonDecode(t223.actionParams)
			end

			return v1738
		end

		t220.descriptor = {
			name = "ResizeMarketplaceCatalog",
			fullName = "roblox.apppageplatform.shared.v1beta1.ResizeMarketplaceCatalog"
		}
		t1.ResizeMarketplaceCatalog = t220
	end

	typeRegistry.default:register(t1.ResizeMarketplaceCatalog)

	do
		local t224 = {}

		t224.__index = t224

		function t224.new(t225: {[any]: any}?) -- line: 13506
			-- upvalues: t224 (copy)
			return (setmetatable({
				category_id = if t225 ~= nil and t225.category_id ~= nil then t225.category_id else nil,
				subcategory_id = if t225 ~= nil and t225.subcategory_id ~= nil then t225.subcategory_id else nil,
				screen_size = if t225 ~= nil and t225.screen_size ~= nil then t225.screen_size else nil
			}, t224))
		end
		function t224.encode(p169) -- line: 13516
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n111 = 0

			if p169.category_id ~= nil then
				local v1743 = p169.category_id:encode()
				local v1744, v1745 = proto.writeTag(buf, n111, 1, proto.wireTypes.lengthDelimited)

				buf, n111 = proto.writeBuffer(v1744, v1745, v1743, buffer.len(v1743))
			end

			if p169.subcategory_id ~= nil then
				local v1746 = p169.subcategory_id:encode()
				local v1747, v1748 = proto.writeTag(buf, n111, 2, proto.wireTypes.lengthDelimited)

				buf, n111 = proto.writeBuffer(v1747, v1748, v1746, buffer.len(v1746))
			end

			if p169.screen_size ~= nil then
				local v1749 = p169.screen_size:encode()
				local v1750, v1751 = proto.writeTag(buf, n111, 3, proto.wireTypes.lengthDelimited)

				buf, n111 = proto.writeBuffer(v1750, v1751, v1749, buffer.len(v1749))
			end

			local buf58 = buffer.create(n111)

			buffer.copy(buf58, 0, buf, 0, n111)

			return buf58
		end
		function t224.decode(p170: buffer) -- line: 13543
			-- upvalues: t224 (copy), proto (copy), prop_types (copy)
			local v1754 = t224.new()
			local n112 = 0

			while n112 < buffer.len(p170) do
				local v1756, v1757

				v1756, v1757, n112 = proto.readTag(p170, n112)

				if v1757 == proto.wireTypes.varint then
					local v1758

					v1758, n112 = proto.readVarInt(p170, n112)
				elseif v1757 == proto.wireTypes.lengthDelimited then
					if v1756 == 1 then
						local v1759

						v1759, n112 = proto.readBuffer(p170, n112)
						v1754.category_id = prop_types.StringProp.decode(v1759)
					elseif v1756 == 2 then
						local v1760

						v1760, n112 = proto.readBuffer(p170, n112)
						v1754.subcategory_id = prop_types.StringProp.decode(v1760)
					elseif v1756 == 3 then
						local v1761

						v1761, n112 = proto.readBuffer(p170, n112)
						v1754.screen_size = prop_types.StringProp.decode(v1761)
					else
						local v1762, v1763 = proto.readVarInt(p170, n112)

						n112 = v1763 + v1762
					end
				elseif v1757 == proto.wireTypes.i32 then
					local v1764

					v1764, n112 = proto.readFixed32(p170, n112)
				elseif v1757 == proto.wireTypes.i64 then
					local v1765

					v1765, n112 = proto.readFixed64(p170, n112)
				else
					error("Unsupported wire type: " .. v1757)
				end
			end

			return v1754
		end
		function t224.jsonEncode(p171) -- line: 13596
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
		function t224.jsonDecode(t227: {[any]: any}) -- line: 13614
			-- upvalues: t224 (copy), prop_types (copy)
			local v1769 = t224.new()

			if t227.category_id ~= nil then
				v1769.category_id = prop_types.StringProp.jsonDecode(t227.category_id)
			end

			if t227.categoryId ~= nil then
				v1769.category_id = prop_types.StringProp.jsonDecode(t227.categoryId)
			end

			if t227.subcategory_id ~= nil then
				v1769.subcategory_id = prop_types.StringProp.jsonDecode(t227.subcategory_id)
			end

			if t227.subcategoryId ~= nil then
				v1769.subcategory_id = prop_types.StringProp.jsonDecode(t227.subcategoryId)
			end

			if t227.screen_size ~= nil then
				v1769.screen_size = prop_types.StringProp.jsonDecode(t227.screen_size)
			end

			if t227.screenSize ~= nil then
				v1769.screen_size = prop_types.StringProp.jsonDecode(t227.screenSize)
			end

			return v1769
		end

		t224.descriptor = {
			name = "ResizeMarketplaceCatalog_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ResizeMarketplaceCatalog_Params = t224
		typeRegistry.default:register(t1.ResizeMarketplaceCatalog_Params)

		local t228 = {}

		t228.__index = t228

		function t228.new(t229: {[any]: any}?) -- line: 13662
			-- upvalues: t1 (copy), t228 (copy)
			return (setmetatable({
				action_type = if t229 ~= nil and t229.action_type ~= nil then t229.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t229 ~= nil and t229.action_params ~= nil then t229.action_params else nil
			}, t228))
		end
		function t228.encode(p172) -- line: 13673
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n113 = 0

			if p172.action_type ~= nil and (p172.action_type ~= nil and p172.action_type ~= 0 or p172.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1774, v1775 = proto.writeTag(buf, n113, 1, proto.wireTypes.varint)

				buf, n113 = proto.writeVarInt(v1774, v1775, t1.ActionType.toNumber(p172.action_type))
			end

			if p172.action_params ~= nil then
				local v1776 = p172.action_params:encode()
				local v1777, v1778 = proto.writeTag(buf, n113, 2, proto.wireTypes.lengthDelimited)

				buf, n113 = proto.writeBuffer(v1777, v1778, v1776, buffer.len(v1776))
			end

			local buf59 = buffer.create(n113)

			buffer.copy(buf59, 0, buf, 0, n113)

			return buf59
		end
		function t228.decode(p173: buffer) -- line: 13699
			-- upvalues: t228 (copy), proto (copy), t1 (copy)
			local v1781 = t228.new()
			local n114 = 0

			while n114 < buffer.len(p173) do
				local v1783, v1784

				v1783, v1784, n114 = proto.readTag(p173, n114)

				if v1784 == proto.wireTypes.varint then
					if v1783 == 1 then
						local v1785

						v1785, n114 = proto.readVarIntI32(p173, n114)
						v1781.action_type = t1.ActionType.fromNumber(v1785) or v1785
					else
						local v1786

						v1786, n114 = proto.readVarInt(p173, n114)
					end
				elseif v1784 == proto.wireTypes.lengthDelimited then
					if v1783 == 2 then
						local v1787

						v1787, n114 = proto.readBuffer(p173, n114)
						v1781.action_params = t1.OpenChartsSortDetailAction_Params.decode(v1787)
					else
						local v1788, v1789 = proto.readVarInt(p173, n114)

						n114 = v1789 + v1788
					end
				elseif v1784 == proto.wireTypes.i32 then
					local v1790

					v1790, n114 = proto.readFixed32(p173, n114)
				elseif v1784 == proto.wireTypes.i64 then
					local v1791

					v1791, n114 = proto.readFixed64(p173, n114)
				else
					error("Unsupported wire type: " .. v1784)
				end
			end

			return v1781
		end
		function t228.jsonEncode(p174) -- line: 13747
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
		function t228.jsonDecode(t231: {[any]: any}) -- line: 13769
			-- upvalues: t228 (copy), t1 (copy)
			local v1795 = t228.new()

			if t231.action_type ~= nil then
				v1795.action_type = if typeof(t231.action_type) ~= "number" then t1.ActionType.fromName(t231.action_type) or t231.action_type else t1.ActionType.fromNumber(t231.action_type) or t231.action_type
			end

			if t231.actionType ~= nil then
				v1795.action_type = if typeof(t231.actionType) ~= "number" then t1.ActionType.fromName(t231.actionType) or t231.actionType else t1.ActionType.fromNumber(t231.actionType) or t231.actionType
			end

			if t231.action_params ~= nil then
				v1795.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t231.action_params)
			end

			if t231.actionParams ~= nil then
				v1795.action_params = t1.OpenChartsSortDetailAction_Params.jsonDecode(t231.actionParams)
			end

			return v1795
		end

		t228.descriptor = {
			name = "OpenChartsSortDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenChartsSortDetailAction"
		}
		t1.OpenChartsSortDetailAction = t228
	end

	typeRegistry.default:register(t1.OpenChartsSortDetailAction)

	do
		local t232 = {}

		t232.__index = t232

		function t232.new(t233: {[any]: any}?) -- line: 13809
			-- upvalues: t232 (copy)
			return (setmetatable({
				sort_id = if t233 ~= nil and t233.sort_id ~= nil then t233.sort_id else nil,
				secondary_sort_id = if t233 ~= nil and t233.secondary_sort_id ~= nil then t233.secondary_sort_id else nil
			}, t232))
		end
		function t232.encode(p175) -- line: 13818
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n115 = 0

			if p175.sort_id ~= nil then
				local v1800 = p175.sort_id:encode()
				local v1801, v1802 = proto.writeTag(buf, n115, 1, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1801, v1802, v1800, buffer.len(v1800))
			end

			if p175.secondary_sort_id ~= nil then
				local v1803 = p175.secondary_sort_id:encode()
				local v1804, v1805 = proto.writeTag(buf, n115, 2, proto.wireTypes.lengthDelimited)

				buf, n115 = proto.writeBuffer(v1804, v1805, v1803, buffer.len(v1803))
			end

			local buf60 = buffer.create(n115)

			buffer.copy(buf60, 0, buf, 0, n115)

			return buf60
		end
		function t232.decode(p176: buffer) -- line: 13839
			-- upvalues: t232 (copy), proto (copy), prop_types (copy)
			local v1808 = t232.new()
			local n116 = 0

			while n116 < buffer.len(p176) do
				local v1810, v1811

				v1810, v1811, n116 = proto.readTag(p176, n116)

				if v1811 == proto.wireTypes.varint then
					local v1812

					v1812, n116 = proto.readVarInt(p176, n116)
				elseif v1811 == proto.wireTypes.lengthDelimited then
					if v1810 == 1 then
						local v1813

						v1813, n116 = proto.readBuffer(p176, n116)
						v1808.sort_id = prop_types.StringProp.decode(v1813)
					elseif v1810 == 2 then
						local v1814

						v1814, n116 = proto.readBuffer(p176, n116)
						v1808.secondary_sort_id = prop_types.Int32Prop.decode(v1814)
					else
						local v1815, v1816 = proto.readVarInt(p176, n116)

						n116 = v1816 + v1815
					end
				elseif v1811 == proto.wireTypes.i32 then
					local v1817

					v1817, n116 = proto.readFixed32(p176, n116)
				elseif v1811 == proto.wireTypes.i64 then
					local v1818

					v1818, n116 = proto.readFixed64(p176, n116)
				else
					error("Unsupported wire type: " .. v1811)
				end
			end

			return v1808
		end
		function t232.jsonEncode(p177) -- line: 13887
			local t234 = {}

			if p177.sort_id ~= nil then
				t234.sortId = p177.sort_id:jsonEncode()
			end

			if p177.secondary_sort_id ~= nil then
				t234.secondarySortId = p177.secondary_sort_id:jsonEncode()
			end

			return t234
		end
		function t232.jsonDecode(t235: {[any]: any}) -- line: 13901
			-- upvalues: t232 (copy), prop_types (copy)
			local v1822 = t232.new()

			if t235.sort_id ~= nil then
				v1822.sort_id = prop_types.StringProp.jsonDecode(t235.sort_id)
			end

			if t235.sortId ~= nil then
				v1822.sort_id = prop_types.StringProp.jsonDecode(t235.sortId)
			end

			if t235.secondary_sort_id ~= nil then
				v1822.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t235.secondary_sort_id)
			end

			if t235.secondarySortId ~= nil then
				v1822.secondary_sort_id = prop_types.Int32Prop.jsonDecode(t235.secondarySortId)
			end

			return v1822
		end

		t232.descriptor = {
			name = "OpenChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenChartsSortDetailAction_Params = t232
		typeRegistry.default:register(t1.OpenChartsSortDetailAction_Params)

		local t236 = {}

		t236.__index = t236

		function t236.new(t237: {[any]: any}?) -- line: 13941
			-- upvalues: t1 (copy), t236 (copy)
			return (setmetatable({
				action_type = if t237 ~= nil and t237.action_type ~= nil then t237.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t237 ~= nil and t237.action_params ~= nil then t237.action_params else nil
			}, t236))
		end
		function t236.encode(p178) -- line: 13950
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n117 = 0

			if p178.action_type ~= nil and (p178.action_type ~= nil and p178.action_type ~= 0 or p178.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1827, v1828 = proto.writeTag(buf, n117, 1, proto.wireTypes.varint)

				buf, n117 = proto.writeVarInt(v1827, v1828, t1.ActionType.toNumber(p178.action_type))
			end

			if p178.action_params ~= nil then
				local v1829 = p178.action_params:encode()
				local v1830, v1831 = proto.writeTag(buf, n117, 2, proto.wireTypes.lengthDelimited)

				buf, n117 = proto.writeBuffer(v1830, v1831, v1829, buffer.len(v1829))
			end

			local buf61 = buffer.create(n117)

			buffer.copy(buf61, 0, buf, 0, n117)

			return buf61
		end
		function t236.decode(p179: buffer) -- line: 13976
			-- upvalues: t236 (copy), proto (copy), t1 (copy)
			local v1834 = t236.new()
			local n118 = 0

			while n118 < buffer.len(p179) do
				local v1836, v1837

				v1836, v1837, n118 = proto.readTag(p179, n118)

				if v1837 == proto.wireTypes.varint then
					if v1836 == 1 then
						local v1838

						v1838, n118 = proto.readVarIntI32(p179, n118)
						v1834.action_type = t1.ActionType.fromNumber(v1838) or v1838
					else
						local v1839

						v1839, n118 = proto.readVarInt(p179, n118)
					end
				elseif v1837 == proto.wireTypes.lengthDelimited then
					if v1836 == 2 then
						local v1840

						v1840, n118 = proto.readBuffer(p179, n118)
						v1834.action_params = t1.OpenSongDetailAction_Params.decode(v1840)
					else
						local v1841, v1842 = proto.readVarInt(p179, n118)

						n118 = v1842 + v1841
					end
				elseif v1837 == proto.wireTypes.i32 then
					local v1843

					v1843, n118 = proto.readFixed32(p179, n118)
				elseif v1837 == proto.wireTypes.i64 then
					local v1844

					v1844, n118 = proto.readFixed64(p179, n118)
				else
					error("Unsupported wire type: " .. v1837)
				end
			end

			return v1834
		end
		function t236.jsonEncode(p180) -- line: 14024
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
		function t236.jsonDecode(t239: {[any]: any}) -- line: 14046
			-- upvalues: t236 (copy), t1 (copy)
			local v1848 = t236.new()

			if t239.action_type ~= nil then
				v1848.action_type = if typeof(t239.action_type) ~= "number" then t1.ActionType.fromName(t239.action_type) or t239.action_type else t1.ActionType.fromNumber(t239.action_type) or t239.action_type
			end

			if t239.actionType ~= nil then
				v1848.action_type = if typeof(t239.actionType) ~= "number" then t1.ActionType.fromName(t239.actionType) or t239.actionType else t1.ActionType.fromNumber(t239.actionType) or t239.actionType
			end

			if t239.action_params ~= nil then
				v1848.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t239.action_params)
			end

			if t239.actionParams ~= nil then
				v1848.action_params = t1.OpenSongDetailAction_Params.jsonDecode(t239.actionParams)
			end

			return v1848
		end

		t236.descriptor = {
			name = "OpenSongDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSongDetailAction"
		}
		t1.OpenSongDetailAction = t236
	end

	typeRegistry.default:register(t1.OpenSongDetailAction)

	do
		local t240 = {}

		t240.__index = t240

		function t240.new(t241: {[any]: any}?) -- line: 14086
			-- upvalues: t240 (copy)
			return (setmetatable({
				song_id = if t241 ~= nil and t241.song_id ~= nil then t241.song_id else nil
			}, t240))
		end
		function t240.encode(p181) -- line: 14094
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n119 = 0

			if p181.song_id ~= nil then
				local v1853 = p181.song_id:encode()
				local v1854, v1855 = proto.writeTag(buf, n119, 1, proto.wireTypes.lengthDelimited)

				buf, n119 = proto.writeBuffer(v1854, v1855, v1853, buffer.len(v1853))
			end

			local buf62 = buffer.create(n119)

			buffer.copy(buf62, 0, buf, 0, n119)

			return buf62
		end
		function t240.decode(p182: buffer) -- line: 14109
			-- upvalues: t240 (copy), proto (copy), prop_types (copy)
			local v1858 = t240.new()
			local n120 = 0

			while n120 < buffer.len(p182) do
				local v1860, v1861

				v1860, v1861, n120 = proto.readTag(p182, n120)

				if v1861 == proto.wireTypes.varint then
					local v1862

					v1862, n120 = proto.readVarInt(p182, n120)
				elseif v1861 == proto.wireTypes.lengthDelimited then
					if v1860 == 1 then
						local v1863

						v1863, n120 = proto.readBuffer(p182, n120)
						v1858.song_id = prop_types.StringProp.decode(v1863)
					else
						local v1864, v1865 = proto.readVarInt(p182, n120)

						n120 = v1865 + v1864
					end
				elseif v1861 == proto.wireTypes.i32 then
					local v1866

					v1866, n120 = proto.readFixed32(p182, n120)
				elseif v1861 == proto.wireTypes.i64 then
					local v1867

					v1867, n120 = proto.readFixed64(p182, n120)
				else
					error("Unsupported wire type: " .. v1861)
				end
			end

			return v1858
		end
		function t240.jsonEncode(p183) -- line: 14152
			local t242 = {}

			if p183.song_id ~= nil then
				t242.songId = p183.song_id:jsonEncode()
			end

			return t242
		end
		function t240.jsonDecode(t243: {[any]: any}) -- line: 14162
			-- upvalues: t240 (copy), prop_types (copy)
			local v1871 = t240.new()

			if t243.song_id ~= nil then
				v1871.song_id = prop_types.StringProp.jsonDecode(t243.song_id)
			end

			if t243.songId ~= nil then
				v1871.song_id = prop_types.StringProp.jsonDecode(t243.songId)
			end

			return v1871
		end

		t240.descriptor = {
			name = "OpenSongDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSongDetailAction_Params = t240
		typeRegistry.default:register(t1.OpenSongDetailAction_Params)

		local t244 = {}

		t244.__index = t244

		function t244.new(t245: {[any]: any}?) -- line: 14190
			-- upvalues: t1 (copy), t244 (copy)
			return (setmetatable({
				action_type = if t245 ~= nil and t245.action_type ~= nil then t245.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t245 ~= nil and t245.action_params ~= nil then t245.action_params else nil
			}, t244))
		end
		function t244.encode(p184) -- line: 14201
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n121 = 0

			if p184.action_type ~= nil and (p184.action_type ~= nil and p184.action_type ~= 0 or p184.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1876, v1877 = proto.writeTag(buf, n121, 1, proto.wireTypes.varint)

				buf, n121 = proto.writeVarInt(v1876, v1877, t1.ActionType.toNumber(p184.action_type))
			end

			if p184.action_params ~= nil then
				local v1878 = p184.action_params:encode()
				local v1879, v1880 = proto.writeTag(buf, n121, 2, proto.wireTypes.lengthDelimited)

				buf, n121 = proto.writeBuffer(v1879, v1880, v1878, buffer.len(v1878))
			end

			local buf63 = buffer.create(n121)

			buffer.copy(buf63, 0, buf, 0, n121)

			return buf63
		end
		function t244.decode(p185: buffer) -- line: 14227
			-- upvalues: t244 (copy), proto (copy), t1 (copy)
			local v1883 = t244.new()
			local n122 = 0

			while n122 < buffer.len(p185) do
				local v1885, v1886

				v1885, v1886, n122 = proto.readTag(p185, n122)

				if v1886 == proto.wireTypes.varint then
					if v1885 == 1 then
						local v1887

						v1887, n122 = proto.readVarIntI32(p185, n122)
						v1883.action_type = t1.ActionType.fromNumber(v1887) or v1887
					else
						local v1888

						v1888, n122 = proto.readVarInt(p185, n122)
					end
				elseif v1886 == proto.wireTypes.lengthDelimited then
					if v1885 == 2 then
						local v1889

						v1889, n122 = proto.readBuffer(p185, n122)
						v1883.action_params = t1.OpenMarketplaceCatalogFilters_Params.decode(v1889)
					else
						local v1890, v1891 = proto.readVarInt(p185, n122)

						n122 = v1891 + v1890
					end
				elseif v1886 == proto.wireTypes.i32 then
					local v1892

					v1892, n122 = proto.readFixed32(p185, n122)
				elseif v1886 == proto.wireTypes.i64 then
					local v1893

					v1893, n122 = proto.readFixed64(p185, n122)
				else
					error("Unsupported wire type: " .. v1886)
				end
			end

			return v1883
		end
		function t244.jsonEncode(p186) -- line: 14275
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
		function t244.jsonDecode(t247: {[any]: any}) -- line: 14297
			-- upvalues: t244 (copy), t1 (copy)
			local v1897 = t244.new()

			if t247.action_type ~= nil then
				v1897.action_type = if typeof(t247.action_type) ~= "number" then t1.ActionType.fromName(t247.action_type) or t247.action_type else t1.ActionType.fromNumber(t247.action_type) or t247.action_type
			end

			if t247.actionType ~= nil then
				v1897.action_type = if typeof(t247.actionType) ~= "number" then t1.ActionType.fromName(t247.actionType) or t247.actionType else t1.ActionType.fromNumber(t247.actionType) or t247.actionType
			end

			if t247.action_params ~= nil then
				v1897.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t247.action_params)
			end

			if t247.actionParams ~= nil then
				v1897.action_params = t1.OpenMarketplaceCatalogFilters_Params.jsonDecode(t247.actionParams)
			end

			return v1897
		end

		t244.descriptor = {
			name = "OpenMarketplaceCatalogFilters",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenMarketplaceCatalogFilters"
		}
		t1.OpenMarketplaceCatalogFilters = t244
	end

	typeRegistry.default:register(t1.OpenMarketplaceCatalogFilters)

	do
		local t248 = {}

		t248.__index = t248

		function t248.new(_: {[any]: any}?) -- line: 14337
			-- upvalues: t248 (copy)
			return (setmetatable({}, t248))
		end
		function t248.encode(_) -- line: 14343
			local buf = buffer.create(0)
			local buf64 = buffer.create(0)

			buffer.copy(buf64, 0, buf, 0, 0)

			return buf64
		end
		function t248.decode(p188: buffer) -- line: 14352
			-- upvalues: t248 (copy), proto (copy)
			local v1903 = t248.new()
			local n123 = 0

			while n123 < buffer.len(p188) do
				local v1905, v1906

				v1905, v1906, n123 = proto.readTag(p188, n123)

				if v1906 == proto.wireTypes.varint then
					local v1907

					v1907, n123 = proto.readVarInt(p188, n123)
				elseif v1906 == proto.wireTypes.lengthDelimited then
					local v1908, v1909 = proto.readVarInt(p188, n123)

					n123 = v1909 + v1908
				elseif v1906 == proto.wireTypes.i32 then
					local v1910

					v1910, n123 = proto.readFixed32(p188, n123)
				elseif v1906 == proto.wireTypes.i64 then
					local v1911

					v1911, n123 = proto.readFixed64(p188, n123)
				else
					error("Unsupported wire type: " .. v1906)
				end
			end

			return v1903
		end
		function t248.jsonEncode(_) -- line: 14390
			return {}
		end
		function t248.jsonDecode(_: {[any]: any}) -- line: 14396
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

		function t251.new(t252: {[any]: any}?) -- line: 14418
			-- upvalues: t1 (copy), t251 (copy)
			return (setmetatable({
				action_type = if t252 ~= nil and t252.action_type ~= nil then t252.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t252 ~= nil and t252.action_params ~= nil then t252.action_params else nil
			}, t251))
		end
		function t251.encode(p190) -- line: 14427
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n124 = 0

			if p190.action_type ~= nil and (p190.action_type ~= nil and p190.action_type ~= 0 or p190.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1918, v1919 = proto.writeTag(buf, n124, 1, proto.wireTypes.varint)

				buf, n124 = proto.writeVarInt(v1918, v1919, t1.ActionType.toNumber(p190.action_type))
			end

			if p190.action_params ~= nil then
				local v1920 = p190.action_params:encode()
				local v1921, v1922 = proto.writeTag(buf, n124, 2, proto.wireTypes.lengthDelimited)

				buf, n124 = proto.writeBuffer(v1921, v1922, v1920, buffer.len(v1920))
			end

			local buf65 = buffer.create(n124)

			buffer.copy(buf65, 0, buf, 0, n124)

			return buf65
		end
		function t251.decode(p191: buffer) -- line: 14453
			-- upvalues: t251 (copy), proto (copy), t1 (copy)
			local v1925 = t251.new()
			local n125 = 0

			while n125 < buffer.len(p191) do
				local v1927, v1928

				v1927, v1928, n125 = proto.readTag(p191, n125)

				if v1928 == proto.wireTypes.varint then
					if v1927 == 1 then
						local v1929

						v1929, n125 = proto.readVarIntI32(p191, n125)
						v1925.action_type = t1.ActionType.fromNumber(v1929) or v1929
					else
						local v1930

						v1930, n125 = proto.readVarInt(p191, n125)
					end
				elseif v1928 == proto.wireTypes.lengthDelimited then
					if v1927 == 2 then
						local v1931

						v1931, n125 = proto.readBuffer(p191, n125)
						v1925.action_params = t1.RefreshFromApiAction_Params.decode(v1931)
					else
						local v1932, v1933 = proto.readVarInt(p191, n125)

						n125 = v1933 + v1932
					end
				elseif v1928 == proto.wireTypes.i32 then
					local v1934

					v1934, n125 = proto.readFixed32(p191, n125)
				elseif v1928 == proto.wireTypes.i64 then
					local v1935

					v1935, n125 = proto.readFixed64(p191, n125)
				else
					error("Unsupported wire type: " .. v1928)
				end
			end

			return v1925
		end
		function t251.jsonEncode(p192) -- line: 14501
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
		function t251.jsonDecode(t254: {[any]: any}) -- line: 14523
			-- upvalues: t251 (copy), t1 (copy)
			local v1939 = t251.new()

			if t254.action_type ~= nil then
				v1939.action_type = if typeof(t254.action_type) ~= "number" then t1.ActionType.fromName(t254.action_type) or t254.action_type else t1.ActionType.fromNumber(t254.action_type) or t254.action_type
			end

			if t254.actionType ~= nil then
				v1939.action_type = if typeof(t254.actionType) ~= "number" then t1.ActionType.fromName(t254.actionType) or t254.actionType else t1.ActionType.fromNumber(t254.actionType) or t254.actionType
			end

			if t254.action_params ~= nil then
				v1939.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t254.action_params)
			end

			if t254.actionParams ~= nil then
				v1939.action_params = t1.RefreshFromApiAction_Params.jsonDecode(t254.actionParams)
			end

			return v1939
		end

		t251.descriptor = {
			name = "RefreshFromApiAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshFromApiAction"
		}
		t1.RefreshFromApiAction = t251
	end

	typeRegistry.default:register(t1.RefreshFromApiAction)

	do
		local t255 = {}

		t255.__index = t255

		function t255.new(t256: {[any]: any}?) -- line: 14563
			-- upvalues: t255 (copy)
			return (setmetatable({
				surface_key = if t256 ~= nil and t256.surface_key ~= nil then t256.surface_key else nil,
				config_key = if t256 ~= nil and t256.config_key ~= nil then t256.config_key else nil
			}, t255))
		end
		function t255.encode(p193) -- line: 14572
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n126 = 0

			if p193.surface_key ~= nil then
				local v1944 = p193.surface_key:encode()
				local v1945, v1946 = proto.writeTag(buf, n126, 1, proto.wireTypes.lengthDelimited)

				buf, n126 = proto.writeBuffer(v1945, v1946, v1944, buffer.len(v1944))
			end

			if p193.config_key ~= nil then
				local v1947 = p193.config_key:encode()
				local v1948, v1949 = proto.writeTag(buf, n126, 2, proto.wireTypes.lengthDelimited)

				buf, n126 = proto.writeBuffer(v1948, v1949, v1947, buffer.len(v1947))
			end

			local buf66 = buffer.create(n126)

			buffer.copy(buf66, 0, buf, 0, n126)

			return buf66
		end
		function t255.decode(p194: buffer) -- line: 14593
			-- upvalues: t255 (copy), proto (copy), prop_types (copy)
			local v1952 = t255.new()
			local n127 = 0

			while n127 < buffer.len(p194) do
				local v1954, v1955

				v1954, v1955, n127 = proto.readTag(p194, n127)

				if v1955 == proto.wireTypes.varint then
					local v1956

					v1956, n127 = proto.readVarInt(p194, n127)
				elseif v1955 == proto.wireTypes.lengthDelimited then
					if v1954 == 1 then
						local v1957

						v1957, n127 = proto.readBuffer(p194, n127)
						v1952.surface_key = prop_types.StringProp.decode(v1957)
					elseif v1954 == 2 then
						local v1958

						v1958, n127 = proto.readBuffer(p194, n127)
						v1952.config_key = prop_types.StringProp.decode(v1958)
					else
						local v1959, v1960 = proto.readVarInt(p194, n127)

						n127 = v1960 + v1959
					end
				elseif v1955 == proto.wireTypes.i32 then
					local v1961

					v1961, n127 = proto.readFixed32(p194, n127)
				elseif v1955 == proto.wireTypes.i64 then
					local v1962

					v1962, n127 = proto.readFixed64(p194, n127)
				else
					error("Unsupported wire type: " .. v1955)
				end
			end

			return v1952
		end
		function t255.jsonEncode(p195) -- line: 14641
			local t257 = {}

			if p195.surface_key ~= nil then
				t257.surfaceKey = p195.surface_key:jsonEncode()
			end

			if p195.config_key ~= nil then
				t257.configKey = p195.config_key:jsonEncode()
			end

			return t257
		end
		function t255.jsonDecode(t258: {[any]: any}) -- line: 14655
			-- upvalues: t255 (copy), prop_types (copy)
			local v1966 = t255.new()

			if t258.surface_key ~= nil then
				v1966.surface_key = prop_types.StringProp.jsonDecode(t258.surface_key)
			end

			if t258.surfaceKey ~= nil then
				v1966.surface_key = prop_types.StringProp.jsonDecode(t258.surfaceKey)
			end

			if t258.config_key ~= nil then
				v1966.config_key = prop_types.StringProp.jsonDecode(t258.config_key)
			end

			if t258.configKey ~= nil then
				v1966.config_key = prop_types.StringProp.jsonDecode(t258.configKey)
			end

			return v1966
		end

		t255.descriptor = {
			name = "RefreshFromApiAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshFromApiAction_Params = t255
		typeRegistry.default:register(t1.RefreshFromApiAction_Params)

		local t259 = {}

		t259.__index = t259

		function t259.new(t260: {[any]: any}?) -- line: 14692
			-- upvalues: t1 (copy), t259 (copy)
			return (setmetatable({
				action_type = if t260 ~= nil and t260.action_type ~= nil then t260.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t260 ~= nil and t260.action_params ~= nil then t260.action_params else nil
			}, t259))
		end
		function t259.encode(p196) -- line: 14703
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n128 = 0

			if p196.action_type ~= nil and (p196.action_type ~= nil and p196.action_type ~= 0 or p196.action_type ~= t1.ActionType.fromNumber(0)) then
				local v1971, v1972 = proto.writeTag(buf, n128, 1, proto.wireTypes.varint)

				buf, n128 = proto.writeVarInt(v1971, v1972, t1.ActionType.toNumber(p196.action_type))
			end

			if p196.action_params ~= nil then
				local v1973 = p196.action_params:encode()
				local v1974, v1975 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

				buf, n128 = proto.writeBuffer(v1974, v1975, v1973, buffer.len(v1973))
			end

			local buf67 = buffer.create(n128)

			buffer.copy(buf67, 0, buf, 0, n128)

			return buf67
		end
		function t259.decode(p197: buffer) -- line: 14729
			-- upvalues: t259 (copy), proto (copy), t1 (copy)
			local v1978 = t259.new()
			local n129 = 0

			while n129 < buffer.len(p197) do
				local v1980, v1981

				v1980, v1981, n129 = proto.readTag(p197, n129)

				if v1981 == proto.wireTypes.varint then
					if v1980 == 1 then
						local v1982

						v1982, n129 = proto.readVarIntI32(p197, n129)
						v1978.action_type = t1.ActionType.fromNumber(v1982) or v1982
					else
						local v1983

						v1983, n129 = proto.readVarInt(p197, n129)
					end
				elseif v1981 == proto.wireTypes.lengthDelimited then
					if v1980 == 2 then
						local v1984

						v1984, n129 = proto.readBuffer(p197, n129)
						v1978.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.decode(v1984)
					else
						local v1985, v1986 = proto.readVarInt(p197, n129)

						n129 = v1986 + v1985
					end
				elseif v1981 == proto.wireTypes.i32 then
					local v1987

					v1987, n129 = proto.readFixed32(p197, n129)
				elseif v1981 == proto.wireTypes.i64 then
					local v1988

					v1988, n129 = proto.readFixed64(p197, n129)
				else
					error("Unsupported wire type: " .. v1981)
				end
			end

			return v1978
		end
		function t259.jsonEncode(p198) -- line: 14777
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
		function t259.jsonDecode(t262: {[any]: any}) -- line: 14799
			-- upvalues: t259 (copy), t1 (copy)
			local v1992 = t259.new()

			if t262.action_type ~= nil then
				v1992.action_type = if typeof(t262.action_type) ~= "number" then t1.ActionType.fromName(t262.action_type) or t262.action_type else t1.ActionType.fromNumber(t262.action_type) or t262.action_type
			end

			if t262.actionType ~= nil then
				v1992.action_type = if typeof(t262.actionType) ~= "number" then t1.ActionType.fromName(t262.actionType) or t262.actionType else t1.ActionType.fromNumber(t262.actionType) or t262.actionType
			end

			if t262.action_params ~= nil then
				v1992.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t262.action_params)
			end

			if t262.actionParams ~= nil then
				v1992.action_params = t1.RefreshOmniRecommendationFeedItemAction_Params.jsonDecode(t262.actionParams)
			end

			return v1992
		end

		t259.descriptor = {
			name = "RefreshOmniRecommendationFeedItemAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshOmniRecommendationFeedItemAction"
		}
		t1.RefreshOmniRecommendationFeedItemAction = t259
	end

	typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction)

	do
		local t263 = {}

		t263.__index = t263

		function t263.new(t264: {[any]: any}?) -- line: 14841
			-- upvalues: t263 (copy)
			return (setmetatable({
				topic_id = if t264 ~= nil and t264.topic_id ~= nil then t264.topic_id else nil,
				selected_option = if t264 ~= nil and t264.selected_option ~= nil then t264.selected_option else nil,
				request_intent = if t264 ~= nil and t264.request_intent ~= nil then t264.request_intent else nil,
				feed_item_key = if t264 ~= nil and t264.feed_item_key ~= nil then t264.feed_item_key else nil
			}, t263))
		end
		function t263.encode(p199) -- line: 14852
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n130 = 0

			if p199.topic_id ~= nil then
				local v1997 = p199.topic_id:encode()
				local v1998, v1999 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v1998, v1999, v1997, buffer.len(v1997))
			end

			if p199.selected_option ~= nil then
				local v2000 = p199.selected_option:encode()
				local v2001, v2002 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2001, v2002, v2000, buffer.len(v2000))
			end

			if p199.request_intent ~= nil then
				local v2003 = p199.request_intent:encode()
				local v2004, v2005 = proto.writeTag(buf, n130, 3, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2004, v2005, v2003, buffer.len(v2003))
			end

			if p199.feed_item_key ~= nil then
				local v2006 = p199.feed_item_key:encode()
				local v2007, v2008 = proto.writeTag(buf, n130, 4, proto.wireTypes.lengthDelimited)

				buf, n130 = proto.writeBuffer(v2007, v2008, v2006, buffer.len(v2006))
			end

			local buf68 = buffer.create(n130)

			buffer.copy(buf68, 0, buf, 0, n130)

			return buf68
		end
		function t263.decode(p200: buffer) -- line: 14887
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
						v2011.topic_id = prop_types.StringProp.decode(v2016)
					elseif v2013 == 2 then
						local v2017

						v2017, n131 = proto.readBuffer(p200, n131)
						v2011.selected_option = prop_types.StringProp.decode(v2017)
					elseif v2013 == 3 then
						local v2018

						v2018, n131 = proto.readBuffer(p200, n131)
						v2011.request_intent = prop_types.StringProp.decode(v2018)
					elseif v2013 == 4 then
						local v2019

						v2019, n131 = proto.readBuffer(p200, n131)
						v2011.feed_item_key = prop_types.StringProp.decode(v2019)
					else
						local v2020, v2021 = proto.readVarInt(p200, n131)

						n131 = v2021 + v2020
					end
				elseif v2014 == proto.wireTypes.i32 then
					local v2022

					v2022, n131 = proto.readFixed32(p200, n131)
				elseif v2014 == proto.wireTypes.i64 then
					local v2023

					v2023, n131 = proto.readFixed64(p200, n131)
				else
					error("Unsupported wire type: " .. v2014)
				end
			end

			return v2011
		end
		function t263.jsonEncode(p201) -- line: 14947
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
		function t263.jsonDecode(t266: {[any]: any}) -- line: 14971
			-- upvalues: t263 (copy), prop_types (copy)
			local v2027 = t263.new()

			if t266.topic_id ~= nil then
				v2027.topic_id = prop_types.StringProp.jsonDecode(t266.topic_id)
			end

			if t266.topicId ~= nil then
				v2027.topic_id = prop_types.StringProp.jsonDecode(t266.topicId)
			end

			if t266.selected_option ~= nil then
				v2027.selected_option = prop_types.StringProp.jsonDecode(t266.selected_option)
			end

			if t266.selectedOption ~= nil then
				v2027.selected_option = prop_types.StringProp.jsonDecode(t266.selectedOption)
			end

			if t266.request_intent ~= nil then
				v2027.request_intent = prop_types.StringProp.jsonDecode(t266.request_intent)
			end

			if t266.requestIntent ~= nil then
				v2027.request_intent = prop_types.StringProp.jsonDecode(t266.requestIntent)
			end

			if t266.feed_item_key ~= nil then
				v2027.feed_item_key = prop_types.StringProp.jsonDecode(t266.feed_item_key)
			end

			if t266.feedItemKey ~= nil then
				v2027.feed_item_key = prop_types.StringProp.jsonDecode(t266.feedItemKey)
			end

			return v2027
		end

		t263.descriptor = {
			name = "RefreshOmniRecommendationFeedItemAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshOmniRecommendationFeedItemAction_Params = t263
		typeRegistry.default:register(t1.RefreshOmniRecommendationFeedItemAction_Params)

		local t267 = {}

		t267.__index = t267

		function t267.new(t268: {[any]: any}?) -- line: 15031
			-- upvalues: t1 (copy), t267 (copy)
			return (setmetatable({
				action_type = if t268 ~= nil and t268.action_type ~= nil then t268.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t268 ~= nil and t268.action_params ~= nil then t268.action_params else nil
			}, t267))
		end
		function t267.encode(p202) -- line: 15040
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n132 = 0

			if p202.action_type ~= nil and (p202.action_type ~= nil and p202.action_type ~= 0 or p202.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2032, v2033 = proto.writeTag(buf, n132, 1, proto.wireTypes.varint)

				buf, n132 = proto.writeVarInt(v2032, v2033, t1.ActionType.toNumber(p202.action_type))
			end

			if p202.action_params ~= nil then
				local v2034 = p202.action_params:encode()
				local v2035, v2036 = proto.writeTag(buf, n132, 2, proto.wireTypes.lengthDelimited)

				buf, n132 = proto.writeBuffer(v2035, v2036, v2034, buffer.len(v2034))
			end

			local buf69 = buffer.create(n132)

			buffer.copy(buf69, 0, buf, 0, n132)

			return buf69
		end
		function t267.decode(p203: buffer) -- line: 15066
			-- upvalues: t267 (copy), proto (copy), t1 (copy)
			local v2039 = t267.new()
			local n133 = 0

			while n133 < buffer.len(p203) do
				local v2041, v2042

				v2041, v2042, n133 = proto.readTag(p203, n133)

				if v2042 == proto.wireTypes.varint then
					if v2041 == 1 then
						local v2043

						v2043, n133 = proto.readVarIntI32(p203, n133)
						v2039.action_type = t1.ActionType.fromNumber(v2043) or v2043
					else
						local v2044

						v2044, n133 = proto.readVarInt(p203, n133)
					end
				elseif v2042 == proto.wireTypes.lengthDelimited then
					if v2041 == 2 then
						local v2045

						v2045, n133 = proto.readBuffer(p203, n133)
						v2039.action_params = t1.RsvpToEventAction_Params.decode(v2045)
					else
						local v2046, v2047 = proto.readVarInt(p203, n133)

						n133 = v2047 + v2046
					end
				elseif v2042 == proto.wireTypes.i32 then
					local v2048

					v2048, n133 = proto.readFixed32(p203, n133)
				elseif v2042 == proto.wireTypes.i64 then
					local v2049

					v2049, n133 = proto.readFixed64(p203, n133)
				else
					error("Unsupported wire type: " .. v2042)
				end
			end

			return v2039
		end
		function t267.jsonEncode(p204) -- line: 15114
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
		function t267.jsonDecode(t270: {[any]: any}) -- line: 15136
			-- upvalues: t267 (copy), t1 (copy)
			local v2053 = t267.new()

			if t270.action_type ~= nil then
				v2053.action_type = if typeof(t270.action_type) ~= "number" then t1.ActionType.fromName(t270.action_type) or t270.action_type else t1.ActionType.fromNumber(t270.action_type) or t270.action_type
			end

			if t270.actionType ~= nil then
				v2053.action_type = if typeof(t270.actionType) ~= "number" then t1.ActionType.fromName(t270.actionType) or t270.actionType else t1.ActionType.fromNumber(t270.actionType) or t270.actionType
			end

			if t270.action_params ~= nil then
				v2053.action_params = t1.RsvpToEventAction_Params.jsonDecode(t270.action_params)
			end

			if t270.actionParams ~= nil then
				v2053.action_params = t1.RsvpToEventAction_Params.jsonDecode(t270.actionParams)
			end

			return v2053
		end

		t267.descriptor = {
			name = "RsvpToEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RsvpToEventAction"
		}
		t1.RsvpToEventAction = t267
	end

	typeRegistry.default:register(t1.RsvpToEventAction)

	do
		local t271 = {}

		t271.__index = t271

		function t271.new(t272: {[any]: any}?) -- line: 15176
			-- upvalues: t271 (copy)
			return (setmetatable({
				event_id = if t272 ~= nil and t272.event_id ~= nil then t272.event_id else nil,
				user_rsvp = if t272 ~= nil and t272.user_rsvp ~= nil then t272.user_rsvp else nil,
				notifications_modal_identifier = if t272 ~= nil and t272.notifications_modal_identifier ~= nil then t272.notifications_modal_identifier else nil
			}, t271))
		end
		function t271.encode(p205) -- line: 15186
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n134 = 0

			if p205.event_id ~= nil then
				local v2058 = p205.event_id:encode()
				local v2059, v2060 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2059, v2060, v2058, buffer.len(v2058))
			end

			if p205.user_rsvp ~= nil then
				local v2061 = p205.user_rsvp:encode()
				local v2062, v2063 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2062, v2063, v2061, buffer.len(v2061))
			end

			if p205.notifications_modal_identifier ~= nil then
				local v2064 = p205.notifications_modal_identifier:encode()
				local v2065, v2066 = proto.writeTag(buf, n134, 3, proto.wireTypes.lengthDelimited)

				buf, n134 = proto.writeBuffer(v2065, v2066, v2064, buffer.len(v2064))
			end

			local buf70 = buffer.create(n134)

			buffer.copy(buf70, 0, buf, 0, n134)

			return buf70
		end
		function t271.decode(p206: buffer) -- line: 15213
			-- upvalues: t271 (copy), proto (copy), prop_types (copy)
			local v2069 = t271.new()
			local n135 = 0

			while n135 < buffer.len(p206) do
				local v2071, v2072

				v2071, v2072, n135 = proto.readTag(p206, n135)

				if v2072 == proto.wireTypes.varint then
					local v2073

					v2073, n135 = proto.readVarInt(p206, n135)
				elseif v2072 == proto.wireTypes.lengthDelimited then
					if v2071 == 1 then
						local v2074

						v2074, n135 = proto.readBuffer(p206, n135)
						v2069.event_id = prop_types.StringProp.decode(v2074)
					elseif v2071 == 2 then
						local v2075

						v2075, n135 = proto.readBuffer(p206, n135)
						v2069.user_rsvp = prop_types.BoolProp.decode(v2075)
					elseif v2071 == 3 then
						local v2076

						v2076, n135 = proto.readBuffer(p206, n135)
						v2069.notifications_modal_identifier = prop_types.StringProp.decode(v2076)
					else
						local v2077, v2078 = proto.readVarInt(p206, n135)

						n135 = v2078 + v2077
					end
				elseif v2072 == proto.wireTypes.i32 then
					local v2079

					v2079, n135 = proto.readFixed32(p206, n135)
				elseif v2072 == proto.wireTypes.i64 then
					local v2080

					v2080, n135 = proto.readFixed64(p206, n135)
				else
					error("Unsupported wire type: " .. v2072)
				end
			end

			return v2069
		end
		function t271.jsonEncode(p207) -- line: 15267
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
		function t271.jsonDecode(t274: {[any]: any}) -- line: 15285
			-- upvalues: t271 (copy), prop_types (copy)
			local v2084 = t271.new()

			if t274.event_id ~= nil then
				v2084.event_id = prop_types.StringProp.jsonDecode(t274.event_id)
			end

			if t274.eventId ~= nil then
				v2084.event_id = prop_types.StringProp.jsonDecode(t274.eventId)
			end

			if t274.user_rsvp ~= nil then
				v2084.user_rsvp = prop_types.BoolProp.jsonDecode(t274.user_rsvp)
			end

			if t274.userRsvp ~= nil then
				v2084.user_rsvp = prop_types.BoolProp.jsonDecode(t274.userRsvp)
			end

			if t274.notifications_modal_identifier ~= nil then
				v2084.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t274.notifications_modal_identifier)
			end

			if t274.notificationsModalIdentifier ~= nil then
				v2084.notifications_modal_identifier = prop_types.StringProp.jsonDecode(t274.notificationsModalIdentifier)
			end

			return v2084
		end

		t271.descriptor = {
			name = "RsvpToEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RsvpToEventAction_Params = t271
		typeRegistry.default:register(t1.RsvpToEventAction_Params)

		local t275 = {}

		t275.__index = t275

		function t275.new(t276: {[any]: any}?) -- line: 15335
			-- upvalues: t1 (copy), t275 (copy)
			return (setmetatable({
				action_type = if t276 ~= nil and t276.action_type ~= nil then t276.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t276 ~= nil and t276.action_params ~= nil then t276.action_params else nil
			}, t275))
		end
		function t275.encode(p208) -- line: 15344
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n136 = 0

			if p208.action_type ~= nil and (p208.action_type ~= nil and p208.action_type ~= 0 or p208.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2089, v2090 = proto.writeTag(buf, n136, 1, proto.wireTypes.varint)

				buf, n136 = proto.writeVarInt(v2089, v2090, t1.ActionType.toNumber(p208.action_type))
			end

			if p208.action_params ~= nil then
				local v2091 = p208.action_params:encode()
				local v2092, v2093 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

				buf, n136 = proto.writeBuffer(v2092, v2093, v2091, buffer.len(v2091))
			end

			local buf71 = buffer.create(n136)

			buffer.copy(buf71, 0, buf, 0, n136)

			return buf71
		end
		function t275.decode(p209: buffer) -- line: 15370
			-- upvalues: t275 (copy), proto (copy), t1 (copy)
			local v2096 = t275.new()
			local n137 = 0

			while n137 < buffer.len(p209) do
				local v2098, v2099

				v2098, v2099, n137 = proto.readTag(p209, n137)

				if v2099 == proto.wireTypes.varint then
					if v2098 == 1 then
						local v2100

						v2100, n137 = proto.readVarIntI32(p209, n137)
						v2096.action_type = t1.ActionType.fromNumber(v2100) or v2100
					else
						local v2101

						v2101, n137 = proto.readVarInt(p209, n137)
					end
				elseif v2099 == proto.wireTypes.lengthDelimited then
					if v2098 == 2 then
						local v2102

						v2102, n137 = proto.readBuffer(p209, n137)
						v2096.action_params = t1.OpenEventDetailsAction_Params.decode(v2102)
					else
						local v2103, v2104 = proto.readVarInt(p209, n137)

						n137 = v2104 + v2103
					end
				elseif v2099 == proto.wireTypes.i32 then
					local v2105

					v2105, n137 = proto.readFixed32(p209, n137)
				elseif v2099 == proto.wireTypes.i64 then
					local v2106

					v2106, n137 = proto.readFixed64(p209, n137)
				else
					error("Unsupported wire type: " .. v2099)
				end
			end

			return v2096
		end
		function t275.jsonEncode(p210) -- line: 15418
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
		function t275.jsonDecode(t278: {[any]: any}) -- line: 15440
			-- upvalues: t275 (copy), t1 (copy)
			local v2110 = t275.new()

			if t278.action_type ~= nil then
				v2110.action_type = if typeof(t278.action_type) ~= "number" then t1.ActionType.fromName(t278.action_type) or t278.action_type else t1.ActionType.fromNumber(t278.action_type) or t278.action_type
			end

			if t278.actionType ~= nil then
				v2110.action_type = if typeof(t278.actionType) ~= "number" then t1.ActionType.fromName(t278.actionType) or t278.actionType else t1.ActionType.fromNumber(t278.actionType) or t278.actionType
			end

			if t278.action_params ~= nil then
				v2110.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t278.action_params)
			end

			if t278.actionParams ~= nil then
				v2110.action_params = t1.OpenEventDetailsAction_Params.jsonDecode(t278.actionParams)
			end

			return v2110
		end

		t275.descriptor = {
			name = "OpenEventDetailsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenEventDetailsAction"
		}
		t1.OpenEventDetailsAction = t275
	end

	typeRegistry.default:register(t1.OpenEventDetailsAction)

	do
		local t279 = {}

		t279.__index = t279

		function t279.new(t280: {[any]: any}?) -- line: 15480
			-- upvalues: t279 (copy)
			return (setmetatable({
				event_id = if t280 ~= nil and t280.event_id ~= nil then t280.event_id else nil
			}, t279))
		end
		function t279.encode(p211) -- line: 15488
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n138 = 0

			if p211.event_id ~= nil then
				local v2115 = p211.event_id:encode()
				local v2116, v2117 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

				buf, n138 = proto.writeBuffer(v2116, v2117, v2115, buffer.len(v2115))
			end

			local buf72 = buffer.create(n138)

			buffer.copy(buf72, 0, buf, 0, n138)

			return buf72
		end
		function t279.decode(p212: buffer) -- line: 15503
			-- upvalues: t279 (copy), proto (copy), prop_types (copy)
			local v2120 = t279.new()
			local n139 = 0

			while n139 < buffer.len(p212) do
				local v2122, v2123

				v2122, v2123, n139 = proto.readTag(p212, n139)

				if v2123 == proto.wireTypes.varint then
					local v2124

					v2124, n139 = proto.readVarInt(p212, n139)
				elseif v2123 == proto.wireTypes.lengthDelimited then
					if v2122 == 1 then
						local v2125

						v2125, n139 = proto.readBuffer(p212, n139)
						v2120.event_id = prop_types.StringProp.decode(v2125)
					else
						local v2126, v2127 = proto.readVarInt(p212, n139)

						n139 = v2127 + v2126
					end
				elseif v2123 == proto.wireTypes.i32 then
					local v2128

					v2128, n139 = proto.readFixed32(p212, n139)
				elseif v2123 == proto.wireTypes.i64 then
					local v2129

					v2129, n139 = proto.readFixed64(p212, n139)
				else
					error("Unsupported wire type: " .. v2123)
				end
			end

			return v2120
		end
		function t279.jsonEncode(p213) -- line: 15546
			local t281 = {}

			if p213.event_id ~= nil then
				t281.eventId = p213.event_id:jsonEncode()
			end

			return t281
		end
		function t279.jsonDecode(t282: {[any]: any}) -- line: 15556
			-- upvalues: t279 (copy), prop_types (copy)
			local v2133 = t279.new()

			if t282.event_id ~= nil then
				v2133.event_id = prop_types.StringProp.jsonDecode(t282.event_id)
			end

			if t282.eventId ~= nil then
				v2133.event_id = prop_types.StringProp.jsonDecode(t282.eventId)
			end

			return v2133
		end

		t279.descriptor = {
			name = "OpenEventDetailsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenEventDetailsAction_Params = t279
		typeRegistry.default:register(t1.OpenEventDetailsAction_Params)

		local t283 = {}

		t283.__index = t283

		function t283.new(t284: {[any]: any}?) -- line: 15584
			-- upvalues: t1 (copy), t283 (copy)
			return (setmetatable({
				action_type = if t284 ~= nil and t284.action_type ~= nil then t284.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t284 ~= nil and t284.action_params ~= nil then t284.action_params else nil
			}, t283))
		end
		function t283.encode(p214) -- line: 15593
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n140 = 0

			if p214.action_type ~= nil and (p214.action_type ~= nil and p214.action_type ~= 0 or p214.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2138, v2139 = proto.writeTag(buf, n140, 1, proto.wireTypes.varint)

				buf, n140 = proto.writeVarInt(v2138, v2139, t1.ActionType.toNumber(p214.action_type))
			end

			if p214.action_params ~= nil then
				local v2140 = p214.action_params:encode()
				local v2141, v2142 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

				buf, n140 = proto.writeBuffer(v2141, v2142, v2140, buffer.len(v2140))
			end

			local buf73 = buffer.create(n140)

			buffer.copy(buf73, 0, buf, 0, n140)

			return buf73
		end
		function t283.decode(p215: buffer) -- line: 15619
			-- upvalues: t283 (copy), proto (copy), t1 (copy)
			local v2145 = t283.new()
			local n141 = 0

			while n141 < buffer.len(p215) do
				local v2147, v2148

				v2147, v2148, n141 = proto.readTag(p215, n141)

				if v2148 == proto.wireTypes.varint then
					if v2147 == 1 then
						local v2149

						v2149, n141 = proto.readVarIntI32(p215, n141)
						v2145.action_type = t1.ActionType.fromNumber(v2149) or v2149
					else
						local v2150

						v2150, n141 = proto.readVarInt(p215, n141)
					end
				elseif v2148 == proto.wireTypes.lengthDelimited then
					if v2147 == 2 then
						local v2151

						v2151, n141 = proto.readBuffer(p215, n141)
						v2145.action_params = t1.OpenBadgesSeeAllAction_Params.decode(v2151)
					else
						local v2152, v2153 = proto.readVarInt(p215, n141)

						n141 = v2153 + v2152
					end
				elseif v2148 == proto.wireTypes.i32 then
					local v2154

					v2154, n141 = proto.readFixed32(p215, n141)
				elseif v2148 == proto.wireTypes.i64 then
					local v2155

					v2155, n141 = proto.readFixed64(p215, n141)
				else
					error("Unsupported wire type: " .. v2148)
				end
			end

			return v2145
		end
		function t283.jsonEncode(p216) -- line: 15667
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
		function t283.jsonDecode(t286: {[any]: any}) -- line: 15689
			-- upvalues: t283 (copy), t1 (copy)
			local v2159 = t283.new()

			if t286.action_type ~= nil then
				v2159.action_type = if typeof(t286.action_type) ~= "number" then t1.ActionType.fromName(t286.action_type) or t286.action_type else t1.ActionType.fromNumber(t286.action_type) or t286.action_type
			end

			if t286.actionType ~= nil then
				v2159.action_type = if typeof(t286.actionType) ~= "number" then t1.ActionType.fromName(t286.actionType) or t286.actionType else t1.ActionType.fromNumber(t286.actionType) or t286.actionType
			end

			if t286.action_params ~= nil then
				v2159.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t286.action_params)
			end

			if t286.actionParams ~= nil then
				v2159.action_params = t1.OpenBadgesSeeAllAction_Params.jsonDecode(t286.actionParams)
			end

			return v2159
		end

		t283.descriptor = {
			name = "OpenBadgesSeeAllAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenBadgesSeeAllAction"
		}
		t1.OpenBadgesSeeAllAction = t283
	end

	typeRegistry.default:register(t1.OpenBadgesSeeAllAction)

	do
		local t287 = {}

		t287.__index = t287

		function t287.new(t288: {[any]: any}?) -- line: 15729
			-- upvalues: t287 (copy)
			return (setmetatable({
				universe_id = if t288 ~= nil and t288.universe_id ~= nil then t288.universe_id else nil
			}, t287))
		end
		function t287.encode(p217) -- line: 15737
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n142 = 0

			if p217.universe_id ~= nil then
				local v2164 = p217.universe_id:encode()
				local v2165, v2166 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

				buf, n142 = proto.writeBuffer(v2165, v2166, v2164, buffer.len(v2164))
			end

			local buf74 = buffer.create(n142)

			buffer.copy(buf74, 0, buf, 0, n142)

			return buf74
		end
		function t287.decode(p218: buffer) -- line: 15752
			-- upvalues: t287 (copy), proto (copy), prop_types (copy)
			local v2169 = t287.new()
			local n143 = 0

			while n143 < buffer.len(p218) do
				local v2171, v2172

				v2171, v2172, n143 = proto.readTag(p218, n143)

				if v2172 == proto.wireTypes.varint then
					local v2173

					v2173, n143 = proto.readVarInt(p218, n143)
				elseif v2172 == proto.wireTypes.lengthDelimited then
					if v2171 == 1 then
						local v2174

						v2174, n143 = proto.readBuffer(p218, n143)
						v2169.universe_id = prop_types.StringProp.decode(v2174)
					else
						local v2175, v2176 = proto.readVarInt(p218, n143)

						n143 = v2176 + v2175
					end
				elseif v2172 == proto.wireTypes.i32 then
					local v2177

					v2177, n143 = proto.readFixed32(p218, n143)
				elseif v2172 == proto.wireTypes.i64 then
					local v2178

					v2178, n143 = proto.readFixed64(p218, n143)
				else
					error("Unsupported wire type: " .. v2172)
				end
			end

			return v2169
		end
		function t287.jsonEncode(p219) -- line: 15795
			local t289 = {}

			if p219.universe_id ~= nil then
				t289.universeId = p219.universe_id:jsonEncode()
			end

			return t289
		end
		function t287.jsonDecode(t290: {[any]: any}) -- line: 15805
			-- upvalues: t287 (copy), prop_types (copy)
			local v2182 = t287.new()

			if t290.universe_id ~= nil then
				v2182.universe_id = prop_types.StringProp.jsonDecode(t290.universe_id)
			end

			if t290.universeId ~= nil then
				v2182.universe_id = prop_types.StringProp.jsonDecode(t290.universeId)
			end

			return v2182
		end

		t287.descriptor = {
			name = "OpenBadgesSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenBadgesSeeAllAction_Params = t287
		typeRegistry.default:register(t1.OpenBadgesSeeAllAction_Params)

		local t291 = {}

		t291.__index = t291

		function t291.new(t292: {[any]: any}?) -- line: 15834
			-- upvalues: t1 (copy), t291 (copy)
			return (setmetatable({
				action_type = if t292 ~= nil and t292.action_type ~= nil then t292.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t292 ~= nil and t292.action_params ~= nil then t292.action_params else nil
			}, t291))
		end
		function t291.encode(p220) -- line: 15845
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n144 = 0

			if p220.action_type ~= nil and (p220.action_type ~= nil and p220.action_type ~= 0 or p220.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2187, v2188 = proto.writeTag(buf, n144, 1, proto.wireTypes.varint)

				buf, n144 = proto.writeVarInt(v2187, v2188, t1.ActionType.toNumber(p220.action_type))
			end

			if p220.action_params ~= nil then
				local v2189 = p220.action_params:encode()
				local v2190, v2191 = proto.writeTag(buf, n144, 2, proto.wireTypes.lengthDelimited)

				buf, n144 = proto.writeBuffer(v2190, v2191, v2189, buffer.len(v2189))
			end

			local buf75 = buffer.create(n144)

			buffer.copy(buf75, 0, buf, 0, n144)

			return buf75
		end
		function t291.decode(p221: buffer) -- line: 15871
			-- upvalues: t291 (copy), proto (copy), t1 (copy)
			local v2194 = t291.new()
			local n145 = 0

			while n145 < buffer.len(p221) do
				local v2196, v2197

				v2196, v2197, n145 = proto.readTag(p221, n145)

				if v2197 == proto.wireTypes.varint then
					if v2196 == 1 then
						local v2198

						v2198, n145 = proto.readVarIntI32(p221, n145)
						v2194.action_type = t1.ActionType.fromNumber(v2198) or v2198
					else
						local v2199

						v2199, n145 = proto.readVarInt(p221, n145)
					end
				elseif v2197 == proto.wireTypes.lengthDelimited then
					if v2196 == 2 then
						local v2200

						v2200, n145 = proto.readBuffer(p221, n145)
						v2194.action_params = t1.OpenExperienceStoreSeeAllAction_Params.decode(v2200)
					else
						local v2201, v2202 = proto.readVarInt(p221, n145)

						n145 = v2202 + v2201
					end
				elseif v2197 == proto.wireTypes.i32 then
					local v2203

					v2203, n145 = proto.readFixed32(p221, n145)
				elseif v2197 == proto.wireTypes.i64 then
					local v2204

					v2204, n145 = proto.readFixed64(p221, n145)
				else
					error("Unsupported wire type: " .. v2197)
				end
			end

			return v2194
		end
		function t291.jsonEncode(p222) -- line: 15919
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
		function t291.jsonDecode(t294: {[any]: any}) -- line: 15941
			-- upvalues: t291 (copy), t1 (copy)
			local v2208 = t291.new()

			if t294.action_type ~= nil then
				v2208.action_type = if typeof(t294.action_type) ~= "number" then t1.ActionType.fromName(t294.action_type) or t294.action_type else t1.ActionType.fromNumber(t294.action_type) or t294.action_type
			end

			if t294.actionType ~= nil then
				v2208.action_type = if typeof(t294.actionType) ~= "number" then t1.ActionType.fromName(t294.actionType) or t294.actionType else t1.ActionType.fromNumber(t294.actionType) or t294.actionType
			end

			if t294.action_params ~= nil then
				v2208.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t294.action_params)
			end

			if t294.actionParams ~= nil then
				v2208.action_params = t1.OpenExperienceStoreSeeAllAction_Params.jsonDecode(t294.actionParams)
			end

			return v2208
		end

		t291.descriptor = {
			name = "OpenExperienceStoreSeeAllAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenExperienceStoreSeeAllAction"
		}
		t1.OpenExperienceStoreSeeAllAction = t291
	end

	typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction)

	do
		local t295 = {}

		t295.__index = t295

		function t295.new(t296: {[any]: any}?) -- line: 15981
			-- upvalues: t295 (copy)
			return (setmetatable({
				universe_id = if t296 ~= nil and t296.universe_id ~= nil then t296.universe_id else nil
			}, t295))
		end
		function t295.encode(p223) -- line: 15989
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n146 = 0

			if p223.universe_id ~= nil then
				local v2213 = p223.universe_id:encode()
				local v2214, v2215 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

				buf, n146 = proto.writeBuffer(v2214, v2215, v2213, buffer.len(v2213))
			end

			local buf76 = buffer.create(n146)

			buffer.copy(buf76, 0, buf, 0, n146)

			return buf76
		end
		function t295.decode(p224: buffer) -- line: 16004
			-- upvalues: t295 (copy), proto (copy), prop_types (copy)
			local v2218 = t295.new()
			local n147 = 0

			while n147 < buffer.len(p224) do
				local v2220, v2221

				v2220, v2221, n147 = proto.readTag(p224, n147)

				if v2221 == proto.wireTypes.varint then
					local v2222

					v2222, n147 = proto.readVarInt(p224, n147)
				elseif v2221 == proto.wireTypes.lengthDelimited then
					if v2220 == 1 then
						local v2223

						v2223, n147 = proto.readBuffer(p224, n147)
						v2218.universe_id = prop_types.StringProp.decode(v2223)
					else
						local v2224, v2225 = proto.readVarInt(p224, n147)

						n147 = v2225 + v2224
					end
				elseif v2221 == proto.wireTypes.i32 then
					local v2226

					v2226, n147 = proto.readFixed32(p224, n147)
				elseif v2221 == proto.wireTypes.i64 then
					local v2227

					v2227, n147 = proto.readFixed64(p224, n147)
				else
					error("Unsupported wire type: " .. v2221)
				end
			end

			return v2218
		end
		function t295.jsonEncode(p225) -- line: 16047
			local t297 = {}

			if p225.universe_id ~= nil then
				t297.universeId = p225.universe_id:jsonEncode()
			end

			return t297
		end
		function t295.jsonDecode(t298: {[any]: any}) -- line: 16057
			-- upvalues: t295 (copy), prop_types (copy)
			local v2231 = t295.new()

			if t298.universe_id ~= nil then
				v2231.universe_id = prop_types.StringProp.jsonDecode(t298.universe_id)
			end

			if t298.universeId ~= nil then
				v2231.universe_id = prop_types.StringProp.jsonDecode(t298.universeId)
			end

			return v2231
		end

		t295.descriptor = {
			name = "OpenExperienceStoreSeeAllAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenExperienceStoreSeeAllAction_Params = t295
		typeRegistry.default:register(t1.OpenExperienceStoreSeeAllAction_Params)

		local t299 = {}

		t299.__index = t299

		function t299.new(t300: {[any]: any}?) -- line: 16088
			-- upvalues: t1 (copy), t299 (copy)
			return (setmetatable({
				action_type = if t300 ~= nil and t300.action_type ~= nil then t300.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t300 ~= nil and t300.action_params ~= nil then t300.action_params else nil
			}, t299))
		end
		function t299.encode(p226) -- line: 16099
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n148 = 0

			if p226.action_type ~= nil and (p226.action_type ~= nil and p226.action_type ~= 0 or p226.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2236, v2237 = proto.writeTag(buf, n148, 1, proto.wireTypes.varint)

				buf, n148 = proto.writeVarInt(v2236, v2237, t1.ActionType.toNumber(p226.action_type))
			end

			if p226.action_params ~= nil then
				local v2238 = p226.action_params:encode()
				local v2239, v2240 = proto.writeTag(buf, n148, 2, proto.wireTypes.lengthDelimited)

				buf, n148 = proto.writeBuffer(v2239, v2240, v2238, buffer.len(v2238))
			end

			local buf77 = buffer.create(n148)

			buffer.copy(buf77, 0, buf, 0, n148)

			return buf77
		end
		function t299.decode(p227: buffer) -- line: 16125
			-- upvalues: t299 (copy), proto (copy), t1 (copy)
			local v2243 = t299.new()
			local n149 = 0

			while n149 < buffer.len(p227) do
				local v2245, v2246

				v2245, v2246, n149 = proto.readTag(p227, n149)

				if v2246 == proto.wireTypes.varint then
					if v2245 == 1 then
						local v2247

						v2247, n149 = proto.readVarIntI32(p227, n149)
						v2243.action_type = t1.ActionType.fromNumber(v2247) or v2247
					else
						local v2248

						v2248, n149 = proto.readVarInt(p227, n149)
					end
				elseif v2246 == proto.wireTypes.lengthDelimited then
					if v2245 == 2 then
						local v2249

						v2249, n149 = proto.readBuffer(p227, n149)
						v2243.action_params = t1.OpenSubscriptionPurchasePageAction_Params.decode(v2249)
					else
						local v2250, v2251 = proto.readVarInt(p227, n149)

						n149 = v2251 + v2250
					end
				elseif v2246 == proto.wireTypes.i32 then
					local v2252

					v2252, n149 = proto.readFixed32(p227, n149)
				elseif v2246 == proto.wireTypes.i64 then
					local v2253

					v2253, n149 = proto.readFixed64(p227, n149)
				else
					error("Unsupported wire type: " .. v2246)
				end
			end

			return v2243
		end
		function t299.jsonEncode(p228) -- line: 16173
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
		function t299.jsonDecode(t302: {[any]: any}) -- line: 16195
			-- upvalues: t299 (copy), t1 (copy)
			local v2257 = t299.new()

			if t302.action_type ~= nil then
				v2257.action_type = if typeof(t302.action_type) ~= "number" then t1.ActionType.fromName(t302.action_type) or t302.action_type else t1.ActionType.fromNumber(t302.action_type) or t302.action_type
			end

			if t302.actionType ~= nil then
				v2257.action_type = if typeof(t302.actionType) ~= "number" then t1.ActionType.fromName(t302.actionType) or t302.actionType else t1.ActionType.fromNumber(t302.actionType) or t302.actionType
			end

			if t302.action_params ~= nil then
				v2257.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t302.action_params)
			end

			if t302.actionParams ~= nil then
				v2257.action_params = t1.OpenSubscriptionPurchasePageAction_Params.jsonDecode(t302.actionParams)
			end

			return v2257
		end

		t299.descriptor = {
			name = "OpenSubscriptionPurchasePageAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSubscriptionPurchasePageAction"
		}
		t1.OpenSubscriptionPurchasePageAction = t299
	end

	typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction)

	do
		local t303 = {}

		t303.__index = t303

		function t303.new(t304: {[any]: any}?) -- line: 16237
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
		function t303.encode(p229) -- line: 16257
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n150 = 0

			if p229.subscription_id ~= nil then
				local v2262 = p229.subscription_id:encode()
				local v2263, v2264 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2263, v2264, v2262, buffer.len(v2262))
			end

			if p229.universe_id ~= nil then
				local v2265 = p229.universe_id:encode()
				local v2266, v2267 = proto.writeTag(buf, n150, 2, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2266, v2267, v2265, buffer.len(v2265))
			end

			if p229.creator_name ~= nil then
				local v2268 = p229.creator_name:encode()
				local v2269, v2270 = proto.writeTag(buf, n150, 3, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2269, v2270, v2268, buffer.len(v2268))
			end

			if p229.creator_verified ~= nil then
				local v2271 = p229.creator_verified:encode()
				local v2272, v2273 = proto.writeTag(buf, n150, 4, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2272, v2273, v2271, buffer.len(v2271))
			end

			if p229.name ~= nil then
				local v2274 = p229.name:encode()
				local v2275, v2276 = proto.writeTag(buf, n150, 5, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2275, v2276, v2274, buffer.len(v2274))
			end

			if p229.description ~= nil then
				local v2277 = p229.description:encode()
				local v2278, v2279 = proto.writeTag(buf, n150, 6, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2278, v2279, v2277, buffer.len(v2277))
			end

			if p229.image_asset_id ~= nil then
				local v2280 = p229.image_asset_id:encode()
				local v2281, v2282 = proto.writeTag(buf, n150, 7, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2281, v2282, v2280, buffer.len(v2280))
			end

			if p229.period_type ~= nil then
				local v2283 = p229.period_type:encode()
				local v2284, v2285 = proto.writeTag(buf, n150, 8, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2284, v2285, v2283, buffer.len(v2283))
			end

			if p229.is_subscribed ~= nil then
				local v2286 = p229.is_subscribed:encode()
				local v2287, v2288 = proto.writeTag(buf, n150, 9, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2287, v2288, v2286, buffer.len(v2286))
			end

			if p229.price_display ~= nil then
				local v2289 = p229.price_display:encode()
				local v2290, v2291 = proto.writeTag(buf, n150, 10, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2290, v2291, v2289, buffer.len(v2289))
			end

			if p229.price_in_robux ~= nil then
				local v2292 = p229.price_in_robux:encode()
				local v2293, v2294 = proto.writeTag(buf, n150, 11, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2293, v2294, v2292, buffer.len(v2292))
			end

			if p229.price_tier ~= nil then
				local v2295 = p229.price_tier:encode()
				local v2296, v2297 = proto.writeTag(buf, n150, 12, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2296, v2297, v2295, buffer.len(v2295))
			end

			if p229.thumbnail_string ~= nil then
				local v2298 = p229.thumbnail_string:encode()
				local v2299, v2300 = proto.writeTag(buf, n150, 13, proto.wireTypes.lengthDelimited)

				buf, n150 = proto.writeBuffer(v2299, v2300, v2298, buffer.len(v2298))
			end

			local buf78 = buffer.create(n150)

			buffer.copy(buf78, 0, buf, 0, n150)

			return buf78
		end
		function t303.decode(p230: buffer) -- line: 16346
			-- upvalues: t303 (copy), proto (copy), prop_types (copy)
			local v2303 = t303.new()
			local n151 = 0

			while n151 < buffer.len(p230) do
				local v2305, v2306

				v2305, v2306, n151 = proto.readTag(p230, n151)

				if v2306 == proto.wireTypes.varint then
					local v2307

					v2307, n151 = proto.readVarInt(p230, n151)
				elseif v2306 == proto.wireTypes.lengthDelimited then
					if v2305 == 1 then
						local v2308

						v2308, n151 = proto.readBuffer(p230, n151)
						v2303.subscription_id = prop_types.StringProp.decode(v2308)
					elseif v2305 == 2 then
						local v2309

						v2309, n151 = proto.readBuffer(p230, n151)
						v2303.universe_id = prop_types.StringProp.decode(v2309)
					elseif v2305 == 3 then
						local v2310

						v2310, n151 = proto.readBuffer(p230, n151)
						v2303.creator_name = prop_types.StringProp.decode(v2310)
					elseif v2305 == 4 then
						local v2311

						v2311, n151 = proto.readBuffer(p230, n151)
						v2303.creator_verified = prop_types.BoolProp.decode(v2311)
					elseif v2305 == 5 then
						local v2312

						v2312, n151 = proto.readBuffer(p230, n151)
						v2303.name = prop_types.StringProp.decode(v2312)
					elseif v2305 == 6 then
						local v2313

						v2313, n151 = proto.readBuffer(p230, n151)
						v2303.description = prop_types.StringProp.decode(v2313)
					elseif v2305 == 7 then
						local v2314

						v2314, n151 = proto.readBuffer(p230, n151)
						v2303.image_asset_id = prop_types.Int64Prop.decode(v2314)
					elseif v2305 == 8 then
						local v2315

						v2315, n151 = proto.readBuffer(p230, n151)
						v2303.period_type = prop_types.StringProp.decode(v2315)
					elseif v2305 == 9 then
						local v2316

						v2316, n151 = proto.readBuffer(p230, n151)
						v2303.is_subscribed = prop_types.BoolProp.decode(v2316)
					elseif v2305 == 10 then
						local v2317

						v2317, n151 = proto.readBuffer(p230, n151)
						v2303.price_display = prop_types.StringProp.decode(v2317)
					elseif v2305 == 11 then
						local v2318

						v2318, n151 = proto.readBuffer(p230, n151)
						v2303.price_in_robux = prop_types.Int64Prop.decode(v2318)
					elseif v2305 == 12 then
						local v2319

						v2319, n151 = proto.readBuffer(p230, n151)
						v2303.price_tier = prop_types.Int64Prop.decode(v2319)
					elseif v2305 == 13 then
						local v2320

						v2320, n151 = proto.readBuffer(p230, n151)
						v2303.thumbnail_string = prop_types.StringProp.decode(v2320)
					else
						local v2321, v2322 = proto.readVarInt(p230, n151)

						n151 = v2322 + v2321
					end
				elseif v2306 == proto.wireTypes.i32 then
					local v2323

					v2323, n151 = proto.readFixed32(p230, n151)
				elseif v2306 == proto.wireTypes.i64 then
					local v2324

					v2324, n151 = proto.readFixed64(p230, n151)
				else
					error("Unsupported wire type: " .. v2306)
				end
			end

			return v2303
		end
		function t303.jsonEncode(p231) -- line: 16451
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
		function t303.jsonDecode(t306: {[any]: any}) -- line: 16511
			-- upvalues: t303 (copy), prop_types (copy)
			local v2328 = t303.new()

			if t306.subscription_id ~= nil then
				v2328.subscription_id = prop_types.StringProp.jsonDecode(t306.subscription_id)
			end

			if t306.subscriptionId ~= nil then
				v2328.subscription_id = prop_types.StringProp.jsonDecode(t306.subscriptionId)
			end

			if t306.universe_id ~= nil then
				v2328.universe_id = prop_types.StringProp.jsonDecode(t306.universe_id)
			end

			if t306.universeId ~= nil then
				v2328.universe_id = prop_types.StringProp.jsonDecode(t306.universeId)
			end

			if t306.creator_name ~= nil then
				v2328.creator_name = prop_types.StringProp.jsonDecode(t306.creator_name)
			end

			if t306.creatorName ~= nil then
				v2328.creator_name = prop_types.StringProp.jsonDecode(t306.creatorName)
			end

			if t306.creator_verified ~= nil then
				v2328.creator_verified = prop_types.BoolProp.jsonDecode(t306.creator_verified)
			end

			if t306.creatorVerified ~= nil then
				v2328.creator_verified = prop_types.BoolProp.jsonDecode(t306.creatorVerified)
			end

			if t306.name ~= nil then
				v2328.name = prop_types.StringProp.jsonDecode(t306.name)
			end

			if t306.description ~= nil then
				v2328.description = prop_types.StringProp.jsonDecode(t306.description)
			end

			if t306.image_asset_id ~= nil then
				v2328.image_asset_id = prop_types.Int64Prop.jsonDecode(t306.image_asset_id)
			end

			if t306.imageAssetId ~= nil then
				v2328.image_asset_id = prop_types.Int64Prop.jsonDecode(t306.imageAssetId)
			end

			if t306.period_type ~= nil then
				v2328.period_type = prop_types.StringProp.jsonDecode(t306.period_type)
			end

			if t306.periodType ~= nil then
				v2328.period_type = prop_types.StringProp.jsonDecode(t306.periodType)
			end

			if t306.is_subscribed ~= nil then
				v2328.is_subscribed = prop_types.BoolProp.jsonDecode(t306.is_subscribed)
			end

			if t306.isSubscribed ~= nil then
				v2328.is_subscribed = prop_types.BoolProp.jsonDecode(t306.isSubscribed)
			end

			if t306.price_display ~= nil then
				v2328.price_display = prop_types.StringProp.jsonDecode(t306.price_display)
			end

			if t306.priceDisplay ~= nil then
				v2328.price_display = prop_types.StringProp.jsonDecode(t306.priceDisplay)
			end

			if t306.price_in_robux ~= nil then
				v2328.price_in_robux = prop_types.Int64Prop.jsonDecode(t306.price_in_robux)
			end

			if t306.priceInRobux ~= nil then
				v2328.price_in_robux = prop_types.Int64Prop.jsonDecode(t306.priceInRobux)
			end

			if t306.price_tier ~= nil then
				v2328.price_tier = prop_types.Int64Prop.jsonDecode(t306.price_tier)
			end

			if t306.priceTier ~= nil then
				v2328.price_tier = prop_types.Int64Prop.jsonDecode(t306.priceTier)
			end

			if t306.thumbnail_string ~= nil then
				v2328.thumbnail_string = prop_types.StringProp.jsonDecode(t306.thumbnail_string)
			end

			if t306.thumbnailString ~= nil then
				v2328.thumbnail_string = prop_types.StringProp.jsonDecode(t306.thumbnailString)
			end

			return v2328
		end

		t303.descriptor = {
			name = "OpenSubscriptionPurchasePageAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSubscriptionPurchasePageAction_Params = t303
		typeRegistry.default:register(t1.OpenSubscriptionPurchasePageAction_Params)

		local t307 = {}

		t307.__index = t307

		function t307.new(t308: {[any]: any}?) -- line: 16648
			-- upvalues: t1 (copy), t307 (copy)
			return (setmetatable({
				action_type = if t308 ~= nil and t308.action_type ~= nil then t308.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t308 ~= nil and t308.action_params ~= nil then t308.action_params else nil
			}, t307))
		end
		function t307.encode(p232) -- line: 16657
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n152 = 0

			if p232.action_type ~= nil and (p232.action_type ~= nil and p232.action_type ~= 0 or p232.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2333, v2334 = proto.writeTag(buf, n152, 1, proto.wireTypes.varint)

				buf, n152 = proto.writeVarInt(v2333, v2334, t1.ActionType.toNumber(p232.action_type))
			end

			if p232.action_params ~= nil then
				local v2335 = p232.action_params:encode()
				local v2336, v2337 = proto.writeTag(buf, n152, 2, proto.wireTypes.lengthDelimited)

				buf, n152 = proto.writeBuffer(v2336, v2337, v2335, buffer.len(v2335))
			end

			local buf79 = buffer.create(n152)

			buffer.copy(buf79, 0, buf, 0, n152)

			return buf79
		end
		function t307.decode(p233: buffer) -- line: 16683
			-- upvalues: t307 (copy), proto (copy), t1 (copy)
			local v2340 = t307.new()
			local n153 = 0

			while n153 < buffer.len(p233) do
				local v2342, v2343

				v2342, v2343, n153 = proto.readTag(p233, n153)

				if v2343 == proto.wireTypes.varint then
					if v2342 == 1 then
						local v2344

						v2344, n153 = proto.readVarIntI32(p233, n153)
						v2340.action_type = t1.ActionType.fromNumber(v2344) or v2344
					else
						local v2345

						v2345, n153 = proto.readVarInt(p233, n153)
					end
				elseif v2343 == proto.wireTypes.lengthDelimited then
					if v2342 == 2 then
						local v2346

						v2346, n153 = proto.readBuffer(p233, n153)
						v2340.action_params = t1.RefreshGamePassesAction_Params.decode(v2346)
					else
						local v2347, v2348 = proto.readVarInt(p233, n153)

						n153 = v2348 + v2347
					end
				elseif v2343 == proto.wireTypes.i32 then
					local v2349

					v2349, n153 = proto.readFixed32(p233, n153)
				elseif v2343 == proto.wireTypes.i64 then
					local v2350

					v2350, n153 = proto.readFixed64(p233, n153)
				else
					error("Unsupported wire type: " .. v2343)
				end
			end

			return v2340
		end
		function t307.jsonEncode(p234) -- line: 16731
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
		function t307.jsonDecode(t310: {[any]: any}) -- line: 16753
			-- upvalues: t307 (copy), t1 (copy)
			local v2354 = t307.new()

			if t310.action_type ~= nil then
				v2354.action_type = if typeof(t310.action_type) ~= "number" then t1.ActionType.fromName(t310.action_type) or t310.action_type else t1.ActionType.fromNumber(t310.action_type) or t310.action_type
			end

			if t310.actionType ~= nil then
				v2354.action_type = if typeof(t310.actionType) ~= "number" then t1.ActionType.fromName(t310.actionType) or t310.actionType else t1.ActionType.fromNumber(t310.actionType) or t310.actionType
			end

			if t310.action_params ~= nil then
				v2354.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t310.action_params)
			end

			if t310.actionParams ~= nil then
				v2354.action_params = t1.RefreshGamePassesAction_Params.jsonDecode(t310.actionParams)
			end

			return v2354
		end

		t307.descriptor = {
			name = "RefreshGamePassesAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshGamePassesAction"
		}
		t1.RefreshGamePassesAction = t307
	end

	typeRegistry.default:register(t1.RefreshGamePassesAction)

	do
		local t311 = {}

		t311.__index = t311

		function t311.new(t312: {[any]: any}?) -- line: 16793
			-- upvalues: t311 (copy)
			return (setmetatable({
				universe_id = if t312 ~= nil and t312.universe_id ~= nil then t312.universe_id else nil
			}, t311))
		end
		function t311.encode(p235) -- line: 16801
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n154 = 0

			if p235.universe_id ~= nil then
				local v2359 = p235.universe_id:encode()
				local v2360, v2361 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

				buf, n154 = proto.writeBuffer(v2360, v2361, v2359, buffer.len(v2359))
			end

			local buf80 = buffer.create(n154)

			buffer.copy(buf80, 0, buf, 0, n154)

			return buf80
		end
		function t311.decode(p236: buffer) -- line: 16816
			-- upvalues: t311 (copy), proto (copy), prop_types (copy)
			local v2364 = t311.new()
			local n155 = 0

			while n155 < buffer.len(p236) do
				local v2366, v2367

				v2366, v2367, n155 = proto.readTag(p236, n155)

				if v2367 == proto.wireTypes.varint then
					local v2368

					v2368, n155 = proto.readVarInt(p236, n155)
				elseif v2367 == proto.wireTypes.lengthDelimited then
					if v2366 == 1 then
						local v2369

						v2369, n155 = proto.readBuffer(p236, n155)
						v2364.universe_id = prop_types.StringProp.decode(v2369)
					else
						local v2370, v2371 = proto.readVarInt(p236, n155)

						n155 = v2371 + v2370
					end
				elseif v2367 == proto.wireTypes.i32 then
					local v2372

					v2372, n155 = proto.readFixed32(p236, n155)
				elseif v2367 == proto.wireTypes.i64 then
					local v2373

					v2373, n155 = proto.readFixed64(p236, n155)
				else
					error("Unsupported wire type: " .. v2367)
				end
			end

			return v2364
		end
		function t311.jsonEncode(p237) -- line: 16859
			local t313 = {}

			if p237.universe_id ~= nil then
				t313.universeId = p237.universe_id:jsonEncode()
			end

			return t313
		end
		function t311.jsonDecode(t314: {[any]: any}) -- line: 16869
			-- upvalues: t311 (copy), prop_types (copy)
			local v2377 = t311.new()

			if t314.universe_id ~= nil then
				v2377.universe_id = prop_types.StringProp.jsonDecode(t314.universe_id)
			end

			if t314.universeId ~= nil then
				v2377.universe_id = prop_types.StringProp.jsonDecode(t314.universeId)
			end

			return v2377
		end

		t311.descriptor = {
			name = "RefreshGamePassesAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshGamePassesAction_Params = t311
		typeRegistry.default:register(t1.RefreshGamePassesAction_Params)

		local t315 = {}

		t315.__index = t315

		function t315.new(t316: {[any]: any}?) -- line: 16898
			-- upvalues: t1 (copy), t315 (copy)
			return (setmetatable({
				action_type = if t316 ~= nil and t316.action_type ~= nil then t316.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t316 ~= nil and t316.action_params ~= nil then t316.action_params else nil
			}, t315))
		end
		function t315.encode(p238) -- line: 16907
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n156 = 0

			if p238.action_type ~= nil and (p238.action_type ~= nil and p238.action_type ~= 0 or p238.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2382, v2383 = proto.writeTag(buf, n156, 1, proto.wireTypes.varint)

				buf, n156 = proto.writeVarInt(v2382, v2383, t1.ActionType.toNumber(p238.action_type))
			end

			if p238.action_params ~= nil then
				local v2384 = p238.action_params:encode()
				local v2385, v2386 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

				buf, n156 = proto.writeBuffer(v2385, v2386, v2384, buffer.len(v2384))
			end

			local buf81 = buffer.create(n156)

			buffer.copy(buf81, 0, buf, 0, n156)

			return buf81
		end
		function t315.decode(p239: buffer) -- line: 16933
			-- upvalues: t315 (copy), proto (copy), t1 (copy)
			local v2389 = t315.new()
			local n157 = 0

			while n157 < buffer.len(p239) do
				local v2391, v2392

				v2391, v2392, n157 = proto.readTag(p239, n157)

				if v2392 == proto.wireTypes.varint then
					if v2391 == 1 then
						local v2393

						v2393, n157 = proto.readVarIntI32(p239, n157)
						v2389.action_type = t1.ActionType.fromNumber(v2393) or v2393
					else
						local v2394

						v2394, n157 = proto.readVarInt(p239, n157)
					end
				elseif v2392 == proto.wireTypes.lengthDelimited then
					if v2391 == 2 then
						local v2395

						v2395, n157 = proto.readBuffer(p239, n157)
						v2389.action_params = t1.RefreshPlayabilityAction_Params.decode(v2395)
					else
						local v2396, v2397 = proto.readVarInt(p239, n157)

						n157 = v2397 + v2396
					end
				elseif v2392 == proto.wireTypes.i32 then
					local v2398

					v2398, n157 = proto.readFixed32(p239, n157)
				elseif v2392 == proto.wireTypes.i64 then
					local v2399

					v2399, n157 = proto.readFixed64(p239, n157)
				else
					error("Unsupported wire type: " .. v2392)
				end
			end

			return v2389
		end
		function t315.jsonEncode(p240) -- line: 16981
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
		function t315.jsonDecode(t318: {[any]: any}) -- line: 17003
			-- upvalues: t315 (copy), t1 (copy)
			local v2403 = t315.new()

			if t318.action_type ~= nil then
				v2403.action_type = if typeof(t318.action_type) ~= "number" then t1.ActionType.fromName(t318.action_type) or t318.action_type else t1.ActionType.fromNumber(t318.action_type) or t318.action_type
			end

			if t318.actionType ~= nil then
				v2403.action_type = if typeof(t318.actionType) ~= "number" then t1.ActionType.fromName(t318.actionType) or t318.actionType else t1.ActionType.fromNumber(t318.actionType) or t318.actionType
			end

			if t318.action_params ~= nil then
				v2403.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t318.action_params)
			end

			if t318.actionParams ~= nil then
				v2403.action_params = t1.RefreshPlayabilityAction_Params.jsonDecode(t318.actionParams)
			end

			return v2403
		end

		t315.descriptor = {
			name = "RefreshPlayabilityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshPlayabilityAction"
		}
		t1.RefreshPlayabilityAction = t315
	end

	typeRegistry.default:register(t1.RefreshPlayabilityAction)

	do
		local t319 = {}

		t319.__index = t319

		function t319.new(t320: {[any]: any}?) -- line: 17043
			-- upvalues: t319 (copy)
			return (setmetatable({
				universe_id = if t320 ~= nil and t320.universe_id ~= nil then t320.universe_id else nil
			}, t319))
		end
		function t319.encode(p241) -- line: 17051
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n158 = 0

			if p241.universe_id ~= nil then
				local v2408 = p241.universe_id:encode()
				local v2409, v2410 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

				buf, n158 = proto.writeBuffer(v2409, v2410, v2408, buffer.len(v2408))
			end

			local buf82 = buffer.create(n158)

			buffer.copy(buf82, 0, buf, 0, n158)

			return buf82
		end
		function t319.decode(p242: buffer) -- line: 17066
			-- upvalues: t319 (copy), proto (copy), prop_types (copy)
			local v2413 = t319.new()
			local n159 = 0

			while n159 < buffer.len(p242) do
				local v2415, v2416

				v2415, v2416, n159 = proto.readTag(p242, n159)

				if v2416 == proto.wireTypes.varint then
					local v2417

					v2417, n159 = proto.readVarInt(p242, n159)
				elseif v2416 == proto.wireTypes.lengthDelimited then
					if v2415 == 1 then
						local v2418

						v2418, n159 = proto.readBuffer(p242, n159)
						v2413.universe_id = prop_types.StringProp.decode(v2418)
					else
						local v2419, v2420 = proto.readVarInt(p242, n159)

						n159 = v2420 + v2419
					end
				elseif v2416 == proto.wireTypes.i32 then
					local v2421

					v2421, n159 = proto.readFixed32(p242, n159)
				elseif v2416 == proto.wireTypes.i64 then
					local v2422

					v2422, n159 = proto.readFixed64(p242, n159)
				else
					error("Unsupported wire type: " .. v2416)
				end
			end

			return v2413
		end
		function t319.jsonEncode(p243) -- line: 17109
			local t321 = {}

			if p243.universe_id ~= nil then
				t321.universeId = p243.universe_id:jsonEncode()
			end

			return t321
		end
		function t319.jsonDecode(t322: {[any]: any}) -- line: 17119
			-- upvalues: t319 (copy), prop_types (copy)
			local v2426 = t319.new()

			if t322.universe_id ~= nil then
				v2426.universe_id = prop_types.StringProp.jsonDecode(t322.universe_id)
			end

			if t322.universeId ~= nil then
				v2426.universe_id = prop_types.StringProp.jsonDecode(t322.universeId)
			end

			return v2426
		end

		t319.descriptor = {
			name = "RefreshPlayabilityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshPlayabilityAction_Params = t319
		typeRegistry.default:register(t1.RefreshPlayabilityAction_Params)

		local t323 = {}

		t323.__index = t323

		function t323.new(t324: {[any]: any}?) -- line: 17148
			-- upvalues: t1 (copy), t323 (copy)
			return (setmetatable({
				action_type = if t324 ~= nil and t324.action_type ~= nil then t324.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t324 ~= nil and t324.action_params ~= nil then t324.action_params else nil
			}, t323))
		end
		function t323.encode(p244) -- line: 17159
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n160 = 0

			if p244.action_type ~= nil and (p244.action_type ~= nil and p244.action_type ~= 0 or p244.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2431, v2432 = proto.writeTag(buf, n160, 1, proto.wireTypes.varint)

				buf, n160 = proto.writeVarInt(v2431, v2432, t1.ActionType.toNumber(p244.action_type))
			end

			if p244.action_params ~= nil then
				local v2433 = p244.action_params:encode()
				local v2434, v2435 = proto.writeTag(buf, n160, 2, proto.wireTypes.lengthDelimited)

				buf, n160 = proto.writeBuffer(v2434, v2435, v2433, buffer.len(v2433))
			end

			local buf83 = buffer.create(n160)

			buffer.copy(buf83, 0, buf, 0, n160)

			return buf83
		end
		function t323.decode(p245: buffer) -- line: 17185
			-- upvalues: t323 (copy), proto (copy), t1 (copy)
			local v2438 = t323.new()
			local n161 = 0

			while n161 < buffer.len(p245) do
				local v2440, v2441

				v2440, v2441, n161 = proto.readTag(p245, n161)

				if v2441 == proto.wireTypes.varint then
					if v2440 == 1 then
						local v2442

						v2442, n161 = proto.readVarIntI32(p245, n161)
						v2438.action_type = t1.ActionType.fromNumber(v2442) or v2442
					else
						local v2443

						v2443, n161 = proto.readVarInt(p245, n161)
					end
				elseif v2441 == proto.wireTypes.lengthDelimited then
					if v2440 == 2 then
						local v2444

						v2444, n161 = proto.readBuffer(p245, n161)
						v2438.action_params = t1.RefreshDeveloperProductsAction_Params.decode(v2444)
					else
						local v2445, v2446 = proto.readVarInt(p245, n161)

						n161 = v2446 + v2445
					end
				elseif v2441 == proto.wireTypes.i32 then
					local v2447

					v2447, n161 = proto.readFixed32(p245, n161)
				elseif v2441 == proto.wireTypes.i64 then
					local v2448

					v2448, n161 = proto.readFixed64(p245, n161)
				else
					error("Unsupported wire type: " .. v2441)
				end
			end

			return v2438
		end
		function t323.jsonEncode(p246) -- line: 17233
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
		function t323.jsonDecode(t326: {[any]: any}) -- line: 17255
			-- upvalues: t323 (copy), t1 (copy)
			local v2452 = t323.new()

			if t326.action_type ~= nil then
				v2452.action_type = if typeof(t326.action_type) ~= "number" then t1.ActionType.fromName(t326.action_type) or t326.action_type else t1.ActionType.fromNumber(t326.action_type) or t326.action_type
			end

			if t326.actionType ~= nil then
				v2452.action_type = if typeof(t326.actionType) ~= "number" then t1.ActionType.fromName(t326.actionType) or t326.actionType else t1.ActionType.fromNumber(t326.actionType) or t326.actionType
			end

			if t326.action_params ~= nil then
				v2452.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t326.action_params)
			end

			if t326.actionParams ~= nil then
				v2452.action_params = t1.RefreshDeveloperProductsAction_Params.jsonDecode(t326.actionParams)
			end

			return v2452
		end

		t323.descriptor = {
			name = "RefreshDeveloperProductsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshDeveloperProductsAction"
		}
		t1.RefreshDeveloperProductsAction = t323
	end

	typeRegistry.default:register(t1.RefreshDeveloperProductsAction)

	do
		local t327 = {}

		t327.__index = t327

		function t327.new(t328: {[any]: any}?) -- line: 17295
			-- upvalues: t327 (copy)
			return (setmetatable({
				place_id = if t328 ~= nil and t328.place_id ~= nil then t328.place_id else nil
			}, t327))
		end
		function t327.encode(p247) -- line: 17303
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n162 = 0

			if p247.place_id ~= nil then
				local v2457 = p247.place_id:encode()
				local v2458, v2459 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

				buf, n162 = proto.writeBuffer(v2458, v2459, v2457, buffer.len(v2457))
			end

			local buf84 = buffer.create(n162)

			buffer.copy(buf84, 0, buf, 0, n162)

			return buf84
		end
		function t327.decode(p248: buffer) -- line: 17318
			-- upvalues: t327 (copy), proto (copy), prop_types (copy)
			local v2462 = t327.new()
			local n163 = 0

			while n163 < buffer.len(p248) do
				local v2464, v2465

				v2464, v2465, n163 = proto.readTag(p248, n163)

				if v2465 == proto.wireTypes.varint then
					local v2466

					v2466, n163 = proto.readVarInt(p248, n163)
				elseif v2465 == proto.wireTypes.lengthDelimited then
					if v2464 == 1 then
						local v2467

						v2467, n163 = proto.readBuffer(p248, n163)
						v2462.place_id = prop_types.StringProp.decode(v2467)
					else
						local v2468, v2469 = proto.readVarInt(p248, n163)

						n163 = v2469 + v2468
					end
				elseif v2465 == proto.wireTypes.i32 then
					local v2470

					v2470, n163 = proto.readFixed32(p248, n163)
				elseif v2465 == proto.wireTypes.i64 then
					local v2471

					v2471, n163 = proto.readFixed64(p248, n163)
				else
					error("Unsupported wire type: " .. v2465)
				end
			end

			return v2462
		end
		function t327.jsonEncode(p249) -- line: 17361
			local t329 = {}

			if p249.place_id ~= nil then
				t329.placeId = p249.place_id:jsonEncode()
			end

			return t329
		end
		function t327.jsonDecode(t330: {[any]: any}) -- line: 17371
			-- upvalues: t327 (copy), prop_types (copy)
			local v2475 = t327.new()

			if t330.place_id ~= nil then
				v2475.place_id = prop_types.StringProp.jsonDecode(t330.place_id)
			end

			if t330.placeId ~= nil then
				v2475.place_id = prop_types.StringProp.jsonDecode(t330.placeId)
			end

			return v2475
		end

		t327.descriptor = {
			name = "RefreshDeveloperProductsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshDeveloperProductsAction_Params = t327
		typeRegistry.default:register(t1.RefreshDeveloperProductsAction_Params)

		local t331 = {}

		t331.__index = t331

		function t331.new(t332: {[any]: any}?) -- line: 17401
			-- upvalues: t1 (copy), t331 (copy)
			return (setmetatable({
				action_type = if t332 ~= nil and t332.action_type ~= nil then t332.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t332 ~= nil and t332.action_params ~= nil then t332.action_params else nil
			}, t331))
		end
		function t331.encode(p250) -- line: 17410
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n164 = 0

			if p250.action_type ~= nil and (p250.action_type ~= nil and p250.action_type ~= 0 or p250.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2480, v2481 = proto.writeTag(buf, n164, 1, proto.wireTypes.varint)

				buf, n164 = proto.writeVarInt(v2480, v2481, t1.ActionType.toNumber(p250.action_type))
			end

			if p250.action_params ~= nil then
				local v2482 = p250.action_params:encode()
				local v2483, v2484 = proto.writeTag(buf, n164, 2, proto.wireTypes.lengthDelimited)

				buf, n164 = proto.writeBuffer(v2483, v2484, v2482, buffer.len(v2482))
			end

			local buf85 = buffer.create(n164)

			buffer.copy(buf85, 0, buf, 0, n164)

			return buf85
		end
		function t331.decode(p251: buffer) -- line: 17436
			-- upvalues: t331 (copy), proto (copy), t1 (copy)
			local v2487 = t331.new()
			local n165 = 0

			while n165 < buffer.len(p251) do
				local v2489, v2490

				v2489, v2490, n165 = proto.readTag(p251, n165)

				if v2490 == proto.wireTypes.varint then
					if v2489 == 1 then
						local v2491

						v2491, n165 = proto.readVarIntI32(p251, n165)
						v2487.action_type = t1.ActionType.fromNumber(v2491) or v2491
					else
						local v2492

						v2492, n165 = proto.readVarInt(p251, n165)
					end
				elseif v2490 == proto.wireTypes.lengthDelimited then
					if v2489 == 2 then
						local v2493

						v2493, n165 = proto.readBuffer(p251, n165)
						v2487.action_params = t1.OpenFaeTrialUpsellAction_Params.decode(v2493)
					else
						local v2494, v2495 = proto.readVarInt(p251, n165)

						n165 = v2495 + v2494
					end
				elseif v2490 == proto.wireTypes.i32 then
					local v2496

					v2496, n165 = proto.readFixed32(p251, n165)
				elseif v2490 == proto.wireTypes.i64 then
					local v2497

					v2497, n165 = proto.readFixed64(p251, n165)
				else
					error("Unsupported wire type: " .. v2490)
				end
			end

			return v2487
		end
		function t331.jsonEncode(p252) -- line: 17484
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
		function t331.jsonDecode(t334: {[any]: any}) -- line: 17506
			-- upvalues: t331 (copy), t1 (copy)
			local v2501 = t331.new()

			if t334.action_type ~= nil then
				v2501.action_type = if typeof(t334.action_type) ~= "number" then t1.ActionType.fromName(t334.action_type) or t334.action_type else t1.ActionType.fromNumber(t334.action_type) or t334.action_type
			end

			if t334.actionType ~= nil then
				v2501.action_type = if typeof(t334.actionType) ~= "number" then t1.ActionType.fromName(t334.actionType) or t334.actionType else t1.ActionType.fromNumber(t334.actionType) or t334.actionType
			end

			if t334.action_params ~= nil then
				v2501.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t334.action_params)
			end

			if t334.actionParams ~= nil then
				v2501.action_params = t1.OpenFaeTrialUpsellAction_Params.jsonDecode(t334.actionParams)
			end

			return v2501
		end

		t331.descriptor = {
			name = "OpenFaeTrialUpsellAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenFaeTrialUpsellAction"
		}
		t1.OpenFaeTrialUpsellAction = t331
	end

	typeRegistry.default:register(t1.OpenFaeTrialUpsellAction)

	do
		local t335 = {}

		t335.__index = t335

		function t335.new(t336: {[any]: any}?) -- line: 17546
			-- upvalues: t335 (copy)
			return (setmetatable({
				source = if t336 ~= nil and t336.source ~= nil then t336.source else nil,
				config_key = if t336 ~= nil and t336.config_key ~= nil then t336.config_key else nil,
				surface_key = if t336 ~= nil and t336.surface_key ~= nil then t336.surface_key else nil
			}, t335))
		end
		function t335.encode(p253) -- line: 17556
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n166 = 0

			if p253.source ~= nil then
				local v2506 = p253.source:encode()
				local v2507, v2508 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

				buf, n166 = proto.writeBuffer(v2507, v2508, v2506, buffer.len(v2506))
			end

			if p253.config_key ~= nil then
				local v2509 = p253.config_key:encode()
				local v2510, v2511 = proto.writeTag(buf, n166, 2, proto.wireTypes.lengthDelimited)

				buf, n166 = proto.writeBuffer(v2510, v2511, v2509, buffer.len(v2509))
			end

			if p253.surface_key ~= nil then
				local v2512 = p253.surface_key:encode()
				local v2513, v2514 = proto.writeTag(buf, n166, 3, proto.wireTypes.lengthDelimited)

				buf, n166 = proto.writeBuffer(v2513, v2514, v2512, buffer.len(v2512))
			end

			local buf86 = buffer.create(n166)

			buffer.copy(buf86, 0, buf, 0, n166)

			return buf86
		end
		function t335.decode(p254: buffer) -- line: 17583
			-- upvalues: t335 (copy), proto (copy), prop_types (copy)
			local v2517 = t335.new()
			local n167 = 0

			while n167 < buffer.len(p254) do
				local v2519, v2520

				v2519, v2520, n167 = proto.readTag(p254, n167)

				if v2520 == proto.wireTypes.varint then
					local v2521

					v2521, n167 = proto.readVarInt(p254, n167)
				elseif v2520 == proto.wireTypes.lengthDelimited then
					if v2519 == 1 then
						local v2522

						v2522, n167 = proto.readBuffer(p254, n167)
						v2517.source = prop_types.StringProp.decode(v2522)
					elseif v2519 == 2 then
						local v2523

						v2523, n167 = proto.readBuffer(p254, n167)
						v2517.config_key = prop_types.StringProp.decode(v2523)
					elseif v2519 == 3 then
						local v2524

						v2524, n167 = proto.readBuffer(p254, n167)
						v2517.surface_key = prop_types.StringProp.decode(v2524)
					else
						local v2525, v2526 = proto.readVarInt(p254, n167)

						n167 = v2526 + v2525
					end
				elseif v2520 == proto.wireTypes.i32 then
					local v2527

					v2527, n167 = proto.readFixed32(p254, n167)
				elseif v2520 == proto.wireTypes.i64 then
					local v2528

					v2528, n167 = proto.readFixed64(p254, n167)
				else
					error("Unsupported wire type: " .. v2520)
				end
			end

			return v2517
		end
		function t335.jsonEncode(p255) -- line: 17636
			local t337 = {}

			if p255.source ~= nil then
				t337.source = p255.source:jsonEncode()
			end

			if p255.config_key ~= nil then
				t337.configKey = p255.config_key:jsonEncode()
			end

			if p255.surface_key ~= nil then
				t337.surfaceKey = p255.surface_key:jsonEncode()
			end

			return t337
		end
		function t335.jsonDecode(t338: {[any]: any}) -- line: 17654
			-- upvalues: t335 (copy), prop_types (copy)
			local v2532 = t335.new()

			if t338.source ~= nil then
				v2532.source = prop_types.StringProp.jsonDecode(t338.source)
			end

			if t338.config_key ~= nil then
				v2532.config_key = prop_types.StringProp.jsonDecode(t338.config_key)
			end

			if t338.configKey ~= nil then
				v2532.config_key = prop_types.StringProp.jsonDecode(t338.configKey)
			end

			if t338.surface_key ~= nil then
				v2532.surface_key = prop_types.StringProp.jsonDecode(t338.surface_key)
			end

			if t338.surfaceKey ~= nil then
				v2532.surface_key = prop_types.StringProp.jsonDecode(t338.surfaceKey)
			end

			return v2532
		end

		t335.descriptor = {
			name = "OpenFaeTrialUpsellAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenFaeTrialUpsellAction_Params = t335
		typeRegistry.default:register(t1.OpenFaeTrialUpsellAction_Params)

		local t339 = {}

		t339.__index = t339

		function t339.new(t340: {[any]: any}?) -- line: 17695
			-- upvalues: t1 (copy), t339 (copy)
			return (setmetatable({
				action_type = if t340 ~= nil and t340.action_type ~= nil then t340.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t340 ~= nil and t340.action_params ~= nil then t340.action_params else nil
			}, t339))
		end
		function t339.encode(p256) -- line: 17704
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n168 = 0

			if p256.action_type ~= nil and (p256.action_type ~= nil and p256.action_type ~= 0 or p256.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2537, v2538 = proto.writeTag(buf, n168, 1, proto.wireTypes.varint)

				buf, n168 = proto.writeVarInt(v2537, v2538, t1.ActionType.toNumber(p256.action_type))
			end

			if p256.action_params ~= nil then
				local v2539 = p256.action_params:encode()
				local v2540, v2541 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

				buf, n168 = proto.writeBuffer(v2540, v2541, v2539, buffer.len(v2539))
			end

			local buf87 = buffer.create(n168)

			buffer.copy(buf87, 0, buf, 0, n168)

			return buf87
		end
		function t339.decode(p257: buffer) -- line: 17730
			-- upvalues: t339 (copy), proto (copy), t1 (copy)
			local v2544 = t339.new()
			local n169 = 0

			while n169 < buffer.len(p257) do
				local v2546, v2547

				v2546, v2547, n169 = proto.readTag(p257, n169)

				if v2547 == proto.wireTypes.varint then
					if v2546 == 1 then
						local v2548

						v2548, n169 = proto.readVarIntI32(p257, n169)
						v2544.action_type = t1.ActionType.fromNumber(v2548) or v2548
					else
						local v2549

						v2549, n169 = proto.readVarInt(p257, n169)
					end
				elseif v2547 == proto.wireTypes.lengthDelimited then
					if v2546 == 2 then
						local v2550

						v2550, n169 = proto.readBuffer(p257, n169)
						v2544.action_params = t1.OpenSduiOverlayAction_Params.decode(v2550)
					else
						local v2551, v2552 = proto.readVarInt(p257, n169)

						n169 = v2552 + v2551
					end
				elseif v2547 == proto.wireTypes.i32 then
					local v2553

					v2553, n169 = proto.readFixed32(p257, n169)
				elseif v2547 == proto.wireTypes.i64 then
					local v2554

					v2554, n169 = proto.readFixed64(p257, n169)
				else
					error("Unsupported wire type: " .. v2547)
				end
			end

			return v2544
		end
		function t339.jsonEncode(p258) -- line: 17778
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
		function t339.jsonDecode(t342: {[any]: any}) -- line: 17800
			-- upvalues: t339 (copy), t1 (copy)
			local v2558 = t339.new()

			if t342.action_type ~= nil then
				v2558.action_type = if typeof(t342.action_type) ~= "number" then t1.ActionType.fromName(t342.action_type) or t342.action_type else t1.ActionType.fromNumber(t342.action_type) or t342.action_type
			end

			if t342.actionType ~= nil then
				v2558.action_type = if typeof(t342.actionType) ~= "number" then t1.ActionType.fromName(t342.actionType) or t342.actionType else t1.ActionType.fromNumber(t342.actionType) or t342.actionType
			end

			if t342.action_params ~= nil then
				v2558.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t342.action_params)
			end

			if t342.actionParams ~= nil then
				v2558.action_params = t1.OpenSduiOverlayAction_Params.jsonDecode(t342.actionParams)
			end

			return v2558
		end

		t339.descriptor = {
			name = "OpenSduiOverlayAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSduiOverlayAction"
		}
		t1.OpenSduiOverlayAction = t339
	end

	typeRegistry.default:register(t1.OpenSduiOverlayAction)

	do
		local t343 = {}

		t343.__index = t343

		function t343.new(t344: {[any]: any}?) -- line: 17840
			-- upvalues: t343 (copy)
			return (setmetatable({
				config_key = if t344 ~= nil and t344.config_key ~= nil then t344.config_key else nil,
				identifier = if t344 ~= nil and t344.identifier ~= nil then t344.identifier else nil
			}, t343))
		end
		function t343.encode(p259) -- line: 17849
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n170 = 0

			if p259.config_key ~= nil then
				local v2563 = p259.config_key:encode()
				local v2564, v2565 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2564, v2565, v2563, buffer.len(v2563))
			end

			if p259.identifier ~= nil then
				local v2566 = p259.identifier:encode()
				local v2567, v2568 = proto.writeTag(buf, n170, 2, proto.wireTypes.lengthDelimited)

				buf, n170 = proto.writeBuffer(v2567, v2568, v2566, buffer.len(v2566))
			end

			local buf88 = buffer.create(n170)

			buffer.copy(buf88, 0, buf, 0, n170)

			return buf88
		end
		function t343.decode(p260: buffer) -- line: 17870
			-- upvalues: t343 (copy), proto (copy), prop_types (copy)
			local v2571 = t343.new()
			local n171 = 0

			while n171 < buffer.len(p260) do
				local v2573, v2574

				v2573, v2574, n171 = proto.readTag(p260, n171)

				if v2574 == proto.wireTypes.varint then
					local v2575

					v2575, n171 = proto.readVarInt(p260, n171)
				elseif v2574 == proto.wireTypes.lengthDelimited then
					if v2573 == 1 then
						local v2576

						v2576, n171 = proto.readBuffer(p260, n171)
						v2571.config_key = prop_types.StringProp.decode(v2576)
					elseif v2573 == 2 then
						local v2577

						v2577, n171 = proto.readBuffer(p260, n171)
						v2571.identifier = prop_types.StringProp.decode(v2577)
					else
						local v2578, v2579 = proto.readVarInt(p260, n171)

						n171 = v2579 + v2578
					end
				elseif v2574 == proto.wireTypes.i32 then
					local v2580

					v2580, n171 = proto.readFixed32(p260, n171)
				elseif v2574 == proto.wireTypes.i64 then
					local v2581

					v2581, n171 = proto.readFixed64(p260, n171)
				else
					error("Unsupported wire type: " .. v2574)
				end
			end

			return v2571
		end
		function t343.jsonEncode(p261) -- line: 17918
			local t345 = {}

			if p261.config_key ~= nil then
				t345.configKey = p261.config_key:jsonEncode()
			end

			if p261.identifier ~= nil then
				t345.identifier = p261.identifier:jsonEncode()
			end

			return t345
		end
		function t343.jsonDecode(t346: {[any]: any}) -- line: 17932
			-- upvalues: t343 (copy), prop_types (copy)
			local v2585 = t343.new()

			if t346.config_key ~= nil then
				v2585.config_key = prop_types.StringProp.jsonDecode(t346.config_key)
			end

			if t346.configKey ~= nil then
				v2585.config_key = prop_types.StringProp.jsonDecode(t346.configKey)
			end

			if t346.identifier ~= nil then
				v2585.identifier = prop_types.StringProp.jsonDecode(t346.identifier)
			end

			return v2585
		end

		t343.descriptor = {
			name = "OpenSduiOverlayAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSduiOverlayAction_Params = t343
		typeRegistry.default:register(t1.OpenSduiOverlayAction_Params)

		local t347 = {}

		t347.__index = t347

		function t347.new(t348: {[any]: any}?) -- line: 17964
			-- upvalues: t1 (copy), t347 (copy)
			return (setmetatable({
				action_type = if t348 ~= nil and t348.action_type ~= nil then t348.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t348 ~= nil and t348.action_params ~= nil then t348.action_params else nil
			}, t347))
		end
		function t347.encode(p262) -- line: 17973
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n172 = 0

			if p262.action_type ~= nil and (p262.action_type ~= nil and p262.action_type ~= 0 or p262.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2590, v2591 = proto.writeTag(buf, n172, 1, proto.wireTypes.varint)

				buf, n172 = proto.writeVarInt(v2590, v2591, t1.ActionType.toNumber(p262.action_type))
			end

			if p262.action_params ~= nil then
				local v2592 = p262.action_params:encode()
				local v2593, v2594 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

				buf, n172 = proto.writeBuffer(v2593, v2594, v2592, buffer.len(v2592))
			end

			local buf89 = buffer.create(n172)

			buffer.copy(buf89, 0, buf, 0, n172)

			return buf89
		end
		function t347.decode(p263: buffer) -- line: 17999
			-- upvalues: t347 (copy), proto (copy), t1 (copy)
			local v2597 = t347.new()
			local n173 = 0

			while n173 < buffer.len(p263) do
				local v2599, v2600

				v2599, v2600, n173 = proto.readTag(p263, n173)

				if v2600 == proto.wireTypes.varint then
					if v2599 == 1 then
						local v2601

						v2601, n173 = proto.readVarIntI32(p263, n173)
						v2597.action_type = t1.ActionType.fromNumber(v2601) or v2601
					else
						local v2602

						v2602, n173 = proto.readVarInt(p263, n173)
					end
				elseif v2600 == proto.wireTypes.lengthDelimited then
					if v2599 == 2 then
						local v2603

						v2603, n173 = proto.readBuffer(p263, n173)
						v2597.action_params = t1.ApplyChartsFilterAction_Params.decode(v2603)
					else
						local v2604, v2605 = proto.readVarInt(p263, n173)

						n173 = v2605 + v2604
					end
				elseif v2600 == proto.wireTypes.i32 then
					local v2606

					v2606, n173 = proto.readFixed32(p263, n173)
				elseif v2600 == proto.wireTypes.i64 then
					local v2607

					v2607, n173 = proto.readFixed64(p263, n173)
				else
					error("Unsupported wire type: " .. v2600)
				end
			end

			return v2597
		end
		function t347.jsonEncode(p264) -- line: 18047
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
		function t347.jsonDecode(t350: {[any]: any}) -- line: 18069
			-- upvalues: t347 (copy), t1 (copy)
			local v2611 = t347.new()

			if t350.action_type ~= nil then
				v2611.action_type = if typeof(t350.action_type) ~= "number" then t1.ActionType.fromName(t350.action_type) or t350.action_type else t1.ActionType.fromNumber(t350.action_type) or t350.action_type
			end

			if t350.actionType ~= nil then
				v2611.action_type = if typeof(t350.actionType) ~= "number" then t1.ActionType.fromName(t350.actionType) or t350.actionType else t1.ActionType.fromNumber(t350.actionType) or t350.actionType
			end

			if t350.action_params ~= nil then
				v2611.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t350.action_params)
			end

			if t350.actionParams ~= nil then
				v2611.action_params = t1.ApplyChartsFilterAction_Params.jsonDecode(t350.actionParams)
			end

			return v2611
		end

		t347.descriptor = {
			name = "ApplyChartsFilterAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ApplyChartsFilterAction"
		}
		t1.ApplyChartsFilterAction = t347
	end

	typeRegistry.default:register(t1.ApplyChartsFilterAction)

	do
		local t351 = {}

		t351.__index = t351

		function t351.new(t352: {[any]: any}?) -- line: 18109
			-- upvalues: t351 (copy)
			return (setmetatable({
				session_id = if t352 ~= nil and t352.session_id ~= nil then t352.session_id else nil
			}, t351))
		end
		function t351.encode(p265) -- line: 18117
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n174 = 0

			if p265.session_id ~= nil then
				local v2616 = p265.session_id:encode()
				local v2617, v2618 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

				buf, n174 = proto.writeBuffer(v2617, v2618, v2616, buffer.len(v2616))
			end

			local buf90 = buffer.create(n174)

			buffer.copy(buf90, 0, buf, 0, n174)

			return buf90
		end
		function t351.decode(p266: buffer) -- line: 18132
			-- upvalues: t351 (copy), proto (copy), prop_types (copy)
			local v2621 = t351.new()
			local n175 = 0

			while n175 < buffer.len(p266) do
				local v2623, v2624

				v2623, v2624, n175 = proto.readTag(p266, n175)

				if v2624 == proto.wireTypes.varint then
					local v2625

					v2625, n175 = proto.readVarInt(p266, n175)
				elseif v2624 == proto.wireTypes.lengthDelimited then
					if v2623 == 1 then
						local v2626

						v2626, n175 = proto.readBuffer(p266, n175)
						v2621.session_id = prop_types.StringProp.decode(v2626)
					else
						local v2627, v2628 = proto.readVarInt(p266, n175)

						n175 = v2628 + v2627
					end
				elseif v2624 == proto.wireTypes.i32 then
					local v2629

					v2629, n175 = proto.readFixed32(p266, n175)
				elseif v2624 == proto.wireTypes.i64 then
					local v2630

					v2630, n175 = proto.readFixed64(p266, n175)
				else
					error("Unsupported wire type: " .. v2624)
				end
			end

			return v2621
		end
		function t351.jsonEncode(p267) -- line: 18175
			local t353 = {}

			if p267.session_id ~= nil then
				t353.sessionId = p267.session_id:jsonEncode()
			end

			return t353
		end
		function t351.jsonDecode(t354: {[any]: any}) -- line: 18185
			-- upvalues: t351 (copy), prop_types (copy)
			local v2634 = t351.new()

			if t354.session_id ~= nil then
				v2634.session_id = prop_types.StringProp.jsonDecode(t354.session_id)
			end

			if t354.sessionId ~= nil then
				v2634.session_id = prop_types.StringProp.jsonDecode(t354.sessionId)
			end

			return v2634
		end

		t351.descriptor = {
			name = "ApplyChartsFilterAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ApplyChartsFilterAction_Params = t351
		typeRegistry.default:register(t1.ApplyChartsFilterAction_Params)

		local t355 = {}

		t355.__index = t355

		function t355.new(t356: {[any]: any}?) -- line: 18213
			-- upvalues: t1 (copy), t355 (copy)
			return (setmetatable({
				action_type = if t356 ~= nil and t356.action_type ~= nil then t356.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t356 ~= nil and t356.action_params ~= nil then t356.action_params else nil
			}, t355))
		end
		function t355.encode(p268) -- line: 18224
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n176 = 0

			if p268.action_type ~= nil and (p268.action_type ~= nil and p268.action_type ~= 0 or p268.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2639, v2640 = proto.writeTag(buf, n176, 1, proto.wireTypes.varint)

				buf, n176 = proto.writeVarInt(v2639, v2640, t1.ActionType.toNumber(p268.action_type))
			end

			if p268.action_params ~= nil then
				local v2641 = p268.action_params:encode()
				local v2642, v2643 = proto.writeTag(buf, n176, 2, proto.wireTypes.lengthDelimited)

				buf, n176 = proto.writeBuffer(v2642, v2643, v2641, buffer.len(v2641))
			end

			local buf91 = buffer.create(n176)

			buffer.copy(buf91, 0, buf, 0, n176)

			return buf91
		end
		function t355.decode(p269: buffer) -- line: 18250
			-- upvalues: t355 (copy), proto (copy), t1 (copy)
			local v2646 = t355.new()
			local n177 = 0

			while n177 < buffer.len(p269) do
				local v2648, v2649

				v2648, v2649, n177 = proto.readTag(p269, n177)

				if v2649 == proto.wireTypes.varint then
					if v2648 == 1 then
						local v2650

						v2650, n177 = proto.readVarIntI32(p269, n177)
						v2646.action_type = t1.ActionType.fromNumber(v2650) or v2650
					else
						local v2651

						v2651, n177 = proto.readVarInt(p269, n177)
					end
				elseif v2649 == proto.wireTypes.lengthDelimited then
					if v2648 == 2 then
						local v2652

						v2652, n177 = proto.readBuffer(p269, n177)
						v2646.action_params = t1.RefreshChartsSortDetailAction_Params.decode(v2652)
					else
						local v2653, v2654 = proto.readVarInt(p269, n177)

						n177 = v2654 + v2653
					end
				elseif v2649 == proto.wireTypes.i32 then
					local v2655

					v2655, n177 = proto.readFixed32(p269, n177)
				elseif v2649 == proto.wireTypes.i64 then
					local v2656

					v2656, n177 = proto.readFixed64(p269, n177)
				else
					error("Unsupported wire type: " .. v2649)
				end
			end

			return v2646
		end
		function t355.jsonEncode(p270) -- line: 18298
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
		function t355.jsonDecode(t358: {[any]: any}) -- line: 18320
			-- upvalues: t355 (copy), t1 (copy)
			local v2660 = t355.new()

			if t358.action_type ~= nil then
				v2660.action_type = if typeof(t358.action_type) ~= "number" then t1.ActionType.fromName(t358.action_type) or t358.action_type else t1.ActionType.fromNumber(t358.action_type) or t358.action_type
			end

			if t358.actionType ~= nil then
				v2660.action_type = if typeof(t358.actionType) ~= "number" then t1.ActionType.fromName(t358.actionType) or t358.actionType else t1.ActionType.fromNumber(t358.actionType) or t358.actionType
			end

			if t358.action_params ~= nil then
				v2660.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t358.action_params)
			end

			if t358.actionParams ~= nil then
				v2660.action_params = t1.RefreshChartsSortDetailAction_Params.jsonDecode(t358.actionParams)
			end

			return v2660
		end

		t355.descriptor = {
			name = "RefreshChartsSortDetailAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RefreshChartsSortDetailAction"
		}
		t1.RefreshChartsSortDetailAction = t355
	end

	typeRegistry.default:register(t1.RefreshChartsSortDetailAction)

	do
		local t359 = {}

		t359.__index = t359

		function t359.new(t360: {[any]: any}?) -- line: 18360
			-- upvalues: t359 (copy)
			return (setmetatable({
				config_key = if t360 ~= nil and t360.config_key ~= nil then t360.config_key else nil,
				selected_option = if t360 ~= nil and t360.selected_option ~= nil then t360.selected_option else nil,
				surface_key = if t360 ~= nil and t360.surface_key ~= nil then t360.surface_key else nil,
				sort_id = if t360 ~= nil and t360.sort_id ~= nil then t360.sort_id else nil
			}, t359))
		end
		function t359.encode(p271) -- line: 18371
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n178 = 0

			if p271.config_key ~= nil then
				local v2665 = p271.config_key:encode()
				local v2666, v2667 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2666, v2667, v2665, buffer.len(v2665))
			end

			if p271.selected_option ~= nil then
				local v2668 = p271.selected_option:encode()
				local v2669, v2670 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2669, v2670, v2668, buffer.len(v2668))
			end

			if p271.surface_key ~= nil then
				local v2671 = p271.surface_key:encode()
				local v2672, v2673 = proto.writeTag(buf, n178, 3, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2672, v2673, v2671, buffer.len(v2671))
			end

			if p271.sort_id ~= nil then
				local v2674 = p271.sort_id:encode()
				local v2675, v2676 = proto.writeTag(buf, n178, 4, proto.wireTypes.lengthDelimited)

				buf, n178 = proto.writeBuffer(v2675, v2676, v2674, buffer.len(v2674))
			end

			local buf92 = buffer.create(n178)

			buffer.copy(buf92, 0, buf, 0, n178)

			return buf92
		end
		function t359.decode(p272: buffer) -- line: 18404
			-- upvalues: t359 (copy), proto (copy), prop_types (copy)
			local v2679 = t359.new()
			local n179 = 0

			while n179 < buffer.len(p272) do
				local v2681, v2682

				v2681, v2682, n179 = proto.readTag(p272, n179)

				if v2682 == proto.wireTypes.varint then
					local v2683

					v2683, n179 = proto.readVarInt(p272, n179)
				elseif v2682 == proto.wireTypes.lengthDelimited then
					if v2681 == 1 then
						local v2684

						v2684, n179 = proto.readBuffer(p272, n179)
						v2679.config_key = prop_types.StringProp.decode(v2684)
					elseif v2681 == 2 then
						local v2685

						v2685, n179 = proto.readBuffer(p272, n179)
						v2679.selected_option = prop_types.StringProp.decode(v2685)
					elseif v2681 == 3 then
						local v2686

						v2686, n179 = proto.readBuffer(p272, n179)
						v2679.surface_key = prop_types.StringProp.decode(v2686)
					elseif v2681 == 4 then
						local v2687

						v2687, n179 = proto.readBuffer(p272, n179)
						v2679.sort_id = prop_types.StringProp.decode(v2687)
					else
						local v2688, v2689 = proto.readVarInt(p272, n179)

						n179 = v2689 + v2688
					end
				elseif v2682 == proto.wireTypes.i32 then
					local v2690

					v2690, n179 = proto.readFixed32(p272, n179)
				elseif v2682 == proto.wireTypes.i64 then
					local v2691

					v2691, n179 = proto.readFixed64(p272, n179)
				else
					error("Unsupported wire type: " .. v2682)
				end
			end

			return v2679
		end
		function t359.jsonEncode(p273) -- line: 18462
			local t361 = {}

			if p273.config_key ~= nil then
				t361.configKey = p273.config_key:jsonEncode()
			end

			if p273.selected_option ~= nil then
				t361.selectedOption = p273.selected_option:jsonEncode()
			end

			if p273.surface_key ~= nil then
				t361.surfaceKey = p273.surface_key:jsonEncode()
			end

			if p273.sort_id ~= nil then
				t361.sortId = p273.sort_id:jsonEncode()
			end

			return t361
		end
		function t359.jsonDecode(t362: {[any]: any}) -- line: 18484
			-- upvalues: t359 (copy), prop_types (copy)
			local v2695 = t359.new()

			if t362.config_key ~= nil then
				v2695.config_key = prop_types.StringProp.jsonDecode(t362.config_key)
			end

			if t362.configKey ~= nil then
				v2695.config_key = prop_types.StringProp.jsonDecode(t362.configKey)
			end

			if t362.selected_option ~= nil then
				v2695.selected_option = prop_types.StringProp.jsonDecode(t362.selected_option)
			end

			if t362.selectedOption ~= nil then
				v2695.selected_option = prop_types.StringProp.jsonDecode(t362.selectedOption)
			end

			if t362.surface_key ~= nil then
				v2695.surface_key = prop_types.StringProp.jsonDecode(t362.surface_key)
			end

			if t362.surfaceKey ~= nil then
				v2695.surface_key = prop_types.StringProp.jsonDecode(t362.surfaceKey)
			end

			if t362.sort_id ~= nil then
				v2695.sort_id = prop_types.StringProp.jsonDecode(t362.sort_id)
			end

			if t362.sortId ~= nil then
				v2695.sort_id = prop_types.StringProp.jsonDecode(t362.sortId)
			end

			return v2695
		end

		t359.descriptor = {
			name = "RefreshChartsSortDetailAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RefreshChartsSortDetailAction_Params = t359
		typeRegistry.default:register(t1.RefreshChartsSortDetailAction_Params)

		local t363 = {}

		t363.__index = t363

		function t363.new(t364: {[any]: any}?) -- line: 18541
			-- upvalues: t1 (copy), t363 (copy)
			return (setmetatable({
				action_type = if t364 ~= nil and t364.action_type ~= nil then t364.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t364 ~= nil and t364.action_params ~= nil then t364.action_params else nil
			}, t363))
		end
		function t363.encode(p274) -- line: 18550
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n180 = 0

			if p274.action_type ~= nil and (p274.action_type ~= nil and p274.action_type ~= 0 or p274.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2700, v2701 = proto.writeTag(buf, n180, 1, proto.wireTypes.varint)

				buf, n180 = proto.writeVarInt(v2700, v2701, t1.ActionType.toNumber(p274.action_type))
			end

			if p274.action_params ~= nil then
				local v2702 = p274.action_params:encode()
				local v2703, v2704 = proto.writeTag(buf, n180, 2, proto.wireTypes.lengthDelimited)

				buf, n180 = proto.writeBuffer(v2703, v2704, v2702, buffer.len(v2702))
			end

			local buf93 = buffer.create(n180)

			buffer.copy(buf93, 0, buf, 0, n180)

			return buf93
		end
		function t363.decode(p275: buffer) -- line: 18576
			-- upvalues: t363 (copy), proto (copy), t1 (copy)
			local v2707 = t363.new()
			local n181 = 0

			while n181 < buffer.len(p275) do
				local v2709, v2710

				v2709, v2710, n181 = proto.readTag(p275, n181)

				if v2710 == proto.wireTypes.varint then
					if v2709 == 1 then
						local v2711

						v2711, n181 = proto.readVarIntI32(p275, n181)
						v2707.action_type = t1.ActionType.fromNumber(v2711) or v2711
					else
						local v2712

						v2712, n181 = proto.readVarInt(p275, n181)
					end
				elseif v2710 == proto.wireTypes.lengthDelimited then
					if v2709 == 2 then
						local v2713

						v2713, n181 = proto.readBuffer(p275, n181)
						v2707.action_params = t1.JoinCommunityAction_Params.decode(v2713)
					else
						local v2714, v2715 = proto.readVarInt(p275, n181)

						n181 = v2715 + v2714
					end
				elseif v2710 == proto.wireTypes.i32 then
					local v2716

					v2716, n181 = proto.readFixed32(p275, n181)
				elseif v2710 == proto.wireTypes.i64 then
					local v2717

					v2717, n181 = proto.readFixed64(p275, n181)
				else
					error("Unsupported wire type: " .. v2710)
				end
			end

			return v2707
		end
		function t363.jsonEncode(p276) -- line: 18624
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
		function t363.jsonDecode(t366: {[any]: any}) -- line: 18646
			-- upvalues: t363 (copy), t1 (copy)
			local v2721 = t363.new()

			if t366.action_type ~= nil then
				v2721.action_type = if typeof(t366.action_type) ~= "number" then t1.ActionType.fromName(t366.action_type) or t366.action_type else t1.ActionType.fromNumber(t366.action_type) or t366.action_type
			end

			if t366.actionType ~= nil then
				v2721.action_type = if typeof(t366.actionType) ~= "number" then t1.ActionType.fromName(t366.actionType) or t366.actionType else t1.ActionType.fromNumber(t366.actionType) or t366.actionType
			end

			if t366.action_params ~= nil then
				v2721.action_params = t1.JoinCommunityAction_Params.jsonDecode(t366.action_params)
			end

			if t366.actionParams ~= nil then
				v2721.action_params = t1.JoinCommunityAction_Params.jsonDecode(t366.actionParams)
			end

			return v2721
		end

		t363.descriptor = {
			name = "JoinCommunityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.JoinCommunityAction"
		}
		t1.JoinCommunityAction = t363
	end

	typeRegistry.default:register(t1.JoinCommunityAction)

	do
		local t367 = {}

		t367.__index = t367

		function t367.new(t368: {[any]: any}?) -- line: 18686
			-- upvalues: t367 (copy)
			return (setmetatable({
				community_id = if t368 ~= nil and t368.community_id ~= nil then t368.community_id else nil
			}, t367))
		end
		function t367.encode(p277) -- line: 18694
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n182 = 0

			if p277.community_id ~= nil then
				local v2726 = p277.community_id:encode()
				local v2727, v2728 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

				buf, n182 = proto.writeBuffer(v2727, v2728, v2726, buffer.len(v2726))
			end

			local buf94 = buffer.create(n182)

			buffer.copy(buf94, 0, buf, 0, n182)

			return buf94
		end
		function t367.decode(p278: buffer) -- line: 18709
			-- upvalues: t367 (copy), proto (copy), prop_types (copy)
			local v2731 = t367.new()
			local n183 = 0

			while n183 < buffer.len(p278) do
				local v2733, v2734

				v2733, v2734, n183 = proto.readTag(p278, n183)

				if v2734 == proto.wireTypes.varint then
					local v2735

					v2735, n183 = proto.readVarInt(p278, n183)
				elseif v2734 == proto.wireTypes.lengthDelimited then
					if v2733 == 1 then
						local v2736

						v2736, n183 = proto.readBuffer(p278, n183)
						v2731.community_id = prop_types.StringProp.decode(v2736)
					else
						local v2737, v2738 = proto.readVarInt(p278, n183)

						n183 = v2738 + v2737
					end
				elseif v2734 == proto.wireTypes.i32 then
					local v2739

					v2739, n183 = proto.readFixed32(p278, n183)
				elseif v2734 == proto.wireTypes.i64 then
					local v2740

					v2740, n183 = proto.readFixed64(p278, n183)
				else
					error("Unsupported wire type: " .. v2734)
				end
			end

			return v2731
		end
		function t367.jsonEncode(p279) -- line: 18752
			local t369 = {}

			if p279.community_id ~= nil then
				t369.communityId = p279.community_id:jsonEncode()
			end

			return t369
		end
		function t367.jsonDecode(t370: {[any]: any}) -- line: 18762
			-- upvalues: t367 (copy), prop_types (copy)
			local v2744 = t367.new()

			if t370.community_id ~= nil then
				v2744.community_id = prop_types.StringProp.jsonDecode(t370.community_id)
			end

			if t370.communityId ~= nil then
				v2744.community_id = prop_types.StringProp.jsonDecode(t370.communityId)
			end

			return v2744
		end

		t367.descriptor = {
			name = "JoinCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.JoinCommunityAction_Params = t367
		typeRegistry.default:register(t1.JoinCommunityAction_Params)

		local t371 = {}

		t371.__index = t371

		function t371.new(t372: {[any]: any}?) -- line: 18792
			-- upvalues: t1 (copy), t371 (copy)
			return (setmetatable({
				action_type = if t372 ~= nil and t372.action_type ~= nil then t372.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t372 ~= nil and t372.action_params ~= nil then t372.action_params else nil
			}, t371))
		end
		function t371.encode(p280) -- line: 18801
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n184 = 0

			if p280.action_type ~= nil and (p280.action_type ~= nil and p280.action_type ~= 0 or p280.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2749, v2750 = proto.writeTag(buf, n184, 1, proto.wireTypes.varint)

				buf, n184 = proto.writeVarInt(v2749, v2750, t1.ActionType.toNumber(p280.action_type))
			end

			if p280.action_params ~= nil then
				local v2751 = p280.action_params:encode()
				local v2752, v2753 = proto.writeTag(buf, n184, 2, proto.wireTypes.lengthDelimited)

				buf, n184 = proto.writeBuffer(v2752, v2753, v2751, buffer.len(v2751))
			end

			local buf95 = buffer.create(n184)

			buffer.copy(buf95, 0, buf, 0, n184)

			return buf95
		end
		function t371.decode(p281: buffer) -- line: 18827
			-- upvalues: t371 (copy), proto (copy), t1 (copy)
			local v2756 = t371.new()
			local n185 = 0

			while n185 < buffer.len(p281) do
				local v2758, v2759

				v2758, v2759, n185 = proto.readTag(p281, n185)

				if v2759 == proto.wireTypes.varint then
					if v2758 == 1 then
						local v2760

						v2760, n185 = proto.readVarIntI32(p281, n185)
						v2756.action_type = t1.ActionType.fromNumber(v2760) or v2760
					else
						local v2761

						v2761, n185 = proto.readVarInt(p281, n185)
					end
				elseif v2759 == proto.wireTypes.lengthDelimited then
					if v2758 == 2 then
						local v2762

						v2762, n185 = proto.readBuffer(p281, n185)
						v2756.action_params = t1.ViewCommunityAction_Params.decode(v2762)
					else
						local v2763, v2764 = proto.readVarInt(p281, n185)

						n185 = v2764 + v2763
					end
				elseif v2759 == proto.wireTypes.i32 then
					local v2765

					v2765, n185 = proto.readFixed32(p281, n185)
				elseif v2759 == proto.wireTypes.i64 then
					local v2766

					v2766, n185 = proto.readFixed64(p281, n185)
				else
					error("Unsupported wire type: " .. v2759)
				end
			end

			return v2756
		end
		function t371.jsonEncode(p282) -- line: 18875
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
		function t371.jsonDecode(t374: {[any]: any}) -- line: 18897
			-- upvalues: t371 (copy), t1 (copy)
			local v2770 = t371.new()

			if t374.action_type ~= nil then
				v2770.action_type = if typeof(t374.action_type) ~= "number" then t1.ActionType.fromName(t374.action_type) or t374.action_type else t1.ActionType.fromNumber(t374.action_type) or t374.action_type
			end

			if t374.actionType ~= nil then
				v2770.action_type = if typeof(t374.actionType) ~= "number" then t1.ActionType.fromName(t374.actionType) or t374.actionType else t1.ActionType.fromNumber(t374.actionType) or t374.actionType
			end

			if t374.action_params ~= nil then
				v2770.action_params = t1.ViewCommunityAction_Params.jsonDecode(t374.action_params)
			end

			if t374.actionParams ~= nil then
				v2770.action_params = t1.ViewCommunityAction_Params.jsonDecode(t374.actionParams)
			end

			return v2770
		end

		t371.descriptor = {
			name = "ViewCommunityAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ViewCommunityAction"
		}
		t1.ViewCommunityAction = t371
	end

	typeRegistry.default:register(t1.ViewCommunityAction)

	do
		local t375 = {}

		t375.__index = t375

		function t375.new(t376: {[any]: any}?) -- line: 18937
			-- upvalues: t375 (copy)
			return (setmetatable({
				community_id = if t376 ~= nil and t376.community_id ~= nil then t376.community_id else nil
			}, t375))
		end
		function t375.encode(p283) -- line: 18945
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n186 = 0

			if p283.community_id ~= nil then
				local v2775 = p283.community_id:encode()
				local v2776, v2777 = proto.writeTag(buf, n186, 1, proto.wireTypes.lengthDelimited)

				buf, n186 = proto.writeBuffer(v2776, v2777, v2775, buffer.len(v2775))
			end

			local buf96 = buffer.create(n186)

			buffer.copy(buf96, 0, buf, 0, n186)

			return buf96
		end
		function t375.decode(p284: buffer) -- line: 18960
			-- upvalues: t375 (copy), proto (copy), prop_types (copy)
			local v2780 = t375.new()
			local n187 = 0

			while n187 < buffer.len(p284) do
				local v2782, v2783

				v2782, v2783, n187 = proto.readTag(p284, n187)

				if v2783 == proto.wireTypes.varint then
					local v2784

					v2784, n187 = proto.readVarInt(p284, n187)
				elseif v2783 == proto.wireTypes.lengthDelimited then
					if v2782 == 1 then
						local v2785

						v2785, n187 = proto.readBuffer(p284, n187)
						v2780.community_id = prop_types.StringProp.decode(v2785)
					else
						local v2786, v2787 = proto.readVarInt(p284, n187)

						n187 = v2787 + v2786
					end
				elseif v2783 == proto.wireTypes.i32 then
					local v2788

					v2788, n187 = proto.readFixed32(p284, n187)
				elseif v2783 == proto.wireTypes.i64 then
					local v2789

					v2789, n187 = proto.readFixed64(p284, n187)
				else
					error("Unsupported wire type: " .. v2783)
				end
			end

			return v2780
		end
		function t375.jsonEncode(p285) -- line: 19003
			local t377 = {}

			if p285.community_id ~= nil then
				t377.communityId = p285.community_id:jsonEncode()
			end

			return t377
		end
		function t375.jsonDecode(t378: {[any]: any}) -- line: 19013
			-- upvalues: t375 (copy), prop_types (copy)
			local v2793 = t375.new()

			if t378.community_id ~= nil then
				v2793.community_id = prop_types.StringProp.jsonDecode(t378.community_id)
			end

			if t378.communityId ~= nil then
				v2793.community_id = prop_types.StringProp.jsonDecode(t378.communityId)
			end

			return v2793
		end

		t375.descriptor = {
			name = "ViewCommunityAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ViewCommunityAction_Params = t375
		typeRegistry.default:register(t1.ViewCommunityAction_Params)

		local t379 = {}

		t379.__index = t379

		function t379.new(t380: {[any]: any}?) -- line: 19043
			-- upvalues: t1 (copy), t379 (copy)
			return (setmetatable({
				action_type = if t380 ~= nil and t380.action_type ~= nil then t380.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t380 ~= nil and t380.action_params ~= nil then t380.action_params else nil
			}, t379))
		end
		function t379.encode(p286) -- line: 19052
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n188 = 0

			if p286.action_type ~= nil and (p286.action_type ~= nil and p286.action_type ~= 0 or p286.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2798, v2799 = proto.writeTag(buf, n188, 1, proto.wireTypes.varint)

				buf, n188 = proto.writeVarInt(v2798, v2799, t1.ActionType.toNumber(p286.action_type))
			end

			if p286.action_params ~= nil then
				local v2800 = p286.action_params:encode()
				local v2801, v2802 = proto.writeTag(buf, n188, 2, proto.wireTypes.lengthDelimited)

				buf, n188 = proto.writeBuffer(v2801, v2802, v2800, buffer.len(v2800))
			end

			local buf97 = buffer.create(n188)

			buffer.copy(buf97, 0, buf, 0, n188)

			return buf97
		end
		function t379.decode(p287: buffer) -- line: 19078
			-- upvalues: t379 (copy), proto (copy), t1 (copy)
			local v2805 = t379.new()
			local n189 = 0

			while n189 < buffer.len(p287) do
				local v2807, v2808

				v2807, v2808, n189 = proto.readTag(p287, n189)

				if v2808 == proto.wireTypes.varint then
					if v2807 == 1 then
						local v2809

						v2809, n189 = proto.readVarIntI32(p287, n189)
						v2805.action_type = t1.ActionType.fromNumber(v2809) or v2809
					else
						local v2810

						v2810, n189 = proto.readVarInt(p287, n189)
					end
				elseif v2808 == proto.wireTypes.lengthDelimited then
					if v2807 == 2 then
						local v2811

						v2811, n189 = proto.readBuffer(p287, n189)
						v2805.action_params = t1.AnalyticsEventAction_Params.decode(v2811)
					else
						local v2812, v2813 = proto.readVarInt(p287, n189)

						n189 = v2813 + v2812
					end
				elseif v2808 == proto.wireTypes.i32 then
					local v2814

					v2814, n189 = proto.readFixed32(p287, n189)
				elseif v2808 == proto.wireTypes.i64 then
					local v2815

					v2815, n189 = proto.readFixed64(p287, n189)
				else
					error("Unsupported wire type: " .. v2808)
				end
			end

			return v2805
		end
		function t379.jsonEncode(p288) -- line: 19126
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
		function t379.jsonDecode(t382: {[any]: any}) -- line: 19148
			-- upvalues: t379 (copy), t1 (copy)
			local v2819 = t379.new()

			if t382.action_type ~= nil then
				v2819.action_type = if typeof(t382.action_type) ~= "number" then t1.ActionType.fromName(t382.action_type) or t382.action_type else t1.ActionType.fromNumber(t382.action_type) or t382.action_type
			end

			if t382.actionType ~= nil then
				v2819.action_type = if typeof(t382.actionType) ~= "number" then t1.ActionType.fromName(t382.actionType) or t382.actionType else t1.ActionType.fromNumber(t382.actionType) or t382.actionType
			end

			if t382.action_params ~= nil then
				v2819.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t382.action_params)
			end

			if t382.actionParams ~= nil then
				v2819.action_params = t1.AnalyticsEventAction_Params.jsonDecode(t382.actionParams)
			end

			return v2819
		end

		t379.descriptor = {
			name = "AnalyticsEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsEventAction"
		}
		t1.AnalyticsEventAction = t379
	end

	typeRegistry.default:register(t1.AnalyticsEventAction)

	do
		local t383 = {}

		t383.__index = t383

		function t383.new(t384: {[any]: any}?) -- line: 19188
			-- upvalues: t383 (copy)
			return (setmetatable({
				event_name = if t384 ~= nil and t384.event_name ~= nil then t384.event_name else nil,
				event_fields = if t384 ~= nil and t384.event_fields ~= nil then t384.event_fields else nil
			}, t383))
		end
		function t383.encode(p289) -- line: 19197
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n190 = 0

			if p289.event_name ~= nil then
				local v2824 = p289.event_name:encode()
				local v2825, v2826 = proto.writeTag(buf, n190, 1, proto.wireTypes.lengthDelimited)

				buf, n190 = proto.writeBuffer(v2825, v2826, v2824, buffer.len(v2824))
			end

			if p289.event_fields ~= nil then
				local v2827 = p289.event_fields:encode()
				local v2828, v2829 = proto.writeTag(buf, n190, 2, proto.wireTypes.lengthDelimited)

				buf, n190 = proto.writeBuffer(v2828, v2829, v2827, buffer.len(v2827))
			end

			local buf98 = buffer.create(n190)

			buffer.copy(buf98, 0, buf, 0, n190)

			return buf98
		end
		function t383.decode(p290: buffer) -- line: 19218
			-- upvalues: t383 (copy), proto (copy), prop_types (copy)
			local v2832 = t383.new()
			local n191 = 0

			while n191 < buffer.len(p290) do
				local v2834, v2835

				v2834, v2835, n191 = proto.readTag(p290, n191)

				if v2835 == proto.wireTypes.varint then
					local v2836

					v2836, n191 = proto.readVarInt(p290, n191)
				elseif v2835 == proto.wireTypes.lengthDelimited then
					if v2834 == 1 then
						local v2837

						v2837, n191 = proto.readBuffer(p290, n191)
						v2832.event_name = prop_types.StringProp.decode(v2837)
					elseif v2834 == 2 then
						local v2838

						v2838, n191 = proto.readBuffer(p290, n191)
						v2832.event_fields = prop_types.StructProp.decode(v2838)
					else
						local v2839, v2840 = proto.readVarInt(p290, n191)

						n191 = v2840 + v2839
					end
				elseif v2835 == proto.wireTypes.i32 then
					local v2841

					v2841, n191 = proto.readFixed32(p290, n191)
				elseif v2835 == proto.wireTypes.i64 then
					local v2842

					v2842, n191 = proto.readFixed64(p290, n191)
				else
					error("Unsupported wire type: " .. v2835)
				end
			end

			return v2832
		end
		function t383.jsonEncode(p291) -- line: 19266
			local t385 = {}

			if p291.event_name ~= nil then
				t385.eventName = p291.event_name:jsonEncode()
			end

			if p291.event_fields ~= nil then
				t385.eventFields = p291.event_fields:jsonEncode()
			end

			return t385
		end
		function t383.jsonDecode(t386: {[any]: any}) -- line: 19280
			-- upvalues: t383 (copy), prop_types (copy)
			local v2846 = t383.new()

			if t386.event_name ~= nil then
				v2846.event_name = prop_types.StringProp.jsonDecode(t386.event_name)
			end

			if t386.eventName ~= nil then
				v2846.event_name = prop_types.StringProp.jsonDecode(t386.eventName)
			end

			if t386.event_fields ~= nil then
				v2846.event_fields = prop_types.StructProp.jsonDecode(t386.event_fields)
			end

			if t386.eventFields ~= nil then
				v2846.event_fields = prop_types.StructProp.jsonDecode(t386.eventFields)
			end

			return v2846
		end

		t383.descriptor = {
			name = "AnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AnalyticsEventAction_Params = t383
		typeRegistry.default:register(t1.AnalyticsEventAction_Params)

		local t387 = {}

		t387.__index = t387

		function t387.new(t388: {[any]: any}?) -- line: 19318
			-- upvalues: t1 (copy), t387 (copy)
			return (setmetatable({
				action_type = if t388 ~= nil and t388.action_type ~= nil then t388.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t388 ~= nil and t388.action_params ~= nil then t388.action_params else nil
			}, t387))
		end
		function t387.encode(p292) -- line: 19329
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n192 = 0

			if p292.action_type ~= nil and (p292.action_type ~= nil and p292.action_type ~= 0 or p292.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2851, v2852 = proto.writeTag(buf, n192, 1, proto.wireTypes.varint)

				buf, n192 = proto.writeVarInt(v2851, v2852, t1.ActionType.toNumber(p292.action_type))
			end

			if p292.action_params ~= nil then
				local v2853 = p292.action_params:encode()
				local v2854, v2855 = proto.writeTag(buf, n192, 2, proto.wireTypes.lengthDelimited)

				buf, n192 = proto.writeBuffer(v2854, v2855, v2853, buffer.len(v2853))
			end

			local buf99 = buffer.create(n192)

			buffer.copy(buf99, 0, buf, 0, n192)

			return buf99
		end
		function t387.decode(p293: buffer) -- line: 19355
			-- upvalues: t387 (copy), proto (copy), t1 (copy)
			local v2858 = t387.new()
			local n193 = 0

			while n193 < buffer.len(p293) do
				local v2860, v2861

				v2860, v2861, n193 = proto.readTag(p293, n193)

				if v2861 == proto.wireTypes.varint then
					if v2860 == 1 then
						local v2862

						v2862, n193 = proto.readVarIntI32(p293, n193)
						v2858.action_type = t1.ActionType.fromNumber(v2862) or v2862
					else
						local v2863

						v2863, n193 = proto.readVarInt(p293, n193)
					end
				elseif v2861 == proto.wireTypes.lengthDelimited then
					if v2860 == 2 then
						local v2864

						v2864, n193 = proto.readBuffer(p293, n193)
						v2858.action_params = t1.CustomAnalyticsEventAction_Params.decode(v2864)
					else
						local v2865, v2866 = proto.readVarInt(p293, n193)

						n193 = v2866 + v2865
					end
				elseif v2861 == proto.wireTypes.i32 then
					local v2867

					v2867, n193 = proto.readFixed32(p293, n193)
				elseif v2861 == proto.wireTypes.i64 then
					local v2868

					v2868, n193 = proto.readFixed64(p293, n193)
				else
					error("Unsupported wire type: " .. v2861)
				end
			end

			return v2858
		end
		function t387.jsonEncode(p294) -- line: 19403
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
		function t387.jsonDecode(t390: {[any]: any}) -- line: 19425
			-- upvalues: t387 (copy), t1 (copy)
			local v2872 = t387.new()

			if t390.action_type ~= nil then
				v2872.action_type = if typeof(t390.action_type) ~= "number" then t1.ActionType.fromName(t390.action_type) or t390.action_type else t1.ActionType.fromNumber(t390.action_type) or t390.action_type
			end

			if t390.actionType ~= nil then
				v2872.action_type = if typeof(t390.actionType) ~= "number" then t1.ActionType.fromName(t390.actionType) or t390.actionType else t1.ActionType.fromNumber(t390.actionType) or t390.actionType
			end

			if t390.action_params ~= nil then
				v2872.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t390.action_params)
			end

			if t390.actionParams ~= nil then
				v2872.action_params = t1.CustomAnalyticsEventAction_Params.jsonDecode(t390.actionParams)
			end

			return v2872
		end

		t387.descriptor = {
			name = "CustomAnalyticsEventAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.CustomAnalyticsEventAction"
		}
		t1.CustomAnalyticsEventAction = t387
	end

	typeRegistry.default:register(t1.CustomAnalyticsEventAction)

	do
		local t391 = {}

		t391.__index = t391

		function t391.new(t392: {[any]: any}?) -- line: 19465
			-- upvalues: t391 (copy)
			return (setmetatable({
				event_name = if t392 ~= nil and t392.event_name ~= nil then t392.event_name else nil,
				event_fields = if t392 ~= nil and t392.event_fields ~= nil then t392.event_fields else nil
			}, t391))
		end
		function t391.encode(p295) -- line: 19474
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n194 = 0

			if p295.event_name ~= nil then
				local v2877 = p295.event_name:encode()
				local v2878, v2879 = proto.writeTag(buf, n194, 1, proto.wireTypes.lengthDelimited)

				buf, n194 = proto.writeBuffer(v2878, v2879, v2877, buffer.len(v2877))
			end

			if p295.event_fields ~= nil then
				local v2880 = p295.event_fields:encode()
				local v2881, v2882 = proto.writeTag(buf, n194, 2, proto.wireTypes.lengthDelimited)

				buf, n194 = proto.writeBuffer(v2881, v2882, v2880, buffer.len(v2880))
			end

			local buf100 = buffer.create(n194)

			buffer.copy(buf100, 0, buf, 0, n194)

			return buf100
		end
		function t391.decode(p296: buffer) -- line: 19495
			-- upvalues: t391 (copy), proto (copy), prop_types (copy)
			local v2885 = t391.new()
			local n195 = 0

			while n195 < buffer.len(p296) do
				local v2887, v2888

				v2887, v2888, n195 = proto.readTag(p296, n195)

				if v2888 == proto.wireTypes.varint then
					local v2889

					v2889, n195 = proto.readVarInt(p296, n195)
				elseif v2888 == proto.wireTypes.lengthDelimited then
					if v2887 == 1 then
						local v2890

						v2890, n195 = proto.readBuffer(p296, n195)
						v2885.event_name = prop_types.StringProp.decode(v2890)
					elseif v2887 == 2 then
						local v2891

						v2891, n195 = proto.readBuffer(p296, n195)
						v2885.event_fields = prop_types.StructProp.decode(v2891)
					else
						local v2892, v2893 = proto.readVarInt(p296, n195)

						n195 = v2893 + v2892
					end
				elseif v2888 == proto.wireTypes.i32 then
					local v2894

					v2894, n195 = proto.readFixed32(p296, n195)
				elseif v2888 == proto.wireTypes.i64 then
					local v2895

					v2895, n195 = proto.readFixed64(p296, n195)
				else
					error("Unsupported wire type: " .. v2888)
				end
			end

			return v2885
		end
		function t391.jsonEncode(p297) -- line: 19543
			local t393 = {}

			if p297.event_name ~= nil then
				t393.eventName = p297.event_name:jsonEncode()
			end

			if p297.event_fields ~= nil then
				t393.eventFields = p297.event_fields:jsonEncode()
			end

			return t393
		end
		function t391.jsonDecode(t394: {[any]: any}) -- line: 19557
			-- upvalues: t391 (copy), prop_types (copy)
			local v2899 = t391.new()

			if t394.event_name ~= nil then
				v2899.event_name = prop_types.StringProp.jsonDecode(t394.event_name)
			end

			if t394.eventName ~= nil then
				v2899.event_name = prop_types.StringProp.jsonDecode(t394.eventName)
			end

			if t394.event_fields ~= nil then
				v2899.event_fields = prop_types.StructProp.jsonDecode(t394.event_fields)
			end

			if t394.eventFields ~= nil then
				v2899.event_fields = prop_types.StructProp.jsonDecode(t394.eventFields)
			end

			return v2899
		end

		t391.descriptor = {
			name = "CustomAnalyticsEventAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.CustomAnalyticsEventAction_Params = t391
		typeRegistry.default:register(t1.CustomAnalyticsEventAction_Params)

		local t395 = {}

		t395.__index = t395

		function t395.new(t396: {[any]: any}?) -- line: 19597
			-- upvalues: t1 (copy), t395 (copy)
			return (setmetatable({
				action_type = if t396 ~= nil and t396.action_type ~= nil then t396.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t396 ~= nil and t396.action_params ~= nil then t396.action_params else nil
			}, t395))
		end
		function t395.encode(p298) -- line: 19606
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
		function t395.decode(p299: buffer) -- line: 19632
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
						v2911.action_params = t1.OpenGameInviteAction_Params.decode(v2917)
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
		function t395.jsonEncode(p300) -- line: 19680
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
		function t395.jsonDecode(t398: {[any]: any}) -- line: 19702
			-- upvalues: t395 (copy), t1 (copy)
			local v2925 = t395.new()

			if t398.action_type ~= nil then
				v2925.action_type = if typeof(t398.action_type) ~= "number" then t1.ActionType.fromName(t398.action_type) or t398.action_type else t1.ActionType.fromNumber(t398.action_type) or t398.action_type
			end

			if t398.actionType ~= nil then
				v2925.action_type = if typeof(t398.actionType) ~= "number" then t1.ActionType.fromName(t398.actionType) or t398.actionType else t1.ActionType.fromNumber(t398.actionType) or t398.actionType
			end

			if t398.action_params ~= nil then
				v2925.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t398.action_params)
			end

			if t398.actionParams ~= nil then
				v2925.action_params = t1.OpenGameInviteAction_Params.jsonDecode(t398.actionParams)
			end

			return v2925
		end

		t395.descriptor = {
			name = "OpenGameInviteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameInviteAction"
		}
		t1.OpenGameInviteAction = t395
	end

	typeRegistry.default:register(t1.OpenGameInviteAction)

	do
		local t399 = {}

		t399.__index = t399

		function t399.new(t400: {[any]: any}?) -- line: 19742
			-- upvalues: t399 (copy)
			return (setmetatable({
				universe_id = if t400 ~= nil and t400.universe_id ~= nil then t400.universe_id else nil,
				root_place_id = if t400 ~= nil and t400.root_place_id ~= nil then t400.root_place_id else nil,
				trigger = if t400 ~= nil and t400.trigger ~= nil then t400.trigger else nil,
				button_name = if t400 ~= nil and t400.button_name ~= nil then t400.button_name else nil
			}, t399))
		end
		function t399.encode(p301) -- line: 19753
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n198 = 0

			if p301.universe_id ~= nil then
				local v2930 = p301.universe_id:encode()
				local v2931, v2932 = proto.writeTag(buf, n198, 1, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2931, v2932, v2930, buffer.len(v2930))
			end

			if p301.root_place_id ~= nil then
				local v2933 = p301.root_place_id:encode()
				local v2934, v2935 = proto.writeTag(buf, n198, 2, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2934, v2935, v2933, buffer.len(v2933))
			end

			if p301.trigger ~= nil then
				local v2936 = p301.trigger:encode()
				local v2937, v2938 = proto.writeTag(buf, n198, 3, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2937, v2938, v2936, buffer.len(v2936))
			end

			if p301.button_name ~= nil then
				local v2939 = p301.button_name:encode()
				local v2940, v2941 = proto.writeTag(buf, n198, 4, proto.wireTypes.lengthDelimited)

				buf, n198 = proto.writeBuffer(v2940, v2941, v2939, buffer.len(v2939))
			end

			local buf102 = buffer.create(n198)

			buffer.copy(buf102, 0, buf, 0, n198)

			return buf102
		end
		function t399.decode(p302: buffer) -- line: 19786
			-- upvalues: t399 (copy), proto (copy), prop_types (copy)
			local v2944 = t399.new()
			local n199 = 0

			while n199 < buffer.len(p302) do
				local v2946, v2947

				v2946, v2947, n199 = proto.readTag(p302, n199)

				if v2947 == proto.wireTypes.varint then
					local v2948

					v2948, n199 = proto.readVarInt(p302, n199)
				elseif v2947 == proto.wireTypes.lengthDelimited then
					if v2946 == 1 then
						local v2949

						v2949, n199 = proto.readBuffer(p302, n199)
						v2944.universe_id = prop_types.StringProp.decode(v2949)
					elseif v2946 == 2 then
						local v2950

						v2950, n199 = proto.readBuffer(p302, n199)
						v2944.root_place_id = prop_types.StringProp.decode(v2950)
					elseif v2946 == 3 then
						local v2951

						v2951, n199 = proto.readBuffer(p302, n199)
						v2944.trigger = prop_types.StringProp.decode(v2951)
					elseif v2946 == 4 then
						local v2952

						v2952, n199 = proto.readBuffer(p302, n199)
						v2944.button_name = prop_types.StringProp.decode(v2952)
					else
						local v2953, v2954 = proto.readVarInt(p302, n199)

						n199 = v2954 + v2953
					end
				elseif v2947 == proto.wireTypes.i32 then
					local v2955

					v2955, n199 = proto.readFixed32(p302, n199)
				elseif v2947 == proto.wireTypes.i64 then
					local v2956

					v2956, n199 = proto.readFixed64(p302, n199)
				else
					error("Unsupported wire type: " .. v2947)
				end
			end

			return v2944
		end
		function t399.jsonEncode(p303) -- line: 19844
			local t401 = {}

			if p303.universe_id ~= nil then
				t401.universeId = p303.universe_id:jsonEncode()
			end

			if p303.root_place_id ~= nil then
				t401.rootPlaceId = p303.root_place_id:jsonEncode()
			end

			if p303.trigger ~= nil then
				t401.trigger = p303.trigger:jsonEncode()
			end

			if p303.button_name ~= nil then
				t401.buttonName = p303.button_name:jsonEncode()
			end

			return t401
		end
		function t399.jsonDecode(t402: {[any]: any}) -- line: 19866
			-- upvalues: t399 (copy), prop_types (copy)
			local v2960 = t399.new()

			if t402.universe_id ~= nil then
				v2960.universe_id = prop_types.StringProp.jsonDecode(t402.universe_id)
			end

			if t402.universeId ~= nil then
				v2960.universe_id = prop_types.StringProp.jsonDecode(t402.universeId)
			end

			if t402.root_place_id ~= nil then
				v2960.root_place_id = prop_types.StringProp.jsonDecode(t402.root_place_id)
			end

			if t402.rootPlaceId ~= nil then
				v2960.root_place_id = prop_types.StringProp.jsonDecode(t402.rootPlaceId)
			end

			if t402.trigger ~= nil then
				v2960.trigger = prop_types.StringProp.jsonDecode(t402.trigger)
			end

			if t402.button_name ~= nil then
				v2960.button_name = prop_types.StringProp.jsonDecode(t402.button_name)
			end

			if t402.buttonName ~= nil then
				v2960.button_name = prop_types.StringProp.jsonDecode(t402.buttonName)
			end

			return v2960
		end

		t399.descriptor = {
			name = "OpenGameInviteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameInviteAction_Params = t399
		typeRegistry.default:register(t1.OpenGameInviteAction_Params)

		local t403 = {}

		t403.__index = t403

		function t403.new(t404: {[any]: any}?) -- line: 19918
			-- upvalues: t1 (copy), t403 (copy)
			return (setmetatable({
				action_type = if t404 ~= nil and t404.action_type ~= nil then t404.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t404 ~= nil and t404.action_params ~= nil then t404.action_params else nil
			}, t403))
		end
		function t403.encode(p304) -- line: 19927
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n200 = 0

			if p304.action_type ~= nil and (p304.action_type ~= nil and p304.action_type ~= 0 or p304.action_type ~= t1.ActionType.fromNumber(0)) then
				local v2965, v2966 = proto.writeTag(buf, n200, 1, proto.wireTypes.varint)

				buf, n200 = proto.writeVarInt(v2965, v2966, t1.ActionType.toNumber(p304.action_type))
			end

			if p304.action_params ~= nil then
				local v2967 = p304.action_params:encode()
				local v2968, v2969 = proto.writeTag(buf, n200, 2, proto.wireTypes.lengthDelimited)

				buf, n200 = proto.writeBuffer(v2968, v2969, v2967, buffer.len(v2967))
			end

			local buf103 = buffer.create(n200)

			buffer.copy(buf103, 0, buf, 0, n200)

			return buf103
		end
		function t403.decode(p305: buffer) -- line: 19953
			-- upvalues: t403 (copy), proto (copy), t1 (copy)
			local v2972 = t403.new()
			local n201 = 0

			while n201 < buffer.len(p305) do
				local v2974, v2975

				v2974, v2975, n201 = proto.readTag(p305, n201)

				if v2975 == proto.wireTypes.varint then
					if v2974 == 1 then
						local v2976

						v2976, n201 = proto.readVarIntI32(p305, n201)
						v2972.action_type = t1.ActionType.fromNumber(v2976) or v2976
					else
						local v2977

						v2977, n201 = proto.readVarInt(p305, n201)
					end
				elseif v2975 == proto.wireTypes.lengthDelimited then
					if v2974 == 2 then
						local v2978

						v2978, n201 = proto.readBuffer(p305, n201)
						v2972.action_params = t1.LaunchExperienceAction_Params.decode(v2978)
					else
						local v2979, v2980 = proto.readVarInt(p305, n201)

						n201 = v2980 + v2979
					end
				elseif v2975 == proto.wireTypes.i32 then
					local v2981

					v2981, n201 = proto.readFixed32(p305, n201)
				elseif v2975 == proto.wireTypes.i64 then
					local v2982

					v2982, n201 = proto.readFixed64(p305, n201)
				else
					error("Unsupported wire type: " .. v2975)
				end
			end

			return v2972
		end
		function t403.jsonEncode(p306) -- line: 20001
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
		function t403.jsonDecode(t406: {[any]: any}) -- line: 20023
			-- upvalues: t403 (copy), t1 (copy)
			local v2986 = t403.new()

			if t406.action_type ~= nil then
				v2986.action_type = if typeof(t406.action_type) ~= "number" then t1.ActionType.fromName(t406.action_type) or t406.action_type else t1.ActionType.fromNumber(t406.action_type) or t406.action_type
			end

			if t406.actionType ~= nil then
				v2986.action_type = if typeof(t406.actionType) ~= "number" then t1.ActionType.fromName(t406.actionType) or t406.actionType else t1.ActionType.fromNumber(t406.actionType) or t406.actionType
			end

			if t406.action_params ~= nil then
				v2986.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t406.action_params)
			end

			if t406.actionParams ~= nil then
				v2986.action_params = t1.LaunchExperienceAction_Params.jsonDecode(t406.actionParams)
			end

			return v2986
		end

		t403.descriptor = {
			name = "LaunchExperienceAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.LaunchExperienceAction"
		}
		t1.LaunchExperienceAction = t403
	end

	typeRegistry.default:register(t1.LaunchExperienceAction)

	do
		local t407 = {}

		t407.__index = t407

		function t407.new(t408: {[any]: any}?) -- line: 20063
			-- upvalues: t407 (copy)
			return (setmetatable({
				kind = if t408 ~= nil and t408.kind ~= nil then t408.kind else nil
			}, t407))
		end
		function t407.encode(p307) -- line: 20071
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n202 = 0

			if p307.kind ~= nil then
				if p307.kind.type == "literal" then
					local v2991 = p307.kind.value:encode()
					local v2992, v2993 = proto.writeTag(buf, n202, 1, proto.wireTypes.lengthDelimited)

					buf, n202 = proto.writeBuffer(v2992, v2993, v2991, buffer.len(v2991))
				elseif p307.kind.type == "binding_path" then
					local v2994, v2995 = proto.writeTag(buf, n202, 2, proto.wireTypes.lengthDelimited)

					buf, n202 = proto.writeString(v2994, v2995, p307.kind.value)
				end
			end

			local buf104 = buffer.create(n202)

			buffer.copy(buf104, 0, buf, 0, n202)

			return buf104
		end
		function t407.decode(p308: buffer) -- line: 20093
			-- upvalues: t407 (copy), proto (copy), t1 (copy)
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
						v2998.kind = {
							type = "literal",
							value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.decode(v3003)
						}
					elseif v3000 == 2 then
						local v3004

						v3004, n203 = proto.readBuffer(p308, n203)
						v2998.kind = {
							type = "binding_path",
							value = buffer.tostring(v3004)
						}
					else
						local v3005, v3006 = proto.readVarInt(p308, n203)

						n203 = v3006 + v3005
					end
				elseif v3001 == proto.wireTypes.i32 then
					local v3007

					v3007, n203 = proto.readFixed32(p308, n203)
				elseif v3001 == proto.wireTypes.i64 then
					local v3008

					v3008, n203 = proto.readFixed64(p308, n203)
				else
					error("Unsupported wire type: " .. v3001)
				end
			end

			return v2998
		end
		function t407.jsonEncode(p309) -- line: 20148
			local t409 = {}

			if p309.kind ~= nil then
				if p309.kind.type == "literal" then
					t409.literal = p309.kind.value:jsonEncode()

					return t409
				end

				if p309.kind.type == "binding_path" then
					t409.bindingPath = p309.kind.value
				end
			end

			return t409
		end
		function t407.jsonDecode(t410: {[any]: any}) -- line: 20164
			-- upvalues: t407 (copy), t1 (copy)
			local v3012 = t407.new()

			if t410.literal ~= nil then
				v3012.kind = {
					type = "literal",
					value = t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral.jsonDecode(t410.literal)
				}
			end

			if t410.binding_path ~= nil then
				v3012.kind = {
					type = "binding_path",
					value = t410.binding_path
				}
			end

			if t410.bindingPath ~= nil then
				v3012.kind = {
					type = "binding_path",
					value = t410.bindingPath
				}
			end

			return v3012
		end

		t407.descriptor = {
			name = "LaunchExperienceAction_ExperienceJoinData",
			fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinData"
		}
		t1.LaunchExperienceAction_ExperienceJoinData = t407
		typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData)

		local t411 = {}

		t411.__index = t411

		function t411.new(t412: {[any]: any}?) -- line: 20204
			-- upvalues: t411 (copy)
			return (setmetatable({
				launch_data = if t412 ~= nil and t412.launch_data ~= nil then t412.launch_data else nil,
				event_id = if t412 ~= nil and t412.event_id ~= nil then t412.event_id else nil
			}, t411))
		end
		function t411.encode(p310) -- line: 20216
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n204 = 0

			if p310.launch_data ~= nil then
				local v3017 = p310.launch_data:encode()
				local v3018, v3019 = proto.writeTag(buf, n204, 1, proto.wireTypes.lengthDelimited)

				buf, n204 = proto.writeBuffer(v3018, v3019, v3017, buffer.len(v3017))
			end

			if p310.event_id ~= nil then
				local v3020 = p310.event_id:encode()
				local v3021, v3022 = proto.writeTag(buf, n204, 2, proto.wireTypes.lengthDelimited)

				buf, n204 = proto.writeBuffer(v3021, v3022, v3020, buffer.len(v3020))
			end

			local buf105 = buffer.create(n204)

			buffer.copy(buf105, 0, buf, 0, n204)

			return buf105
		end
		function t411.decode(p311: buffer) -- line: 20239
			-- upvalues: t411 (copy), proto (copy), prop_types (copy)
			local v3025 = t411.new()
			local n205 = 0

			while n205 < buffer.len(p311) do
				local v3027, v3028

				v3027, v3028, n205 = proto.readTag(p311, n205)

				if v3028 == proto.wireTypes.varint then
					local v3029

					v3029, n205 = proto.readVarInt(p311, n205)
				elseif v3028 == proto.wireTypes.lengthDelimited then
					if v3027 == 1 then
						local v3030

						v3030, n205 = proto.readBuffer(p311, n205)
						v3025.launch_data = prop_types.StringProp.decode(v3030)
					elseif v3027 == 2 then
						local v3031

						v3031, n205 = proto.readBuffer(p311, n205)
						v3025.event_id = prop_types.StringProp.decode(v3031)
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
		function t411.jsonEncode(p312) -- line: 20289
			local t413 = {}

			if p312.launch_data ~= nil then
				t413.launchData = p312.launch_data:jsonEncode()
			end

			if p312.event_id ~= nil then
				t413.eventId = p312.event_id:jsonEncode()
			end

			return t413
		end
		function t411.jsonDecode(t414: {[any]: any}) -- line: 20305
			-- upvalues: t411 (copy), prop_types (copy)
			local v3039 = t411.new()

			if t414.launch_data ~= nil then
				v3039.launch_data = prop_types.StringProp.jsonDecode(t414.launch_data)
			end

			if t414.launchData ~= nil then
				v3039.launch_data = prop_types.StringProp.jsonDecode(t414.launchData)
			end

			if t414.event_id ~= nil then
				v3039.event_id = prop_types.StringProp.jsonDecode(t414.event_id)
			end

			if t414.eventId ~= nil then
				v3039.event_id = prop_types.StringProp.jsonDecode(t414.eventId)
			end

			return v3039
		end

		t411.descriptor = {
			name = "LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceJoinDataLiteral"
		}
		t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral = t411
	end

	typeRegistry.default:register(t1.LaunchExperienceAction_ExperienceJoinData_ExperienceJoinDataLiteral)

	do
		local t415 = {}

		t415.__index = t415

		function t415.new(t416: {[any]: any}?) -- line: 20345
			-- upvalues: t415 (copy)
			return (setmetatable({
				place_id = if t416 ~= nil and t416.place_id ~= nil then t416.place_id else nil,
				universe_id = if t416 ~= nil and t416.universe_id ~= nil then t416.universe_id else nil,
				launch_source = if t416 ~= nil and t416.launch_source ~= nil then t416.launch_source else nil,
				experience_join_data = if t416 ~= nil and t416.experience_join_data ~= nil then t416.experience_join_data else nil
			}, t415))
		end
		function t415.encode(p313) -- line: 20358
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n206 = 0

			if p313.place_id ~= nil then
				local v3044 = p313.place_id:encode()
				local v3045, v3046 = proto.writeTag(buf, n206, 1, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3045, v3046, v3044, buffer.len(v3044))
			end

			if p313.universe_id ~= nil then
				local v3047 = p313.universe_id:encode()
				local v3048, v3049 = proto.writeTag(buf, n206, 2, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3048, v3049, v3047, buffer.len(v3047))
			end

			if p313.launch_source ~= nil then
				local v3050 = p313.launch_source:encode()
				local v3051, v3052 = proto.writeTag(buf, n206, 3, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3051, v3052, v3050, buffer.len(v3050))
			end

			if p313.experience_join_data ~= nil then
				local v3053 = p313.experience_join_data:encode()
				local v3054, v3055 = proto.writeTag(buf, n206, 4, proto.wireTypes.lengthDelimited)

				buf, n206 = proto.writeBuffer(v3054, v3055, v3053, buffer.len(v3053))
			end

			local buf106 = buffer.create(n206)

			buffer.copy(buf106, 0, buf, 0, n206)

			return buf106
		end
		function t415.decode(p314: buffer) -- line: 20391
			-- upvalues: t415 (copy), proto (copy), prop_types (copy), t1 (copy)
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
						v3058.place_id = prop_types.StringProp.decode(v3063)
					elseif v3060 == 2 then
						local v3064

						v3064, n207 = proto.readBuffer(p314, n207)
						v3058.universe_id = prop_types.StringProp.decode(v3064)
					elseif v3060 == 3 then
						local v3065

						v3065, n207 = proto.readBuffer(p314, n207)
						v3058.launch_source = prop_types.StringProp.decode(v3065)
					elseif v3060 == 4 then
						local v3066

						v3066, n207 = proto.readBuffer(p314, n207)
						v3058.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.decode(v3066)
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
		function t415.jsonEncode(p315) -- line: 20449
			local t417 = {}

			if p315.place_id ~= nil then
				t417.placeId = p315.place_id:jsonEncode()
			end

			if p315.universe_id ~= nil then
				t417.universeId = p315.universe_id:jsonEncode()
			end

			if p315.launch_source ~= nil then
				t417.launchSource = p315.launch_source:jsonEncode()
			end

			if p315.experience_join_data ~= nil then
				t417.experienceJoinData = p315.experience_join_data:jsonEncode()
			end

			return t417
		end
		function t415.jsonDecode(t418: {[any]: any}) -- line: 20471
			-- upvalues: t415 (copy), prop_types (copy), t1 (copy)
			local v3074 = t415.new()

			if t418.place_id ~= nil then
				v3074.place_id = prop_types.StringProp.jsonDecode(t418.place_id)
			end

			if t418.placeId ~= nil then
				v3074.place_id = prop_types.StringProp.jsonDecode(t418.placeId)
			end

			if t418.universe_id ~= nil then
				v3074.universe_id = prop_types.StringProp.jsonDecode(t418.universe_id)
			end

			if t418.universeId ~= nil then
				v3074.universe_id = prop_types.StringProp.jsonDecode(t418.universeId)
			end

			if t418.launch_source ~= nil then
				v3074.launch_source = prop_types.StringProp.jsonDecode(t418.launch_source)
			end

			if t418.launchSource ~= nil then
				v3074.launch_source = prop_types.StringProp.jsonDecode(t418.launchSource)
			end

			if t418.experience_join_data ~= nil then
				v3074.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t418.experience_join_data)
			end

			if t418.experienceJoinData ~= nil then
				v3074.experience_join_data = t1.LaunchExperienceAction_ExperienceJoinData.jsonDecode(t418.experienceJoinData)
			end

			return v3074
		end

		t415.descriptor = {
			name = "LaunchExperienceAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.LaunchExperienceAction_Params = t415
		typeRegistry.default:register(t1.LaunchExperienceAction_Params)

		local t419 = {}

		t419.__index = t419

		function t419.new(t420: {[any]: any}?) -- line: 20528
			-- upvalues: t1 (copy), t419 (copy)
			return (setmetatable({
				action_type = if t420 ~= nil and t420.action_type ~= nil then t420.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t420 ~= nil and t420.action_params ~= nil then t420.action_params else nil
			}, t419))
		end
		function t419.encode(p316) -- line: 20539
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
		function t419.decode(p317: buffer) -- line: 20565
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
						v3086.action_params = t1.ToggleExperienceFavoriteAction_Params.decode(v3092)
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
		function t419.jsonEncode(p318) -- line: 20613
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
		function t419.jsonDecode(t422: {[any]: any}) -- line: 20635
			-- upvalues: t419 (copy), t1 (copy)
			local v3100 = t419.new()

			if t422.action_type ~= nil then
				v3100.action_type = if typeof(t422.action_type) ~= "number" then t1.ActionType.fromName(t422.action_type) or t422.action_type else t1.ActionType.fromNumber(t422.action_type) or t422.action_type
			end

			if t422.actionType ~= nil then
				v3100.action_type = if typeof(t422.actionType) ~= "number" then t1.ActionType.fromName(t422.actionType) or t422.actionType else t1.ActionType.fromNumber(t422.actionType) or t422.actionType
			end

			if t422.action_params ~= nil then
				v3100.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t422.action_params)
			end

			if t422.actionParams ~= nil then
				v3100.action_params = t1.ToggleExperienceFavoriteAction_Params.jsonDecode(t422.actionParams)
			end

			return v3100
		end

		t419.descriptor = {
			name = "ToggleExperienceFavoriteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFavoriteAction"
		}
		t1.ToggleExperienceFavoriteAction = t419
	end

	typeRegistry.default:register(t1.ToggleExperienceFavoriteAction)

	do
		local t423 = {}

		t423.__index = t423

		function t423.new(t424: {[any]: any}?) -- line: 20675
			-- upvalues: t423 (copy)
			return (setmetatable({
				universe_id = if t424 ~= nil and t424.universe_id ~= nil then t424.universe_id else nil,
				place_id = if t424 ~= nil and t424.place_id ~= nil then t424.place_id else nil,
				ctx = if t424 ~= nil and t424.ctx ~= nil then t424.ctx else nil
			}, t423))
		end
		function t423.encode(p319) -- line: 20685
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n210 = 0

			if p319.universe_id ~= nil then
				local v3105 = p319.universe_id:encode()
				local v3106, v3107 = proto.writeTag(buf, n210, 1, proto.wireTypes.lengthDelimited)

				buf, n210 = proto.writeBuffer(v3106, v3107, v3105, buffer.len(v3105))
			end

			if p319.place_id ~= nil then
				local v3108 = p319.place_id:encode()
				local v3109, v3110 = proto.writeTag(buf, n210, 2, proto.wireTypes.lengthDelimited)

				buf, n210 = proto.writeBuffer(v3109, v3110, v3108, buffer.len(v3108))
			end

			if p319.ctx ~= nil then
				local v3111 = p319.ctx:encode()
				local v3112, v3113 = proto.writeTag(buf, n210, 3, proto.wireTypes.lengthDelimited)

				buf, n210 = proto.writeBuffer(v3112, v3113, v3111, buffer.len(v3111))
			end

			local buf108 = buffer.create(n210)

			buffer.copy(buf108, 0, buf, 0, n210)

			return buf108
		end
		function t423.decode(p320: buffer) -- line: 20712
			-- upvalues: t423 (copy), proto (copy), prop_types (copy)
			local v3116 = t423.new()
			local n211 = 0

			while n211 < buffer.len(p320) do
				local v3118, v3119

				v3118, v3119, n211 = proto.readTag(p320, n211)

				if v3119 == proto.wireTypes.varint then
					local v3120

					v3120, n211 = proto.readVarInt(p320, n211)
				elseif v3119 == proto.wireTypes.lengthDelimited then
					if v3118 == 1 then
						local v3121

						v3121, n211 = proto.readBuffer(p320, n211)
						v3116.universe_id = prop_types.StringProp.decode(v3121)
					elseif v3118 == 2 then
						local v3122

						v3122, n211 = proto.readBuffer(p320, n211)
						v3116.place_id = prop_types.StringProp.decode(v3122)
					elseif v3118 == 3 then
						local v3123

						v3123, n211 = proto.readBuffer(p320, n211)
						v3116.ctx = prop_types.StringProp.decode(v3123)
					else
						local v3124, v3125 = proto.readVarInt(p320, n211)

						n211 = v3125 + v3124
					end
				elseif v3119 == proto.wireTypes.i32 then
					local v3126

					v3126, n211 = proto.readFixed32(p320, n211)
				elseif v3119 == proto.wireTypes.i64 then
					local v3127

					v3127, n211 = proto.readFixed64(p320, n211)
				else
					error("Unsupported wire type: " .. v3119)
				end
			end

			return v3116
		end
		function t423.jsonEncode(p321) -- line: 20765
			local t425 = {}

			if p321.universe_id ~= nil then
				t425.universeId = p321.universe_id:jsonEncode()
			end

			if p321.place_id ~= nil then
				t425.placeId = p321.place_id:jsonEncode()
			end

			if p321.ctx ~= nil then
				t425.ctx = p321.ctx:jsonEncode()
			end

			return t425
		end
		function t423.jsonDecode(t426: {[any]: any}) -- line: 20783
			-- upvalues: t423 (copy), prop_types (copy)
			local v3131 = t423.new()

			if t426.universe_id ~= nil then
				v3131.universe_id = prop_types.StringProp.jsonDecode(t426.universe_id)
			end

			if t426.universeId ~= nil then
				v3131.universe_id = prop_types.StringProp.jsonDecode(t426.universeId)
			end

			if t426.place_id ~= nil then
				v3131.place_id = prop_types.StringProp.jsonDecode(t426.place_id)
			end

			if t426.placeId ~= nil then
				v3131.place_id = prop_types.StringProp.jsonDecode(t426.placeId)
			end

			if t426.ctx ~= nil then
				v3131.ctx = prop_types.StringProp.jsonDecode(t426.ctx)
			end

			return v3131
		end

		t423.descriptor = {
			name = "ToggleExperienceFavoriteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFavoriteAction_Params = t423
		typeRegistry.default:register(t1.ToggleExperienceFavoriteAction_Params)

		local t427 = {}

		t427.__index = t427

		function t427.new(t428: {[any]: any}?) -- line: 20826
			-- upvalues: t1 (copy), t427 (copy)
			return (setmetatable({
				action_type = if t428 ~= nil and t428.action_type ~= nil then t428.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t428 ~= nil and t428.action_params ~= nil then t428.action_params else nil
			}, t427))
		end
		function t427.encode(p322) -- line: 20837
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n212 = 0

			if p322.action_type ~= nil and (p322.action_type ~= nil and p322.action_type ~= 0 or p322.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3136, v3137 = proto.writeTag(buf, n212, 1, proto.wireTypes.varint)

				buf, n212 = proto.writeVarInt(v3136, v3137, t1.ActionType.toNumber(p322.action_type))
			end

			if p322.action_params ~= nil then
				local v3138 = p322.action_params:encode()
				local v3139, v3140 = proto.writeTag(buf, n212, 2, proto.wireTypes.lengthDelimited)

				buf, n212 = proto.writeBuffer(v3139, v3140, v3138, buffer.len(v3138))
			end

			local buf109 = buffer.create(n212)

			buffer.copy(buf109, 0, buf, 0, n212)

			return buf109
		end
		function t427.decode(p323: buffer) -- line: 20863
			-- upvalues: t427 (copy), proto (copy), t1 (copy)
			local v3143 = t427.new()
			local n213 = 0

			while n213 < buffer.len(p323) do
				local v3145, v3146

				v3145, v3146, n213 = proto.readTag(p323, n213)

				if v3146 == proto.wireTypes.varint then
					if v3145 == 1 then
						local v3147

						v3147, n213 = proto.readVarIntI32(p323, n213)
						v3143.action_type = t1.ActionType.fromNumber(v3147) or v3147
					else
						local v3148

						v3148, n213 = proto.readVarInt(p323, n213)
					end
				elseif v3146 == proto.wireTypes.lengthDelimited then
					if v3145 == 2 then
						local v3149

						v3149, n213 = proto.readBuffer(p323, n213)
						v3143.action_params = t1.ToggleExperienceFollowAction_Params.decode(v3149)
					else
						local v3150, v3151 = proto.readVarInt(p323, n213)

						n213 = v3151 + v3150
					end
				elseif v3146 == proto.wireTypes.i32 then
					local v3152

					v3152, n213 = proto.readFixed32(p323, n213)
				elseif v3146 == proto.wireTypes.i64 then
					local v3153

					v3153, n213 = proto.readFixed64(p323, n213)
				else
					error("Unsupported wire type: " .. v3146)
				end
			end

			return v3143
		end
		function t427.jsonEncode(p324) -- line: 20911
			-- upvalues: t1 (copy)
			local t429 = {}

			if p324.action_type ~= nil and (p324.action_type ~= nil and p324.action_type ~= 0 or p324.action_type ~= t1.ActionType.fromNumber(0)) then
				t429.actionType = if typeof(p324.action_type) ~= "number" then t1.ActionType.toNumber(p324.action_type) else p324.action_type
			end

			if p324.action_params ~= nil then
				t429.actionParams = p324.action_params:jsonEncode()
			end

			return t429
		end
		function t427.jsonDecode(t430: {[any]: any}) -- line: 20933
			-- upvalues: t427 (copy), t1 (copy)
			local v3157 = t427.new()

			if t430.action_type ~= nil then
				v3157.action_type = if typeof(t430.action_type) ~= "number" then t1.ActionType.fromName(t430.action_type) or t430.action_type else t1.ActionType.fromNumber(t430.action_type) or t430.action_type
			end

			if t430.actionType ~= nil then
				v3157.action_type = if typeof(t430.actionType) ~= "number" then t1.ActionType.fromName(t430.actionType) or t430.actionType else t1.ActionType.fromNumber(t430.actionType) or t430.actionType
			end

			if t430.action_params ~= nil then
				v3157.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t430.action_params)
			end

			if t430.actionParams ~= nil then
				v3157.action_params = t1.ToggleExperienceFollowAction_Params.jsonDecode(t430.actionParams)
			end

			return v3157
		end

		t427.descriptor = {
			name = "ToggleExperienceFollowAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceFollowAction"
		}
		t1.ToggleExperienceFollowAction = t427
	end

	typeRegistry.default:register(t1.ToggleExperienceFollowAction)

	do
		local t431 = {}

		t431.__index = t431

		function t431.new(t432: {[any]: any}?) -- line: 20973
			-- upvalues: t431 (copy)
			return (setmetatable({
				universe_id = if t432 ~= nil and t432.universe_id ~= nil then t432.universe_id else nil,
				game_name = if t432 ~= nil and t432.game_name ~= nil then t432.game_name else nil,
				ctx = if t432 ~= nil and t432.ctx ~= nil then t432.ctx else nil
			}, t431))
		end
		function t431.encode(p325) -- line: 20983
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n214 = 0

			if p325.universe_id ~= nil then
				local v3162 = p325.universe_id:encode()
				local v3163, v3164 = proto.writeTag(buf, n214, 1, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3163, v3164, v3162, buffer.len(v3162))
			end

			if p325.game_name ~= nil then
				local v3165 = p325.game_name:encode()
				local v3166, v3167 = proto.writeTag(buf, n214, 2, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3166, v3167, v3165, buffer.len(v3165))
			end

			if p325.ctx ~= nil then
				local v3168 = p325.ctx:encode()
				local v3169, v3170 = proto.writeTag(buf, n214, 3, proto.wireTypes.lengthDelimited)

				buf, n214 = proto.writeBuffer(v3169, v3170, v3168, buffer.len(v3168))
			end

			local buf110 = buffer.create(n214)

			buffer.copy(buf110, 0, buf, 0, n214)

			return buf110
		end
		function t431.decode(p326: buffer) -- line: 21010
			-- upvalues: t431 (copy), proto (copy), prop_types (copy)
			local v3173 = t431.new()
			local n215 = 0

			while n215 < buffer.len(p326) do
				local v3175, v3176

				v3175, v3176, n215 = proto.readTag(p326, n215)

				if v3176 == proto.wireTypes.varint then
					local v3177

					v3177, n215 = proto.readVarInt(p326, n215)
				elseif v3176 == proto.wireTypes.lengthDelimited then
					if v3175 == 1 then
						local v3178

						v3178, n215 = proto.readBuffer(p326, n215)
						v3173.universe_id = prop_types.StringProp.decode(v3178)
					elseif v3175 == 2 then
						local v3179

						v3179, n215 = proto.readBuffer(p326, n215)
						v3173.game_name = prop_types.StringProp.decode(v3179)
					elseif v3175 == 3 then
						local v3180

						v3180, n215 = proto.readBuffer(p326, n215)
						v3173.ctx = prop_types.StringProp.decode(v3180)
					else
						local v3181, v3182 = proto.readVarInt(p326, n215)

						n215 = v3182 + v3181
					end
				elseif v3176 == proto.wireTypes.i32 then
					local v3183

					v3183, n215 = proto.readFixed32(p326, n215)
				elseif v3176 == proto.wireTypes.i64 then
					local v3184

					v3184, n215 = proto.readFixed64(p326, n215)
				else
					error("Unsupported wire type: " .. v3176)
				end
			end

			return v3173
		end
		function t431.jsonEncode(p327) -- line: 21063
			local t433 = {}

			if p327.universe_id ~= nil then
				t433.universeId = p327.universe_id:jsonEncode()
			end

			if p327.game_name ~= nil then
				t433.gameName = p327.game_name:jsonEncode()
			end

			if p327.ctx ~= nil then
				t433.ctx = p327.ctx:jsonEncode()
			end

			return t433
		end
		function t431.jsonDecode(t434: {[any]: any}) -- line: 21081
			-- upvalues: t431 (copy), prop_types (copy)
			local v3188 = t431.new()

			if t434.universe_id ~= nil then
				v3188.universe_id = prop_types.StringProp.jsonDecode(t434.universe_id)
			end

			if t434.universeId ~= nil then
				v3188.universe_id = prop_types.StringProp.jsonDecode(t434.universeId)
			end

			if t434.game_name ~= nil then
				v3188.game_name = prop_types.StringProp.jsonDecode(t434.game_name)
			end

			if t434.gameName ~= nil then
				v3188.game_name = prop_types.StringProp.jsonDecode(t434.gameName)
			end

			if t434.ctx ~= nil then
				v3188.ctx = prop_types.StringProp.jsonDecode(t434.ctx)
			end

			return v3188
		end

		t431.descriptor = {
			name = "ToggleExperienceFollowAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceFollowAction_Params = t431
		typeRegistry.default:register(t1.ToggleExperienceFollowAction_Params)

		local t435 = {}

		t435.__index = t435

		function t435.new(t436: {[any]: any}?) -- line: 21124
			-- upvalues: t1 (copy), t435 (copy)
			return (setmetatable({
				action_type = if t436 ~= nil and t436.action_type ~= nil then t436.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t436 ~= nil and t436.action_params ~= nil then t436.action_params else nil
			}, t435))
		end
		function t435.encode(p328) -- line: 21135
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n216 = 0

			if p328.action_type ~= nil and (p328.action_type ~= nil and p328.action_type ~= 0 or p328.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3193, v3194 = proto.writeTag(buf, n216, 1, proto.wireTypes.varint)

				buf, n216 = proto.writeVarInt(v3193, v3194, t1.ActionType.toNumber(p328.action_type))
			end

			if p328.action_params ~= nil then
				local v3195 = p328.action_params:encode()
				local v3196, v3197 = proto.writeTag(buf, n216, 2, proto.wireTypes.lengthDelimited)

				buf, n216 = proto.writeBuffer(v3196, v3197, v3195, buffer.len(v3195))
			end

			local buf111 = buffer.create(n216)

			buffer.copy(buf111, 0, buf, 0, n216)

			return buf111
		end
		function t435.decode(p329: buffer) -- line: 21161
			-- upvalues: t435 (copy), proto (copy), t1 (copy)
			local v3200 = t435.new()
			local n217 = 0

			while n217 < buffer.len(p329) do
				local v3202, v3203

				v3202, v3203, n217 = proto.readTag(p329, n217)

				if v3203 == proto.wireTypes.varint then
					if v3202 == 1 then
						local v3204

						v3204, n217 = proto.readVarIntI32(p329, n217)
						v3200.action_type = t1.ActionType.fromNumber(v3204) or v3204
					else
						local v3205

						v3205, n217 = proto.readVarInt(p329, n217)
					end
				elseif v3203 == proto.wireTypes.lengthDelimited then
					if v3202 == 2 then
						local v3206

						v3206, n217 = proto.readBuffer(p329, n217)
						v3200.action_params = t1.ToggleExperienceVoteAction_Params.decode(v3206)
					else
						local v3207, v3208 = proto.readVarInt(p329, n217)

						n217 = v3208 + v3207
					end
				elseif v3203 == proto.wireTypes.i32 then
					local v3209

					v3209, n217 = proto.readFixed32(p329, n217)
				elseif v3203 == proto.wireTypes.i64 then
					local v3210

					v3210, n217 = proto.readFixed64(p329, n217)
				else
					error("Unsupported wire type: " .. v3203)
				end
			end

			return v3200
		end
		function t435.jsonEncode(p330) -- line: 21209
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
		function t435.jsonDecode(t438: {[any]: any}) -- line: 21231
			-- upvalues: t435 (copy), t1 (copy)
			local v3214 = t435.new()

			if t438.action_type ~= nil then
				v3214.action_type = if typeof(t438.action_type) ~= "number" then t1.ActionType.fromName(t438.action_type) or t438.action_type else t1.ActionType.fromNumber(t438.action_type) or t438.action_type
			end

			if t438.actionType ~= nil then
				v3214.action_type = if typeof(t438.actionType) ~= "number" then t1.ActionType.fromName(t438.actionType) or t438.actionType else t1.ActionType.fromNumber(t438.actionType) or t438.actionType
			end

			if t438.action_params ~= nil then
				v3214.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t438.action_params)
			end

			if t438.actionParams ~= nil then
				v3214.action_params = t1.ToggleExperienceVoteAction_Params.jsonDecode(t438.actionParams)
			end

			return v3214
		end

		t435.descriptor = {
			name = "ToggleExperienceVoteAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ToggleExperienceVoteAction"
		}
		t1.ToggleExperienceVoteAction = t435
	end

	typeRegistry.default:register(t1.ToggleExperienceVoteAction)

	do
		local t439 = {}

		t439.__index = t439

		function t439.new(t440: {[any]: any}?) -- line: 21271
			-- upvalues: t439 (copy)
			return (setmetatable({
				universe_id = if t440 ~= nil and t440.universe_id ~= nil then t440.universe_id else nil,
				vote_direction = if t440 ~= nil and t440.vote_direction ~= nil then t440.vote_direction else nil,
				place_id = if t440 ~= nil and t440.place_id ~= nil then t440.place_id else nil,
				ctx = if t440 ~= nil and t440.ctx ~= nil then t440.ctx else nil
			}, t439))
		end
		function t439.encode(p331) -- line: 21282
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n218 = 0

			if p331.universe_id ~= nil then
				local v3219 = p331.universe_id:encode()
				local v3220, v3221 = proto.writeTag(buf, n218, 1, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3220, v3221, v3219, buffer.len(v3219))
			end

			if p331.vote_direction ~= nil then
				local v3222 = p331.vote_direction:encode()
				local v3223, v3224 = proto.writeTag(buf, n218, 2, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3223, v3224, v3222, buffer.len(v3222))
			end

			if p331.place_id ~= nil then
				local v3225 = p331.place_id:encode()
				local v3226, v3227 = proto.writeTag(buf, n218, 3, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3226, v3227, v3225, buffer.len(v3225))
			end

			if p331.ctx ~= nil then
				local v3228 = p331.ctx:encode()
				local v3229, v3230 = proto.writeTag(buf, n218, 4, proto.wireTypes.lengthDelimited)

				buf, n218 = proto.writeBuffer(v3229, v3230, v3228, buffer.len(v3228))
			end

			local buf112 = buffer.create(n218)

			buffer.copy(buf112, 0, buf, 0, n218)

			return buf112
		end
		function t439.decode(p332: buffer) -- line: 21315
			-- upvalues: t439 (copy), proto (copy), prop_types (copy)
			local v3233 = t439.new()
			local n219 = 0

			while n219 < buffer.len(p332) do
				local v3235, v3236

				v3235, v3236, n219 = proto.readTag(p332, n219)

				if v3236 == proto.wireTypes.varint then
					local v3237

					v3237, n219 = proto.readVarInt(p332, n219)
				elseif v3236 == proto.wireTypes.lengthDelimited then
					if v3235 == 1 then
						local v3238

						v3238, n219 = proto.readBuffer(p332, n219)
						v3233.universe_id = prop_types.StringProp.decode(v3238)
					elseif v3235 == 2 then
						local v3239

						v3239, n219 = proto.readBuffer(p332, n219)
						v3233.vote_direction = prop_types.BoolProp.decode(v3239)
					elseif v3235 == 3 then
						local v3240

						v3240, n219 = proto.readBuffer(p332, n219)
						v3233.place_id = prop_types.StringProp.decode(v3240)
					elseif v3235 == 4 then
						local v3241

						v3241, n219 = proto.readBuffer(p332, n219)
						v3233.ctx = prop_types.StringProp.decode(v3241)
					else
						local v3242, v3243 = proto.readVarInt(p332, n219)

						n219 = v3243 + v3242
					end
				elseif v3236 == proto.wireTypes.i32 then
					local v3244

					v3244, n219 = proto.readFixed32(p332, n219)
				elseif v3236 == proto.wireTypes.i64 then
					local v3245

					v3245, n219 = proto.readFixed64(p332, n219)
				else
					error("Unsupported wire type: " .. v3236)
				end
			end

			return v3233
		end
		function t439.jsonEncode(p333) -- line: 21373
			local t441 = {}

			if p333.universe_id ~= nil then
				t441.universeId = p333.universe_id:jsonEncode()
			end

			if p333.vote_direction ~= nil then
				t441.voteDirection = p333.vote_direction:jsonEncode()
			end

			if p333.place_id ~= nil then
				t441.placeId = p333.place_id:jsonEncode()
			end

			if p333.ctx ~= nil then
				t441.ctx = p333.ctx:jsonEncode()
			end

			return t441
		end
		function t439.jsonDecode(t442: {[any]: any}) -- line: 21395
			-- upvalues: t439 (copy), prop_types (copy)
			local v3249 = t439.new()

			if t442.universe_id ~= nil then
				v3249.universe_id = prop_types.StringProp.jsonDecode(t442.universe_id)
			end

			if t442.universeId ~= nil then
				v3249.universe_id = prop_types.StringProp.jsonDecode(t442.universeId)
			end

			if t442.vote_direction ~= nil then
				v3249.vote_direction = prop_types.BoolProp.jsonDecode(t442.vote_direction)
			end

			if t442.voteDirection ~= nil then
				v3249.vote_direction = prop_types.BoolProp.jsonDecode(t442.voteDirection)
			end

			if t442.place_id ~= nil then
				v3249.place_id = prop_types.StringProp.jsonDecode(t442.place_id)
			end

			if t442.placeId ~= nil then
				v3249.place_id = prop_types.StringProp.jsonDecode(t442.placeId)
			end

			if t442.ctx ~= nil then
				v3249.ctx = prop_types.StringProp.jsonDecode(t442.ctx)
			end

			return v3249
		end

		t439.descriptor = {
			name = "ToggleExperienceVoteAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ToggleExperienceVoteAction_Params = t439
		typeRegistry.default:register(t1.ToggleExperienceVoteAction_Params)

		local t443 = {}

		t443.__index = t443

		function t443.new(t444: {[any]: any}?) -- line: 21448
			-- upvalues: t1 (copy), t443 (copy)
			return (setmetatable({
				action_type = if t444 ~= nil and t444.action_type ~= nil then t444.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t444 ~= nil and t444.action_params ~= nil then t444.action_params else nil
			}, t443))
		end
		function t443.encode(p334) -- line: 21457
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n220 = 0

			if p334.action_type ~= nil and (p334.action_type ~= nil and p334.action_type ~= 0 or p334.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3254, v3255 = proto.writeTag(buf, n220, 1, proto.wireTypes.varint)

				buf, n220 = proto.writeVarInt(v3254, v3255, t1.ActionType.toNumber(p334.action_type))
			end

			if p334.action_params ~= nil then
				local v3256 = p334.action_params:encode()
				local v3257, v3258 = proto.writeTag(buf, n220, 2, proto.wireTypes.lengthDelimited)

				buf, n220 = proto.writeBuffer(v3257, v3258, v3256, buffer.len(v3256))
			end

			local buf113 = buffer.create(n220)

			buffer.copy(buf113, 0, buf, 0, n220)

			return buf113
		end
		function t443.decode(p335: buffer) -- line: 21483
			-- upvalues: t443 (copy), proto (copy), t1 (copy)
			local v3261 = t443.new()
			local n221 = 0

			while n221 < buffer.len(p335) do
				local v3263, v3264

				v3263, v3264, n221 = proto.readTag(p335, n221)

				if v3264 == proto.wireTypes.varint then
					if v3263 == 1 then
						local v3265

						v3265, n221 = proto.readVarIntI32(p335, n221)
						v3261.action_type = t1.ActionType.fromNumber(v3265) or v3265
					else
						local v3266

						v3266, n221 = proto.readVarInt(p335, n221)
					end
				elseif v3264 == proto.wireTypes.lengthDelimited then
					if v3263 == 2 then
						local v3267

						v3267, n221 = proto.readBuffer(p335, n221)
						v3261.action_params = t1.OpenPurchasePromptAction_Params.decode(v3267)
					else
						local v3268, v3269 = proto.readVarInt(p335, n221)

						n221 = v3269 + v3268
					end
				elseif v3264 == proto.wireTypes.i32 then
					local v3270

					v3270, n221 = proto.readFixed32(p335, n221)
				elseif v3264 == proto.wireTypes.i64 then
					local v3271

					v3271, n221 = proto.readFixed64(p335, n221)
				else
					error("Unsupported wire type: " .. v3264)
				end
			end

			return v3261
		end
		function t443.jsonEncode(p336) -- line: 21531
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
		function t443.jsonDecode(t446: {[any]: any}) -- line: 21553
			-- upvalues: t443 (copy), t1 (copy)
			local v3275 = t443.new()

			if t446.action_type ~= nil then
				v3275.action_type = if typeof(t446.action_type) ~= "number" then t1.ActionType.fromName(t446.action_type) or t446.action_type else t1.ActionType.fromNumber(t446.action_type) or t446.action_type
			end

			if t446.actionType ~= nil then
				v3275.action_type = if typeof(t446.actionType) ~= "number" then t1.ActionType.fromName(t446.actionType) or t446.actionType else t1.ActionType.fromNumber(t446.actionType) or t446.actionType
			end

			if t446.action_params ~= nil then
				v3275.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t446.action_params)
			end

			if t446.actionParams ~= nil then
				v3275.action_params = t1.OpenPurchasePromptAction_Params.jsonDecode(t446.actionParams)
			end

			return v3275
		end

		t443.descriptor = {
			name = "OpenPurchasePromptAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenPurchasePromptAction"
		}
		t1.OpenPurchasePromptAction = t443
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction)

	do
		local t447 = {}

		t447.__index = t447

		function t447.new(t448: {[any]: any}?) -- line: 21593
			-- upvalues: t447 (copy)
			return (setmetatable({
				kind = if t448 ~= nil and t448.kind ~= nil then t448.kind else nil
			}, t447))
		end
		function t447.encode(p337) -- line: 21601
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n222 = 0

			if p337.kind ~= nil then
				if p337.kind.type == "literal" then
					local v3280 = p337.kind.value:encode()
					local v3281, v3282 = proto.writeTag(buf, n222, 1, proto.wireTypes.lengthDelimited)

					buf, n222 = proto.writeBuffer(v3281, v3282, v3280, buffer.len(v3280))
				elseif p337.kind.type == "binding_path" then
					local v3283, v3284 = proto.writeTag(buf, n222, 2, proto.wireTypes.lengthDelimited)

					buf, n222 = proto.writeString(v3283, v3284, p337.kind.value)
				end
			end

			local buf114 = buffer.create(n222)

			buffer.copy(buf114, 0, buf, 0, n222)

			return buf114
		end
		function t447.decode(p338: buffer) -- line: 21621
			-- upvalues: t447 (copy), proto (copy), t1 (copy)
			local v3287 = t447.new()
			local n223 = 0

			while n223 < buffer.len(p338) do
				local v3289, v3290

				v3289, v3290, n223 = proto.readTag(p338, n223)

				if v3290 == proto.wireTypes.varint then
					local v3291

					v3291, n223 = proto.readVarInt(p338, n223)
				elseif v3290 == proto.wireTypes.lengthDelimited then
					if v3289 == 1 then
						local v3292

						v3292, n223 = proto.readBuffer(p338, n223)
						v3287.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.decode(v3292)
						}
					elseif v3289 == 2 then
						local v3293

						v3293, n223 = proto.readBuffer(p338, n223)
						v3287.kind = {
							type = "binding_path",
							value = buffer.tostring(v3293)
						}
					else
						local v3294, v3295 = proto.readVarInt(p338, n223)

						n223 = v3295 + v3294
					end
				elseif v3290 == proto.wireTypes.i32 then
					local v3296

					v3296, n223 = proto.readFixed32(p338, n223)
				elseif v3290 == proto.wireTypes.i64 then
					local v3297

					v3297, n223 = proto.readFixed64(p338, n223)
				else
					error("Unsupported wire type: " .. v3290)
				end
			end

			return v3287
		end
		function t447.jsonEncode(p339) -- line: 21672
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
		function t447.jsonDecode(t450: {[any]: any}) -- line: 21686
			-- upvalues: t447 (copy), t1 (copy)
			local v3301 = t447.new()

			if t450.literal ~= nil then
				v3301.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral.jsonDecode(t450.literal)
				}
			end

			if t450.binding_path ~= nil then
				v3301.kind = {
					type = "binding_path",
					value = t450.binding_path
				}
			end

			if t450.bindingPath ~= nil then
				v3301.kind = {
					type = "binding_path",
					value = t450.bindingPath
				}
			end

			return v3301
		end

		t447.descriptor = {
			name = "OpenPurchasePromptAction_ProductPayload",
			fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayload"
		}
		t1.OpenPurchasePromptAction_ProductPayload = t447
		typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload)

		local t451 = {}

		t451.__index = t451

		function t451.new(t452: {[any]: any}?) -- line: 21726
			-- upvalues: t451 (copy)
			return (setmetatable({
				kind = if t452 ~= nil and t452.kind ~= nil then t452.kind else nil,
				id = if t452 ~= nil and t452.id ~= nil then t452.id else nil,
				subscription_id = if t452 ~= nil and t452.subscription_id ~= nil then t452.subscription_id else nil,
				universe_id = if t452 ~= nil and t452.universe_id ~= nil then t452.universe_id else nil,
				equip_if_purchased = if t452 ~= nil and t452.equip_if_purchased ~= nil then t452.equip_if_purchased else nil,
				name = if t452 ~= nil and t452.name ~= nil then t452.name else nil,
				expected_price = if t452 ~= nil and t452.expected_price ~= nil then t452.expected_price else nil,
				icon_image_asset_id = if t452 ~= nil and t452.icon_image_asset_id ~= nil then t452.icon_image_asset_id else nil,
				is_subscription_in_robux = if t452 ~= nil and t452.is_subscription_in_robux ~= nil then t452.is_subscription_in_robux else nil,
				display_price = if t452 ~= nil and t452.display_price ~= nil then t452.display_price else nil
			}, t451))
		end
		function t451.encode(p340) -- line: 21752
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n224 = 0

			if p340.kind ~= nil then
				local v3306 = p340.kind:encode()
				local v3307, v3308 = proto.writeTag(buf, n224, 1, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3307, v3308, v3306, buffer.len(v3306))
			end

			if p340.id ~= nil then
				local v3309 = p340.id:encode()
				local v3310, v3311 = proto.writeTag(buf, n224, 2, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3310, v3311, v3309, buffer.len(v3309))
			end

			if p340.subscription_id ~= nil then
				local v3312 = p340.subscription_id:encode()
				local v3313, v3314 = proto.writeTag(buf, n224, 3, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3313, v3314, v3312, buffer.len(v3312))
			end

			if p340.universe_id ~= nil then
				local v3315 = p340.universe_id:encode()
				local v3316, v3317 = proto.writeTag(buf, n224, 4, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3316, v3317, v3315, buffer.len(v3315))
			end

			if p340.equip_if_purchased ~= nil then
				local v3318 = p340.equip_if_purchased:encode()
				local v3319, v3320 = proto.writeTag(buf, n224, 5, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3319, v3320, v3318, buffer.len(v3318))
			end

			if p340.name ~= nil then
				local v3321 = p340.name:encode()
				local v3322, v3323 = proto.writeTag(buf, n224, 6, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3322, v3323, v3321, buffer.len(v3321))
			end

			if p340.expected_price ~= nil then
				local v3324 = p340.expected_price:encode()
				local v3325, v3326 = proto.writeTag(buf, n224, 7, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3325, v3326, v3324, buffer.len(v3324))
			end

			if p340.icon_image_asset_id ~= nil then
				local v3327 = p340.icon_image_asset_id:encode()
				local v3328, v3329 = proto.writeTag(buf, n224, 8, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3328, v3329, v3327, buffer.len(v3327))
			end

			if p340.is_subscription_in_robux ~= nil then
				local v3330 = p340.is_subscription_in_robux:encode()
				local v3331, v3332 = proto.writeTag(buf, n224, 9, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3331, v3332, v3330, buffer.len(v3330))
			end

			if p340.display_price ~= nil then
				local v3333 = p340.display_price:encode()
				local v3334, v3335 = proto.writeTag(buf, n224, 10, proto.wireTypes.lengthDelimited)

				buf, n224 = proto.writeBuffer(v3334, v3335, v3333, buffer.len(v3333))
			end

			local buf115 = buffer.create(n224)

			buffer.copy(buf115, 0, buf, 0, n224)

			return buf115
		end
		function t451.decode(p341: buffer) -- line: 21823
			-- upvalues: t451 (copy), proto (copy), prop_types (copy)
			local v3338 = t451.new()
			local n225 = 0

			while n225 < buffer.len(p341) do
				local v3340, v3341

				v3340, v3341, n225 = proto.readTag(p341, n225)

				if v3341 == proto.wireTypes.varint then
					local v3342

					v3342, n225 = proto.readVarInt(p341, n225)
				elseif v3341 == proto.wireTypes.lengthDelimited then
					if v3340 == 1 then
						local v3343

						v3343, n225 = proto.readBuffer(p341, n225)
						v3338.kind = prop_types.StringProp.decode(v3343)
					elseif v3340 == 2 then
						local v3344

						v3344, n225 = proto.readBuffer(p341, n225)
						v3338.id = prop_types.StringProp.decode(v3344)
					elseif v3340 == 3 then
						local v3345

						v3345, n225 = proto.readBuffer(p341, n225)
						v3338.subscription_id = prop_types.StringProp.decode(v3345)
					elseif v3340 == 4 then
						local v3346

						v3346, n225 = proto.readBuffer(p341, n225)
						v3338.universe_id = prop_types.StringProp.decode(v3346)
					elseif v3340 == 5 then
						local v3347

						v3347, n225 = proto.readBuffer(p341, n225)
						v3338.equip_if_purchased = prop_types.BoolProp.decode(v3347)
					elseif v3340 == 6 then
						local v3348

						v3348, n225 = proto.readBuffer(p341, n225)
						v3338.name = prop_types.StringProp.decode(v3348)
					elseif v3340 == 7 then
						local v3349

						v3349, n225 = proto.readBuffer(p341, n225)
						v3338.expected_price = prop_types.Int64Prop.decode(v3349)
					elseif v3340 == 8 then
						local v3350

						v3350, n225 = proto.readBuffer(p341, n225)
						v3338.icon_image_asset_id = prop_types.Int64Prop.decode(v3350)
					elseif v3340 == 9 then
						local v3351

						v3351, n225 = proto.readBuffer(p341, n225)
						v3338.is_subscription_in_robux = prop_types.BoolProp.decode(v3351)
					elseif v3340 == 10 then
						local v3352

						v3352, n225 = proto.readBuffer(p341, n225)
						v3338.display_price = prop_types.StringProp.decode(v3352)
					else
						local v3353, v3354 = proto.readVarInt(p341, n225)

						n225 = v3354 + v3353
					end
				elseif v3341 == proto.wireTypes.i32 then
					local v3355

					v3355, n225 = proto.readFixed32(p341, n225)
				elseif v3341 == proto.wireTypes.i64 then
					local v3356

					v3356, n225 = proto.readFixed64(p341, n225)
				else
					error("Unsupported wire type: " .. v3341)
				end
			end

			return v3338
		end
		function t451.jsonEncode(p342) -- line: 21914
			local t453 = {}

			if p342.kind ~= nil then
				t453.kind = p342.kind:jsonEncode()
			end

			if p342.id ~= nil then
				t453.id = p342.id:jsonEncode()
			end

			if p342.subscription_id ~= nil then
				t453.subscriptionId = p342.subscription_id:jsonEncode()
			end

			if p342.universe_id ~= nil then
				t453.universeId = p342.universe_id:jsonEncode()
			end

			if p342.equip_if_purchased ~= nil then
				t453.equipIfPurchased = p342.equip_if_purchased:jsonEncode()
			end

			if p342.name ~= nil then
				t453.name = p342.name:jsonEncode()
			end

			if p342.expected_price ~= nil then
				t453.expectedPrice = p342.expected_price:jsonEncode()
			end

			if p342.icon_image_asset_id ~= nil then
				t453.iconImageAssetId = p342.icon_image_asset_id:jsonEncode()
			end

			if p342.is_subscription_in_robux ~= nil then
				t453.isSubscriptionInRobux = p342.is_subscription_in_robux:jsonEncode()
			end

			if p342.display_price ~= nil then
				t453.displayPrice = p342.display_price:jsonEncode()
			end

			return t453
		end
		function t451.jsonDecode(t454: {[any]: any}) -- line: 21962
			-- upvalues: t451 (copy), prop_types (copy)
			local v3360 = t451.new()

			if t454.kind ~= nil then
				v3360.kind = prop_types.StringProp.jsonDecode(t454.kind)
			end

			if t454.id ~= nil then
				v3360.id = prop_types.StringProp.jsonDecode(t454.id)
			end

			if t454.subscription_id ~= nil then
				v3360.subscription_id = prop_types.StringProp.jsonDecode(t454.subscription_id)
			end

			if t454.subscriptionId ~= nil then
				v3360.subscription_id = prop_types.StringProp.jsonDecode(t454.subscriptionId)
			end

			if t454.universe_id ~= nil then
				v3360.universe_id = prop_types.StringProp.jsonDecode(t454.universe_id)
			end

			if t454.universeId ~= nil then
				v3360.universe_id = prop_types.StringProp.jsonDecode(t454.universeId)
			end

			if t454.equip_if_purchased ~= nil then
				v3360.equip_if_purchased = prop_types.BoolProp.jsonDecode(t454.equip_if_purchased)
			end

			if t454.equipIfPurchased ~= nil then
				v3360.equip_if_purchased = prop_types.BoolProp.jsonDecode(t454.equipIfPurchased)
			end

			if t454.name ~= nil then
				v3360.name = prop_types.StringProp.jsonDecode(t454.name)
			end

			if t454.expected_price ~= nil then
				v3360.expected_price = prop_types.Int64Prop.jsonDecode(t454.expected_price)
			end

			if t454.expectedPrice ~= nil then
				v3360.expected_price = prop_types.Int64Prop.jsonDecode(t454.expectedPrice)
			end

			if t454.icon_image_asset_id ~= nil then
				v3360.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t454.icon_image_asset_id)
			end

			if t454.iconImageAssetId ~= nil then
				v3360.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t454.iconImageAssetId)
			end

			if t454.is_subscription_in_robux ~= nil then
				v3360.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t454.is_subscription_in_robux)
			end

			if t454.isSubscriptionInRobux ~= nil then
				v3360.is_subscription_in_robux = prop_types.BoolProp.jsonDecode(t454.isSubscriptionInRobux)
			end

			if t454.display_price ~= nil then
				v3360.display_price = prop_types.StringProp.jsonDecode(t454.display_price)
			end

			if t454.displayPrice ~= nil then
				v3360.display_price = prop_types.StringProp.jsonDecode(t454.displayPrice)
			end

			return v3360
		end

		t451.descriptor = {
			name = "OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.ProductPayloadLiteral"
		}
		t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral = t451
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_ProductPayload_ProductPayloadLiteral)

	do
		local t455 = {}

		t455.__index = t455

		function t455.new(t456: {[any]: any}?) -- line: 22066
			-- upvalues: t455 (copy)
			return (setmetatable({
				kind = if t456 ~= nil and t456.kind ~= nil then t456.kind else nil
			}, t455))
		end
		function t455.encode(p343) -- line: 22074
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n226 = 0

			if p343.kind ~= nil then
				if p343.kind.type == "literal" then
					local v3365 = p343.kind.value:encode()
					local v3366, v3367 = proto.writeTag(buf, n226, 1, proto.wireTypes.lengthDelimited)

					buf, n226 = proto.writeBuffer(v3366, v3367, v3365, buffer.len(v3365))
				elseif p343.kind.type == "binding_path" then
					local v3368, v3369 = proto.writeTag(buf, n226, 2, proto.wireTypes.lengthDelimited)

					buf, n226 = proto.writeString(v3368, v3369, p343.kind.value)
				end
			end

			local buf116 = buffer.create(n226)

			buffer.copy(buf116, 0, buf, 0, n226)

			return buf116
		end
		function t455.decode(p344: buffer) -- line: 22094
			-- upvalues: t455 (copy), proto (copy), t1 (copy)
			local v3372 = t455.new()
			local n227 = 0

			while n227 < buffer.len(p344) do
				local v3374, v3375

				v3374, v3375, n227 = proto.readTag(p344, n227)

				if v3375 == proto.wireTypes.varint then
					local v3376

					v3376, n227 = proto.readVarInt(p344, n227)
				elseif v3375 == proto.wireTypes.lengthDelimited then
					if v3374 == 1 then
						local v3377

						v3377, n227 = proto.readBuffer(p344, n227)
						v3372.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.decode(v3377)
						}
					elseif v3374 == 2 then
						local v3378

						v3378, n227 = proto.readBuffer(p344, n227)
						v3372.kind = {
							type = "binding_path",
							value = buffer.tostring(v3378)
						}
					else
						local v3379, v3380 = proto.readVarInt(p344, n227)

						n227 = v3380 + v3379
					end
				elseif v3375 == proto.wireTypes.i32 then
					local v3381

					v3381, n227 = proto.readFixed32(p344, n227)
				elseif v3375 == proto.wireTypes.i64 then
					local v3382

					v3382, n227 = proto.readFixed64(p344, n227)
				else
					error("Unsupported wire type: " .. v3375)
				end
			end

			return v3372
		end
		function t455.jsonEncode(p345) -- line: 22145
			local t457 = {}

			if p345.kind ~= nil then
				if p345.kind.type == "literal" then
					t457.literal = p345.kind.value:jsonEncode()

					return t457
				end

				if p345.kind.type == "binding_path" then
					t457.bindingPath = p345.kind.value
				end
			end

			return t457
		end
		function t455.jsonDecode(t458: {[any]: any}) -- line: 22159
			-- upvalues: t455 (copy), t1 (copy)
			local v3386 = t455.new()

			if t458.literal ~= nil then
				v3386.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral.jsonDecode(t458.literal)
				}
			end

			if t458.binding_path ~= nil then
				v3386.kind = {
					type = "binding_path",
					value = t458.binding_path
				}
			end

			if t458.bindingPath ~= nil then
				v3386.kind = {
					type = "binding_path",
					value = t458.bindingPath
				}
			end

			return v3386
		end

		t455.descriptor = {
			name = "OpenPurchasePromptAction_DisplayInfo",
			fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfo"
		}
		t1.OpenPurchasePromptAction_DisplayInfo = t455
		typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo)

		local t459 = {}

		t459.__index = t459

		function t459.new(t460: {[any]: any}?) -- line: 22197
			-- upvalues: t459 (copy)
			return (setmetatable({
				product_name = if t460 ~= nil and t460.product_name ~= nil then t460.product_name else nil,
				description = if t460 ~= nil and t460.description ~= nil then t460.description else nil,
				image_url = if t460 ~= nil and t460.image_url ~= nil then t460.image_url else nil,
				price_in_robux = if t460 ~= nil and t460.price_in_robux ~= nil then t460.price_in_robux else nil,
				display_price = if t460 ~= nil and t460.display_price ~= nil then t460.display_price else nil,
				icon_image_asset_id = if t460 ~= nil and t460.icon_image_asset_id ~= nil then t460.icon_image_asset_id else nil,
				product_id = if t460 ~= nil and t460.product_id ~= nil then t460.product_id else nil,
				target_id = if t460 ~= nil and t460.target_id ~= nil then t460.target_id else nil,
				is_for_sale = if t460 ~= nil and t460.is_for_sale ~= nil then t460.is_for_sale else nil,
				product_type = if t460 ~= nil and t460.product_type ~= nil then t460.product_type else nil,
				base_price_in_robux = if t460 ~= nil and t460.base_price_in_robux ~= nil then t460.base_price_in_robux else nil,
				price_discount_details = if t460 ~= nil and t460.price_discount_details ~= nil then t460.price_discount_details else nil
			}, t459))
		end
		function t459.encode(p346) -- line: 22225
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n228 = 0

			if p346.product_name ~= nil then
				local v3391 = p346.product_name:encode()
				local v3392, v3393 = proto.writeTag(buf, n228, 1, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3392, v3393, v3391, buffer.len(v3391))
			end

			if p346.description ~= nil then
				local v3394 = p346.description:encode()
				local v3395, v3396 = proto.writeTag(buf, n228, 2, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3395, v3396, v3394, buffer.len(v3394))
			end

			if p346.image_url ~= nil then
				local v3397 = p346.image_url:encode()
				local v3398, v3399 = proto.writeTag(buf, n228, 3, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3398, v3399, v3397, buffer.len(v3397))
			end

			if p346.price_in_robux ~= nil then
				local v3400 = p346.price_in_robux:encode()
				local v3401, v3402 = proto.writeTag(buf, n228, 4, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3401, v3402, v3400, buffer.len(v3400))
			end

			if p346.display_price ~= nil then
				local v3403 = p346.display_price:encode()
				local v3404, v3405 = proto.writeTag(buf, n228, 5, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3404, v3405, v3403, buffer.len(v3403))
			end

			if p346.icon_image_asset_id ~= nil then
				local v3406 = p346.icon_image_asset_id:encode()
				local v3407, v3408 = proto.writeTag(buf, n228, 6, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3407, v3408, v3406, buffer.len(v3406))
			end

			if p346.product_id ~= nil then
				local v3409 = p346.product_id:encode()
				local v3410, v3411 = proto.writeTag(buf, n228, 7, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3410, v3411, v3409, buffer.len(v3409))
			end

			if p346.target_id ~= nil then
				local v3412 = p346.target_id:encode()
				local v3413, v3414 = proto.writeTag(buf, n228, 8, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3413, v3414, v3412, buffer.len(v3412))
			end

			if p346.is_for_sale ~= nil then
				local v3415 = p346.is_for_sale:encode()
				local v3416, v3417 = proto.writeTag(buf, n228, 9, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3416, v3417, v3415, buffer.len(v3415))
			end

			if p346.product_type ~= nil then
				local v3418 = p346.product_type:encode()
				local v3419, v3420 = proto.writeTag(buf, n228, 10, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3419, v3420, v3418, buffer.len(v3418))
			end

			if p346.base_price_in_robux ~= nil then
				local v3421 = p346.base_price_in_robux:encode()
				local v3422, v3423 = proto.writeTag(buf, n228, 11, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3422, v3423, v3421, buffer.len(v3421))
			end

			if p346.price_discount_details ~= nil then
				local v3424 = p346.price_discount_details:encode()
				local v3425, v3426 = proto.writeTag(buf, n228, 12, proto.wireTypes.lengthDelimited)

				buf, n228 = proto.writeBuffer(v3425, v3426, v3424, buffer.len(v3424))
			end

			local buf117 = buffer.create(n228)

			buffer.copy(buf117, 0, buf, 0, n228)

			return buf117
		end
		function t459.decode(p347: buffer) -- line: 22308
			-- upvalues: t459 (copy), proto (copy), prop_types (copy)
			local v3429 = t459.new()
			local n229 = 0

			while n229 < buffer.len(p347) do
				local v3431, v3432

				v3431, v3432, n229 = proto.readTag(p347, n229)

				if v3432 == proto.wireTypes.varint then
					local v3433

					v3433, n229 = proto.readVarInt(p347, n229)
				elseif v3432 == proto.wireTypes.lengthDelimited then
					if v3431 == 1 then
						local v3434

						v3434, n229 = proto.readBuffer(p347, n229)
						v3429.product_name = prop_types.StringProp.decode(v3434)
					elseif v3431 == 2 then
						local v3435

						v3435, n229 = proto.readBuffer(p347, n229)
						v3429.description = prop_types.StringProp.decode(v3435)
					elseif v3431 == 3 then
						local v3436

						v3436, n229 = proto.readBuffer(p347, n229)
						v3429.image_url = prop_types.StringProp.decode(v3436)
					elseif v3431 == 4 then
						local v3437

						v3437, n229 = proto.readBuffer(p347, n229)
						v3429.price_in_robux = prop_types.Int64Prop.decode(v3437)
					elseif v3431 == 5 then
						local v3438

						v3438, n229 = proto.readBuffer(p347, n229)
						v3429.display_price = prop_types.StringProp.decode(v3438)
					elseif v3431 == 6 then
						local v3439

						v3439, n229 = proto.readBuffer(p347, n229)
						v3429.icon_image_asset_id = prop_types.Int64Prop.decode(v3439)
					elseif v3431 == 7 then
						local v3440

						v3440, n229 = proto.readBuffer(p347, n229)
						v3429.product_id = prop_types.Int64Prop.decode(v3440)
					elseif v3431 == 8 then
						local v3441

						v3441, n229 = proto.readBuffer(p347, n229)
						v3429.target_id = prop_types.StringProp.decode(v3441)
					elseif v3431 == 9 then
						local v3442

						v3442, n229 = proto.readBuffer(p347, n229)
						v3429.is_for_sale = prop_types.BoolProp.decode(v3442)
					elseif v3431 == 10 then
						local v3443

						v3443, n229 = proto.readBuffer(p347, n229)
						v3429.product_type = prop_types.StringProp.decode(v3443)
					elseif v3431 == 11 then
						local v3444

						v3444, n229 = proto.readBuffer(p347, n229)
						v3429.base_price_in_robux = prop_types.Int64Prop.decode(v3444)
					elseif v3431 == 12 then
						local v3445

						v3445, n229 = proto.readBuffer(p347, n229)
						v3429.price_discount_details = prop_types.ArrayOfStructProp.decode(v3445)
					else
						local v3446, v3447 = proto.readVarInt(p347, n229)

						n229 = v3447 + v3446
					end
				elseif v3432 == proto.wireTypes.i32 then
					local v3448

					v3448, n229 = proto.readFixed32(p347, n229)
				elseif v3432 == proto.wireTypes.i64 then
					local v3449

					v3449, n229 = proto.readFixed64(p347, n229)
				else
					error("Unsupported wire type: " .. v3432)
				end
			end

			return v3429
		end
		function t459.jsonEncode(p348) -- line: 22409
			local t461 = {}

			if p348.product_name ~= nil then
				t461.productName = p348.product_name:jsonEncode()
			end

			if p348.description ~= nil then
				t461.description = p348.description:jsonEncode()
			end

			if p348.image_url ~= nil then
				t461.imageUrl = p348.image_url:jsonEncode()
			end

			if p348.price_in_robux ~= nil then
				t461.priceInRobux = p348.price_in_robux:jsonEncode()
			end

			if p348.display_price ~= nil then
				t461.displayPrice = p348.display_price:jsonEncode()
			end

			if p348.icon_image_asset_id ~= nil then
				t461.iconImageAssetId = p348.icon_image_asset_id:jsonEncode()
			end

			if p348.product_id ~= nil then
				t461.productId = p348.product_id:jsonEncode()
			end

			if p348.target_id ~= nil then
				t461.targetId = p348.target_id:jsonEncode()
			end

			if p348.is_for_sale ~= nil then
				t461.isForSale = p348.is_for_sale:jsonEncode()
			end

			if p348.product_type ~= nil then
				t461.productType = p348.product_type:jsonEncode()
			end

			if p348.base_price_in_robux ~= nil then
				t461.basePriceInRobux = p348.base_price_in_robux:jsonEncode()
			end

			if p348.price_discount_details ~= nil then
				t461.priceDiscountDetails = p348.price_discount_details:jsonEncode()
			end

			return t461
		end
		function t459.jsonDecode(t462: {[any]: any}) -- line: 22465
			-- upvalues: t459 (copy), prop_types (copy)
			local v3453 = t459.new()

			if t462.product_name ~= nil then
				v3453.product_name = prop_types.StringProp.jsonDecode(t462.product_name)
			end

			if t462.productName ~= nil then
				v3453.product_name = prop_types.StringProp.jsonDecode(t462.productName)
			end

			if t462.description ~= nil then
				v3453.description = prop_types.StringProp.jsonDecode(t462.description)
			end

			if t462.image_url ~= nil then
				v3453.image_url = prop_types.StringProp.jsonDecode(t462.image_url)
			end

			if t462.imageUrl ~= nil then
				v3453.image_url = prop_types.StringProp.jsonDecode(t462.imageUrl)
			end

			if t462.price_in_robux ~= nil then
				v3453.price_in_robux = prop_types.Int64Prop.jsonDecode(t462.price_in_robux)
			end

			if t462.priceInRobux ~= nil then
				v3453.price_in_robux = prop_types.Int64Prop.jsonDecode(t462.priceInRobux)
			end

			if t462.display_price ~= nil then
				v3453.display_price = prop_types.StringProp.jsonDecode(t462.display_price)
			end

			if t462.displayPrice ~= nil then
				v3453.display_price = prop_types.StringProp.jsonDecode(t462.displayPrice)
			end

			if t462.icon_image_asset_id ~= nil then
				v3453.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t462.icon_image_asset_id)
			end

			if t462.iconImageAssetId ~= nil then
				v3453.icon_image_asset_id = prop_types.Int64Prop.jsonDecode(t462.iconImageAssetId)
			end

			if t462.product_id ~= nil then
				v3453.product_id = prop_types.Int64Prop.jsonDecode(t462.product_id)
			end

			if t462.productId ~= nil then
				v3453.product_id = prop_types.Int64Prop.jsonDecode(t462.productId)
			end

			if t462.target_id ~= nil then
				v3453.target_id = prop_types.StringProp.jsonDecode(t462.target_id)
			end

			if t462.targetId ~= nil then
				v3453.target_id = prop_types.StringProp.jsonDecode(t462.targetId)
			end

			if t462.is_for_sale ~= nil then
				v3453.is_for_sale = prop_types.BoolProp.jsonDecode(t462.is_for_sale)
			end

			if t462.isForSale ~= nil then
				v3453.is_for_sale = prop_types.BoolProp.jsonDecode(t462.isForSale)
			end

			if t462.product_type ~= nil then
				v3453.product_type = prop_types.StringProp.jsonDecode(t462.product_type)
			end

			if t462.productType ~= nil then
				v3453.product_type = prop_types.StringProp.jsonDecode(t462.productType)
			end

			if t462.base_price_in_robux ~= nil then
				v3453.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t462.base_price_in_robux)
			end

			if t462.basePriceInRobux ~= nil then
				v3453.base_price_in_robux = prop_types.Int64Prop.jsonDecode(t462.basePriceInRobux)
			end

			if t462.price_discount_details ~= nil then
				v3453.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t462.price_discount_details)
			end

			if t462.priceDiscountDetails ~= nil then
				v3453.price_discount_details = prop_types.ArrayOfStructProp.jsonDecode(t462.priceDiscountDetails)
			end

			return v3453
		end

		t459.descriptor = {
			name = "OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.DisplayInfoLiteral"
		}
		t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral = t459
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_DisplayInfo_DisplayInfoLiteral)

	do
		local t463 = {}

		t463.__index = t463

		function t463.new(t464: {[any]: any}?) -- line: 22599
			-- upvalues: t463 (copy)
			return (setmetatable({
				kind = if t464 ~= nil and t464.kind ~= nil then t464.kind else nil
			}, t463))
		end
		function t463.encode(p349) -- line: 22607
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n230 = 0

			if p349.kind ~= nil then
				if p349.kind.type == "literal" then
					local v3458 = p349.kind.value:encode()
					local v3459, v3460 = proto.writeTag(buf, n230, 1, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeBuffer(v3459, v3460, v3458, buffer.len(v3458))
				elseif p349.kind.type == "binding_path" then
					local v3461, v3462 = proto.writeTag(buf, n230, 2, proto.wireTypes.lengthDelimited)

					buf, n230 = proto.writeString(v3461, v3462, p349.kind.value)
				end
			end

			local buf118 = buffer.create(n230)

			buffer.copy(buf118, 0, buf, 0, n230)

			return buf118
		end
		function t463.decode(p350: buffer) -- line: 22629
			-- upvalues: t463 (copy), proto (copy), t1 (copy)
			local v3465 = t463.new()
			local n231 = 0

			while n231 < buffer.len(p350) do
				local v3467, v3468

				v3467, v3468, n231 = proto.readTag(p350, n231)

				if v3468 == proto.wireTypes.varint then
					local v3469

					v3469, n231 = proto.readVarInt(p350, n231)
				elseif v3468 == proto.wireTypes.lengthDelimited then
					if v3467 == 1 then
						local v3470

						v3470, n231 = proto.readBuffer(p350, n231)
						v3465.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.decode(v3470)
						}
					elseif v3467 == 2 then
						local v3471

						v3471, n231 = proto.readBuffer(p350, n231)
						v3465.kind = {
							type = "binding_path",
							value = buffer.tostring(v3471)
						}
					else
						local v3472, v3473 = proto.readVarInt(p350, n231)

						n231 = v3473 + v3472
					end
				elseif v3468 == proto.wireTypes.i32 then
					local v3474

					v3474, n231 = proto.readFixed32(p350, n231)
				elseif v3468 == proto.wireTypes.i64 then
					local v3475

					v3475, n231 = proto.readFixed64(p350, n231)
				else
					error("Unsupported wire type: " .. v3468)
				end
			end

			return v3465
		end
		function t463.jsonEncode(p351) -- line: 22682
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
		function t463.jsonDecode(t466: {[any]: any}) -- line: 22698
			-- upvalues: t463 (copy), t1 (copy)
			local v3479 = t463.new()

			if t466.literal ~= nil then
				v3479.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral.jsonDecode(t466.literal)
				}
			end

			if t466.binding_path ~= nil then
				v3479.kind = {
					type = "binding_path",
					value = t466.binding_path
				}
			end

			if t466.bindingPath ~= nil then
				v3479.kind = {
					type = "binding_path",
					value = t466.bindingPath
				}
			end

			return v3479
		end

		t463.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseOptions",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptions"
		}
		t1.OpenPurchasePromptAction_PurchaseOptions = t463
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions)

		local t467 = {}

		t467.__index = t467

		function t467.new(t468: {[any]: any}?) -- line: 22738
			-- upvalues: t467 (copy)
			return (setmetatable({
				should_skip_ownership_check = if t468 ~= nil and t468.should_skip_ownership_check ~= nil then t468.should_skip_ownership_check else nil,
				enable_preloaded_purchase_ui = if t468 ~= nil and t468.enable_preloaded_purchase_ui ~= nil then t468.enable_preloaded_purchase_ui else nil,
				completion_message = if t468 ~= nil and t468.completion_message ~= nil then t468.completion_message else nil,
				completion_button_text = if t468 ~= nil and t468.completion_button_text ~= nil then t468.completion_button_text else nil,
				prevent_double_confirm = if t468 ~= nil and t468.prevent_double_confirm ~= nil then t468.prevent_double_confirm else nil,
				provided_robux_balance = if t468 ~= nil and t468.provided_robux_balance ~= nil then t468.provided_robux_balance else nil
			}, t467))
		end
		function t467.encode(p352) -- line: 22766
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n232 = 0

			if p352.should_skip_ownership_check ~= nil then
				local v3484 = p352.should_skip_ownership_check:encode()
				local v3485, v3486 = proto.writeTag(buf, n232, 1, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3485, v3486, v3484, buffer.len(v3484))
			end

			if p352.enable_preloaded_purchase_ui ~= nil then
				local v3487 = p352.enable_preloaded_purchase_ui:encode()
				local v3488, v3489 = proto.writeTag(buf, n232, 2, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3488, v3489, v3487, buffer.len(v3487))
			end

			if p352.completion_message ~= nil then
				local v3490 = p352.completion_message:encode()
				local v3491, v3492 = proto.writeTag(buf, n232, 3, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3491, v3492, v3490, buffer.len(v3490))
			end

			if p352.completion_button_text ~= nil then
				local v3493 = p352.completion_button_text:encode()
				local v3494, v3495 = proto.writeTag(buf, n232, 4, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3494, v3495, v3493, buffer.len(v3493))
			end

			if p352.prevent_double_confirm ~= nil then
				local v3496 = p352.prevent_double_confirm:encode()
				local v3497, v3498 = proto.writeTag(buf, n232, 5, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3497, v3498, v3496, buffer.len(v3496))
			end

			if p352.provided_robux_balance ~= nil then
				local v3499 = p352.provided_robux_balance:encode()
				local v3500, v3501 = proto.writeTag(buf, n232, 6, proto.wireTypes.lengthDelimited)

				buf, n232 = proto.writeBuffer(v3500, v3501, v3499, buffer.len(v3499))
			end

			local buf119 = buffer.create(n232)

			buffer.copy(buf119, 0, buf, 0, n232)

			return buf119
		end
		function t467.decode(p353: buffer) -- line: 22813
			-- upvalues: t467 (copy), proto (copy), prop_types (copy)
			local v3504 = t467.new()
			local n233 = 0

			while n233 < buffer.len(p353) do
				local v3506, v3507

				v3506, v3507, n233 = proto.readTag(p353, n233)

				if v3507 == proto.wireTypes.varint then
					local v3508

					v3508, n233 = proto.readVarInt(p353, n233)
				elseif v3507 == proto.wireTypes.lengthDelimited then
					if v3506 == 1 then
						local v3509

						v3509, n233 = proto.readBuffer(p353, n233)
						v3504.should_skip_ownership_check = prop_types.BoolProp.decode(v3509)
					elseif v3506 == 2 then
						local v3510

						v3510, n233 = proto.readBuffer(p353, n233)
						v3504.enable_preloaded_purchase_ui = prop_types.BoolProp.decode(v3510)
					elseif v3506 == 3 then
						local v3511

						v3511, n233 = proto.readBuffer(p353, n233)
						v3504.completion_message = prop_types.StringProp.decode(v3511)
					elseif v3506 == 4 then
						local v3512

						v3512, n233 = proto.readBuffer(p353, n233)
						v3504.completion_button_text = prop_types.StringProp.decode(v3512)
					elseif v3506 == 5 then
						local v3513

						v3513, n233 = proto.readBuffer(p353, n233)
						v3504.prevent_double_confirm = prop_types.BoolProp.decode(v3513)
					elseif v3506 == 6 then
						local v3514

						v3514, n233 = proto.readBuffer(p353, n233)
						v3504.provided_robux_balance = prop_types.Int64Prop.decode(v3514)
					else
						local v3515, v3516 = proto.readVarInt(p353, n233)

						n233 = v3516 + v3515
					end
				elseif v3507 == proto.wireTypes.i32 then
					local v3517

					v3517, n233 = proto.readFixed32(p353, n233)
				elseif v3507 == proto.wireTypes.i64 then
					local v3518

					v3518, n233 = proto.readFixed64(p353, n233)
				else
					error("Unsupported wire type: " .. v3507)
				end
			end

			return v3504
		end
		function t467.jsonEncode(p354) -- line: 22888
			local t469 = {}

			if p354.should_skip_ownership_check ~= nil then
				t469.shouldSkipOwnershipCheck = p354.should_skip_ownership_check:jsonEncode()
			end

			if p354.enable_preloaded_purchase_ui ~= nil then
				t469.enablePreloadedPurchaseUi = p354.enable_preloaded_purchase_ui:jsonEncode()
			end

			if p354.completion_message ~= nil then
				t469.completionMessage = p354.completion_message:jsonEncode()
			end

			if p354.completion_button_text ~= nil then
				t469.completionButtonText = p354.completion_button_text:jsonEncode()
			end

			if p354.prevent_double_confirm ~= nil then
				t469.preventDoubleConfirm = p354.prevent_double_confirm:jsonEncode()
			end

			if p354.provided_robux_balance ~= nil then
				t469.providedRobuxBalance = p354.provided_robux_balance:jsonEncode()
			end

			return t469
		end
		function t467.jsonDecode(t470: {[any]: any}) -- line: 22920
			-- upvalues: t467 (copy), prop_types (copy)
			local v3522 = t467.new()

			if t470.should_skip_ownership_check ~= nil then
				v3522.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t470.should_skip_ownership_check)
			end

			if t470.shouldSkipOwnershipCheck ~= nil then
				v3522.should_skip_ownership_check = prop_types.BoolProp.jsonDecode(t470.shouldSkipOwnershipCheck)
			end

			if t470.enable_preloaded_purchase_ui ~= nil then
				v3522.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t470.enable_preloaded_purchase_ui)
			end

			if t470.enablePreloadedPurchaseUi ~= nil then
				v3522.enable_preloaded_purchase_ui = prop_types.BoolProp.jsonDecode(t470.enablePreloadedPurchaseUi)
			end

			if t470.completion_message ~= nil then
				v3522.completion_message = prop_types.StringProp.jsonDecode(t470.completion_message)
			end

			if t470.completionMessage ~= nil then
				v3522.completion_message = prop_types.StringProp.jsonDecode(t470.completionMessage)
			end

			if t470.completion_button_text ~= nil then
				v3522.completion_button_text = prop_types.StringProp.jsonDecode(t470.completion_button_text)
			end

			if t470.completionButtonText ~= nil then
				v3522.completion_button_text = prop_types.StringProp.jsonDecode(t470.completionButtonText)
			end

			if t470.prevent_double_confirm ~= nil then
				v3522.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t470.prevent_double_confirm)
			end

			if t470.preventDoubleConfirm ~= nil then
				v3522.prevent_double_confirm = prop_types.BoolProp.jsonDecode(t470.preventDoubleConfirm)
			end

			if t470.provided_robux_balance ~= nil then
				v3522.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t470.provided_robux_balance)
			end

			if t470.providedRobuxBalance ~= nil then
				v3522.provided_robux_balance = prop_types.Int64Prop.jsonDecode(t470.providedRobuxBalance)
			end

			return v3522
		end

		t467.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseOptionsLiteral"
		}
		t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral = t467
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseOptions_PurchaseOptionsLiteral)

	do
		local t471 = {}

		t471.__index = t471

		function t471.new(t472: {[any]: any}?) -- line: 23005
			-- upvalues: t471 (copy)
			return (setmetatable({
				kind = if t472 ~= nil and t472.kind ~= nil then t472.kind else nil
			}, t471))
		end
		function t471.encode(p355) -- line: 23016
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n234 = 0

			if p355.kind ~= nil then
				if p355.kind.type == "literal" then
					local v3527 = p355.kind.value:encode()
					local v3528, v3529 = proto.writeTag(buf, n234, 1, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeBuffer(v3528, v3529, v3527, buffer.len(v3527))
				elseif p355.kind.type == "binding_path" then
					local v3530, v3531 = proto.writeTag(buf, n234, 2, proto.wireTypes.lengthDelimited)

					buf, n234 = proto.writeString(v3530, v3531, p355.kind.value)
				end
			end

			local buf120 = buffer.create(n234)

			buffer.copy(buf120, 0, buf, 0, n234)

			return buf120
		end
		function t471.decode(p356: buffer) -- line: 23038
			-- upvalues: t471 (copy), proto (copy), t1 (copy)
			local v3534 = t471.new()
			local n235 = 0

			while n235 < buffer.len(p356) do
				local v3536, v3537

				v3536, v3537, n235 = proto.readTag(p356, n235)

				if v3537 == proto.wireTypes.varint then
					local v3538

					v3538, n235 = proto.readVarInt(p356, n235)
				elseif v3537 == proto.wireTypes.lengthDelimited then
					if v3536 == 1 then
						local v3539

						v3539, n235 = proto.readBuffer(p356, n235)
						v3534.kind = {
							type = "literal",
							value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.decode(v3539)
						}
					elseif v3536 == 2 then
						local v3540

						v3540, n235 = proto.readBuffer(p356, n235)
						v3534.kind = {
							type = "binding_path",
							value = buffer.tostring(v3540)
						}
					else
						local v3541, v3542 = proto.readVarInt(p356, n235)

						n235 = v3542 + v3541
					end
				elseif v3537 == proto.wireTypes.i32 then
					local v3543

					v3543, n235 = proto.readFixed32(p356, n235)
				elseif v3537 == proto.wireTypes.i64 then
					local v3544

					v3544, n235 = proto.readFixed64(p356, n235)
				else
					error("Unsupported wire type: " .. v3537)
				end
			end

			return v3534
		end
		function t471.jsonEncode(p357) -- line: 23093
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
		function t471.jsonDecode(t474: {[any]: any}) -- line: 23109
			-- upvalues: t471 (copy), t1 (copy)
			local v3548 = t471.new()

			if t474.literal ~= nil then
				v3548.kind = {
					type = "literal",
					value = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral.jsonDecode(t474.literal)
				}
			end

			if t474.binding_path ~= nil then
				v3548.kind = {
					type = "binding_path",
					value = t474.binding_path
				}
			end

			if t474.bindingPath ~= nil then
				v3548.kind = {
					type = "binding_path",
					value = t474.bindingPath
				}
			end

			return v3548
		end

		t471.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadata"
		}
		t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = t471
		typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata)

		local t475 = {}

		t475.__index = t475

		function t475.new(t476: {[any]: any}?) -- line: 23150
			-- upvalues: t475 (copy)
			return (setmetatable({
				surface = if t476 ~= nil and t476.surface ~= nil then t476.surface else nil,
				product_universe_id = if t476 ~= nil and t476.product_universe_id ~= nil then t476.product_universe_id else nil
			}, t475))
		end
		function t475.encode(p358) -- line: 23164
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n236 = 0

			if p358.surface ~= nil then
				local v3553 = p358.surface:encode()
				local v3554, v3555 = proto.writeTag(buf, n236, 1, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3554, v3555, v3553, buffer.len(v3553))
			end

			if p358.product_universe_id ~= nil then
				local v3556 = p358.product_universe_id:encode()
				local v3557, v3558 = proto.writeTag(buf, n236, 2, proto.wireTypes.lengthDelimited)

				buf, n236 = proto.writeBuffer(v3557, v3558, v3556, buffer.len(v3556))
			end

			local buf121 = buffer.create(n236)

			buffer.copy(buf121, 0, buf, 0, n236)

			return buf121
		end
		function t475.decode(p359: buffer) -- line: 23187
			-- upvalues: t475 (copy), proto (copy), prop_types (copy)
			local v3561 = t475.new()
			local n237 = 0

			while n237 < buffer.len(p359) do
				local v3563, v3564

				v3563, v3564, n237 = proto.readTag(p359, n237)

				if v3564 == proto.wireTypes.varint then
					local v3565

					v3565, n237 = proto.readVarInt(p359, n237)
				elseif v3564 == proto.wireTypes.lengthDelimited then
					if v3563 == 1 then
						local v3566

						v3566, n237 = proto.readBuffer(p359, n237)
						v3561.surface = prop_types.StringProp.decode(v3566)
					elseif v3563 == 2 then
						local v3567

						v3567, n237 = proto.readBuffer(p359, n237)
						v3561.product_universe_id = prop_types.StringProp.decode(v3567)
					else
						local v3568, v3569 = proto.readVarInt(p359, n237)

						n237 = v3569 + v3568
					end
				elseif v3564 == proto.wireTypes.i32 then
					local v3570

					v3570, n237 = proto.readFixed32(p359, n237)
				elseif v3564 == proto.wireTypes.i64 then
					local v3571

					v3571, n237 = proto.readFixed64(p359, n237)
				else
					error("Unsupported wire type: " .. v3564)
				end
			end

			return v3561
		end
		function t475.jsonEncode(p360) -- line: 23238
			local t477 = {}

			if p360.surface ~= nil then
				t477.surface = p360.surface:jsonEncode()
			end

			if p360.product_universe_id ~= nil then
				t477.productUniverseId = p360.product_universe_id:jsonEncode()
			end

			return t477
		end
		function t475.jsonDecode(t478: {[any]: any}) -- line: 23254
			-- upvalues: t475 (copy), prop_types (copy)
			local v3575 = t475.new()

			if t478.surface ~= nil then
				v3575.surface = prop_types.StringProp.jsonDecode(t478.surface)
			end

			if t478.product_universe_id ~= nil then
				v3575.product_universe_id = prop_types.StringProp.jsonDecode(t478.product_universe_id)
			end

			if t478.productUniverseId ~= nil then
				v3575.product_universe_id = prop_types.StringProp.jsonDecode(t478.productUniverseId)
			end

			return v3575
		end

		t475.descriptor = {
			name = "OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral",
			fullName = "roblox.apppageplatform.shared.v1beta1.PurchaseAnalyticsMetadataLiteral"
		}
		t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral = t475
	end

	typeRegistry.default:register(t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata_PurchaseAnalyticsMetadataLiteral)

	do
		local t479 = {}

		t479.__index = t479

		function t479.new(t480: {[any]: any}?) -- line: 23295
			-- upvalues: t479 (copy)
			return (setmetatable({
				product_payload = if t480 ~= nil and t480.product_payload ~= nil then t480.product_payload else nil,
				display_info = if t480 ~= nil and t480.display_info ~= nil then t480.display_info else nil,
				purchase_options = if t480 ~= nil and t480.purchase_options ~= nil then t480.purchase_options else nil,
				purchase_analytics_metadata = if t480 ~= nil and t480.purchase_analytics_metadata ~= nil then t480.purchase_analytics_metadata else nil,
				root_place_id = if t480 ~= nil and t480.root_place_id ~= nil then t480.root_place_id else nil
			}, t479))
		end
		function t479.encode(p361) -- line: 23309
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n238 = 0

			if p361.product_payload ~= nil then
				local v3580 = p361.product_payload:encode()
				local v3581, v3582 = proto.writeTag(buf, n238, 1, proto.wireTypes.lengthDelimited)

				buf, n238 = proto.writeBuffer(v3581, v3582, v3580, buffer.len(v3580))
			end

			if p361.display_info ~= nil then
				local v3583 = p361.display_info:encode()
				local v3584, v3585 = proto.writeTag(buf, n238, 2, proto.wireTypes.lengthDelimited)

				buf, n238 = proto.writeBuffer(v3584, v3585, v3583, buffer.len(v3583))
			end

			if p361.purchase_options ~= nil then
				local v3586 = p361.purchase_options:encode()
				local v3587, v3588 = proto.writeTag(buf, n238, 3, proto.wireTypes.lengthDelimited)

				buf, n238 = proto.writeBuffer(v3587, v3588, v3586, buffer.len(v3586))
			end

			if p361.purchase_analytics_metadata ~= nil then
				local v3589 = p361.purchase_analytics_metadata:encode()
				local v3590, v3591 = proto.writeTag(buf, n238, 4, proto.wireTypes.lengthDelimited)

				buf, n238 = proto.writeBuffer(v3590, v3591, v3589, buffer.len(v3589))
			end

			if p361.root_place_id ~= nil then
				local v3592 = p361.root_place_id:encode()
				local v3593, v3594 = proto.writeTag(buf, n238, 5, proto.wireTypes.lengthDelimited)

				buf, n238 = proto.writeBuffer(v3593, v3594, v3592, buffer.len(v3592))
			end

			local buf122 = buffer.create(n238)

			buffer.copy(buf122, 0, buf, 0, n238)

			return buf122
		end
		function t479.decode(p362: buffer) -- line: 23348
			-- upvalues: t479 (copy), proto (copy), t1 (copy), prop_types (copy)
			local v3597 = t479.new()
			local n239 = 0

			while n239 < buffer.len(p362) do
				local v3599, v3600

				v3599, v3600, n239 = proto.readTag(p362, n239)

				if v3600 == proto.wireTypes.varint then
					local v3601

					v3601, n239 = proto.readVarInt(p362, n239)
				elseif v3600 == proto.wireTypes.lengthDelimited then
					if v3599 == 1 then
						local v3602

						v3602, n239 = proto.readBuffer(p362, n239)
						v3597.product_payload = t1.OpenPurchasePromptAction_ProductPayload.decode(v3602)
					elseif v3599 == 2 then
						local v3603

						v3603, n239 = proto.readBuffer(p362, n239)
						v3597.display_info = t1.OpenPurchasePromptAction_DisplayInfo.decode(v3603)
					elseif v3599 == 3 then
						local v3604

						v3604, n239 = proto.readBuffer(p362, n239)
						v3597.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.decode(v3604)
					elseif v3599 == 4 then
						local v3605

						v3605, n239 = proto.readBuffer(p362, n239)
						v3597.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.decode(v3605)
					elseif v3599 == 5 then
						local v3606

						v3606, n239 = proto.readBuffer(p362, n239)
						v3597.root_place_id = prop_types.StringProp.decode(v3606)
					else
						local v3607, v3608 = proto.readVarInt(p362, n239)

						n239 = v3608 + v3607
					end
				elseif v3600 == proto.wireTypes.i32 then
					local v3609

					v3609, n239 = proto.readFixed32(p362, n239)
				elseif v3600 == proto.wireTypes.i64 then
					local v3610

					v3610, n239 = proto.readFixed64(p362, n239)
				else
					error("Unsupported wire type: " .. v3600)
				end
			end

			return v3597
		end
		function t479.jsonEncode(p363) -- line: 23412
			local t481 = {}

			if p363.product_payload ~= nil then
				t481.productPayload = p363.product_payload:jsonEncode()
			end

			if p363.display_info ~= nil then
				t481.displayInfo = p363.display_info:jsonEncode()
			end

			if p363.purchase_options ~= nil then
				t481.purchaseOptions = p363.purchase_options:jsonEncode()
			end

			if p363.purchase_analytics_metadata ~= nil then
				t481.purchaseAnalyticsMetadata = p363.purchase_analytics_metadata:jsonEncode()
			end

			if p363.root_place_id ~= nil then
				t481.rootPlaceId = p363.root_place_id:jsonEncode()
			end

			return t481
		end
		function t479.jsonDecode(t482: {[any]: any}) -- line: 23438
			-- upvalues: t479 (copy), t1 (copy), prop_types (copy)
			local v3614 = t479.new()

			if t482.product_payload ~= nil then
				v3614.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t482.product_payload)
			end

			if t482.productPayload ~= nil then
				v3614.product_payload = t1.OpenPurchasePromptAction_ProductPayload.jsonDecode(t482.productPayload)
			end

			if t482.display_info ~= nil then
				v3614.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t482.display_info)
			end

			if t482.displayInfo ~= nil then
				v3614.display_info = t1.OpenPurchasePromptAction_DisplayInfo.jsonDecode(t482.displayInfo)
			end

			if t482.purchase_options ~= nil then
				v3614.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t482.purchase_options)
			end

			if t482.purchaseOptions ~= nil then
				v3614.purchase_options = t1.OpenPurchasePromptAction_PurchaseOptions.jsonDecode(t482.purchaseOptions)
			end

			if t482.purchase_analytics_metadata ~= nil then
				v3614.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t482.purchase_analytics_metadata)
			end

			if t482.purchaseAnalyticsMetadata ~= nil then
				v3614.purchase_analytics_metadata = t1.OpenPurchasePromptAction_PurchaseAnalyticsMetadata.jsonDecode(t482.purchaseAnalyticsMetadata)
			end

			if t482.root_place_id ~= nil then
				v3614.root_place_id = prop_types.StringProp.jsonDecode(t482.root_place_id)
			end

			if t482.rootPlaceId ~= nil then
				v3614.root_place_id = prop_types.StringProp.jsonDecode(t482.rootPlaceId)
			end

			return v3614
		end

		t479.descriptor = {
			name = "OpenPurchasePromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenPurchasePromptAction_Params = t479
		typeRegistry.default:register(t1.OpenPurchasePromptAction_Params)

		local t483 = {}

		t483.__index = t483

		function t483.new(t484: {[any]: any}?) -- line: 23503
			-- upvalues: t1 (copy), t483 (copy)
			return (setmetatable({
				action_type = if t484 ~= nil and t484.action_type ~= nil then t484.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t484 ~= nil and t484.action_params ~= nil then t484.action_params else nil
			}, t483))
		end
		function t483.encode(p364) -- line: 23514
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n240 = 0

			if p364.action_type ~= nil and (p364.action_type ~= nil and p364.action_type ~= 0 or p364.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3619, v3620 = proto.writeTag(buf, n240, 1, proto.wireTypes.varint)

				buf, n240 = proto.writeVarInt(v3619, v3620, t1.ActionType.toNumber(p364.action_type))
			end

			if p364.action_params ~= nil then
				local v3621 = p364.action_params:encode()
				local v3622, v3623 = proto.writeTag(buf, n240, 2, proto.wireTypes.lengthDelimited)

				buf, n240 = proto.writeBuffer(v3622, v3623, v3621, buffer.len(v3621))
			end

			local buf123 = buffer.create(n240)

			buffer.copy(buf123, 0, buf, 0, n240)

			return buf123
		end
		function t483.decode(p365: buffer) -- line: 23540
			-- upvalues: t483 (copy), proto (copy), t1 (copy)
			local v3626 = t483.new()
			local n241 = 0

			while n241 < buffer.len(p365) do
				local v3628, v3629

				v3628, v3629, n241 = proto.readTag(p365, n241)

				if v3629 == proto.wireTypes.varint then
					if v3628 == 1 then
						local v3630

						v3630, n241 = proto.readVarIntI32(p365, n241)
						v3626.action_type = t1.ActionType.fromNumber(v3630) or v3630
					else
						local v3631

						v3631, n241 = proto.readVarInt(p365, n241)
					end
				elseif v3629 == proto.wireTypes.lengthDelimited then
					if v3628 == 2 then
						local v3632

						v3632, n241 = proto.readBuffer(p365, n241)
						v3626.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.decode(v3632)
					else
						local v3633, v3634 = proto.readVarInt(p365, n241)

						n241 = v3634 + v3633
					end
				elseif v3629 == proto.wireTypes.i32 then
					local v3635

					v3635, n241 = proto.readFixed32(p365, n241)
				elseif v3629 == proto.wireTypes.i64 then
					local v3636

					v3636, n241 = proto.readFixed64(p365, n241)
				else
					error("Unsupported wire type: " .. v3629)
				end
			end

			return v3626
		end
		function t483.jsonEncode(p366) -- line: 23588
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
		function t483.jsonDecode(t486: {[any]: any}) -- line: 23610
			-- upvalues: t483 (copy), t1 (copy)
			local v3640 = t483.new()

			if t486.action_type ~= nil then
				v3640.action_type = if typeof(t486.action_type) ~= "number" then t1.ActionType.fromName(t486.action_type) or t486.action_type else t1.ActionType.fromNumber(t486.action_type) or t486.action_type
			end

			if t486.actionType ~= nil then
				v3640.action_type = if typeof(t486.actionType) ~= "number" then t1.ActionType.fromName(t486.actionType) or t486.actionType else t1.ActionType.fromNumber(t486.actionType) or t486.actionType
			end

			if t486.action_params ~= nil then
				v3640.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t486.action_params)
			end

			if t486.actionParams ~= nil then
				v3640.action_params = t1.ReportSurfaceLoadTimeMilestoneAction_Params.jsonDecode(t486.actionParams)
			end

			return v3640
		end

		t483.descriptor = {
			name = "ReportSurfaceLoadTimeMilestoneAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.ReportSurfaceLoadTimeMilestoneAction"
		}
		t1.ReportSurfaceLoadTimeMilestoneAction = t483
	end

	typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction)

	do
		local t487 = {}

		t487.__index = t487

		function t487.new(t488: {[any]: any}?) -- line: 23652
			-- upvalues: t487 (copy)
			return (setmetatable({
				milestone = if t488 ~= nil and t488.milestone ~= nil then t488.milestone else nil,
				metadata = if t488 ~= nil and t488.metadata ~= nil then t488.metadata else nil
			}, t487))
		end
		function t487.encode(p367) -- line: 23661
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n242 = 0

			if p367.milestone ~= nil then
				local v3645 = p367.milestone:encode()
				local v3646, v3647 = proto.writeTag(buf, n242, 1, proto.wireTypes.lengthDelimited)

				buf, n242 = proto.writeBuffer(v3646, v3647, v3645, buffer.len(v3645))
			end

			if p367.metadata ~= nil then
				local v3648 = p367.metadata:encode()
				local v3649, v3650 = proto.writeTag(buf, n242, 3, proto.wireTypes.lengthDelimited)

				buf, n242 = proto.writeBuffer(v3649, v3650, v3648, buffer.len(v3648))
			end

			local buf124 = buffer.create(n242)

			buffer.copy(buf124, 0, buf, 0, n242)

			return buf124
		end
		function t487.decode(p368: buffer) -- line: 23684
			-- upvalues: t487 (copy), proto (copy), prop_types (copy)
			local v3653 = t487.new()
			local n243 = 0

			while n243 < buffer.len(p368) do
				local v3655, v3656

				v3655, v3656, n243 = proto.readTag(p368, n243)

				if v3656 == proto.wireTypes.varint then
					local v3657

					v3657, n243 = proto.readVarInt(p368, n243)
				elseif v3656 == proto.wireTypes.lengthDelimited then
					if v3655 == 1 then
						local v3658

						v3658, n243 = proto.readBuffer(p368, n243)
						v3653.milestone = prop_types.StringProp.decode(v3658)
					elseif v3655 == 3 then
						local v3659

						v3659, n243 = proto.readBuffer(p368, n243)
						v3653.metadata = prop_types.StructProp.decode(v3659)
					else
						local v3660, v3661 = proto.readVarInt(p368, n243)

						n243 = v3661 + v3660
					end
				elseif v3656 == proto.wireTypes.i32 then
					local v3662

					v3662, n243 = proto.readFixed32(p368, n243)
				elseif v3656 == proto.wireTypes.i64 then
					local v3663

					v3663, n243 = proto.readFixed64(p368, n243)
				else
					error("Unsupported wire type: " .. v3656)
				end
			end

			return v3653
		end
		function t487.jsonEncode(p369) -- line: 23734
			local t489 = {}

			if p369.milestone ~= nil then
				t489.milestone = p369.milestone:jsonEncode()
			end

			if p369.metadata ~= nil then
				t489.metadata = p369.metadata:jsonEncode()
			end

			return t489
		end
		function t487.jsonDecode(t490: {[any]: any}) -- line: 23750
			-- upvalues: t487 (copy), prop_types (copy)
			local v3667 = t487.new()

			if t490.milestone ~= nil then
				v3667.milestone = prop_types.StringProp.jsonDecode(t490.milestone)
			end

			if t490.metadata ~= nil then
				v3667.metadata = prop_types.StructProp.jsonDecode(t490.metadata)
			end

			return v3667
		end

		t487.descriptor = {
			name = "ReportSurfaceLoadTimeMilestoneAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.ReportSurfaceLoadTimeMilestoneAction_Params = t487
		typeRegistry.default:register(t1.ReportSurfaceLoadTimeMilestoneAction_Params)

		local t491 = {}

		t491.__index = t491

		function t491.new(t492: {[any]: any}?) -- line: 23780
			-- upvalues: t1 (copy), t491 (copy)
			return (setmetatable({
				action_type = if t492 ~= nil and t492.action_type ~= nil then t492.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t492 ~= nil and t492.action_params ~= nil then t492.action_params else nil
			}, t491))
		end
		function t491.encode(p370) -- line: 23791
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n244 = 0

			if p370.action_type ~= nil and (p370.action_type ~= nil and p370.action_type ~= 0 or p370.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3672, v3673 = proto.writeTag(buf, n244, 1, proto.wireTypes.varint)

				buf, n244 = proto.writeVarInt(v3672, v3673, t1.ActionType.toNumber(p370.action_type))
			end

			if p370.action_params ~= nil then
				local v3674 = p370.action_params:encode()
				local v3675, v3676 = proto.writeTag(buf, n244, 2, proto.wireTypes.lengthDelimited)

				buf, n244 = proto.writeBuffer(v3675, v3676, v3674, buffer.len(v3674))
			end

			local buf125 = buffer.create(n244)

			buffer.copy(buf125, 0, buf, 0, n244)

			return buf125
		end
		function t491.decode(p371: buffer) -- line: 23817
			-- upvalues: t491 (copy), proto (copy), t1 (copy)
			local v3679 = t491.new()
			local n245 = 0

			while n245 < buffer.len(p371) do
				local v3681, v3682

				v3681, v3682, n245 = proto.readTag(p371, n245)

				if v3682 == proto.wireTypes.varint then
					if v3681 == 1 then
						local v3683

						v3683, n245 = proto.readVarIntI32(p371, n245)
						v3679.action_type = t1.ActionType.fromNumber(v3683) or v3683
					else
						local v3684

						v3684, n245 = proto.readVarInt(p371, n245)
					end
				elseif v3682 == proto.wireTypes.lengthDelimited then
					if v3681 == 2 then
						local v3685

						v3685, n245 = proto.readBuffer(p371, n245)
						v3679.action_params = t1.DismissGameFeedbackAction_Params.decode(v3685)
					else
						local v3686, v3687 = proto.readVarInt(p371, n245)

						n245 = v3687 + v3686
					end
				elseif v3682 == proto.wireTypes.i32 then
					local v3688

					v3688, n245 = proto.readFixed32(p371, n245)
				elseif v3682 == proto.wireTypes.i64 then
					local v3689

					v3689, n245 = proto.readFixed64(p371, n245)
				else
					error("Unsupported wire type: " .. v3682)
				end
			end

			return v3679
		end
		function t491.jsonEncode(p372) -- line: 23865
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
		function t491.jsonDecode(t494: {[any]: any}) -- line: 23887
			-- upvalues: t491 (copy), t1 (copy)
			local v3693 = t491.new()

			if t494.action_type ~= nil then
				v3693.action_type = if typeof(t494.action_type) ~= "number" then t1.ActionType.fromName(t494.action_type) or t494.action_type else t1.ActionType.fromNumber(t494.action_type) or t494.action_type
			end

			if t494.actionType ~= nil then
				v3693.action_type = if typeof(t494.actionType) ~= "number" then t1.ActionType.fromName(t494.actionType) or t494.actionType else t1.ActionType.fromNumber(t494.actionType) or t494.actionType
			end

			if t494.action_params ~= nil then
				v3693.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t494.action_params)
			end

			if t494.actionParams ~= nil then
				v3693.action_params = t1.DismissGameFeedbackAction_Params.jsonDecode(t494.actionParams)
			end

			return v3693
		end

		t491.descriptor = {
			name = "DismissGameFeedbackAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissGameFeedbackAction"
		}
		t1.DismissGameFeedbackAction = t491
	end

	typeRegistry.default:register(t1.DismissGameFeedbackAction)

	do
		local t495 = {}

		t495.__index = t495

		function t495.new(t496: {[any]: any}?) -- line: 23927
			-- upvalues: t495 (copy)
			return (setmetatable({
				root_place_id = if t496 ~= nil and t496.root_place_id ~= nil then t496.root_place_id else nil
			}, t495))
		end
		function t495.encode(p373) -- line: 23935
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n246 = 0

			if p373.root_place_id ~= nil then
				local v3698 = p373.root_place_id:encode()
				local v3699, v3700 = proto.writeTag(buf, n246, 1, proto.wireTypes.lengthDelimited)

				buf, n246 = proto.writeBuffer(v3699, v3700, v3698, buffer.len(v3698))
			end

			local buf126 = buffer.create(n246)

			buffer.copy(buf126, 0, buf, 0, n246)

			return buf126
		end
		function t495.decode(p374: buffer) -- line: 23950
			-- upvalues: t495 (copy), proto (copy), prop_types (copy)
			local v3703 = t495.new()
			local n247 = 0

			while n247 < buffer.len(p374) do
				local v3705, v3706

				v3705, v3706, n247 = proto.readTag(p374, n247)

				if v3706 == proto.wireTypes.varint then
					local v3707

					v3707, n247 = proto.readVarInt(p374, n247)
				elseif v3706 == proto.wireTypes.lengthDelimited then
					if v3705 == 1 then
						local v3708

						v3708, n247 = proto.readBuffer(p374, n247)
						v3703.root_place_id = prop_types.StringProp.decode(v3708)
					else
						local v3709, v3710 = proto.readVarInt(p374, n247)

						n247 = v3710 + v3709
					end
				elseif v3706 == proto.wireTypes.i32 then
					local v3711

					v3711, n247 = proto.readFixed32(p374, n247)
				elseif v3706 == proto.wireTypes.i64 then
					local v3712

					v3712, n247 = proto.readFixed64(p374, n247)
				else
					error("Unsupported wire type: " .. v3706)
				end
			end

			return v3703
		end
		function t495.jsonEncode(p375) -- line: 23993
			local t497 = {}

			if p375.root_place_id ~= nil then
				t497.rootPlaceId = p375.root_place_id:jsonEncode()
			end

			return t497
		end
		function t495.jsonDecode(t498: {[any]: any}) -- line: 24003
			-- upvalues: t495 (copy), prop_types (copy)
			local v3716 = t495.new()

			if t498.root_place_id ~= nil then
				v3716.root_place_id = prop_types.StringProp.jsonDecode(t498.root_place_id)
			end

			if t498.rootPlaceId ~= nil then
				v3716.root_place_id = prop_types.StringProp.jsonDecode(t498.rootPlaceId)
			end

			return v3716
		end

		t495.descriptor = {
			name = "DismissGameFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissGameFeedbackAction_Params = t495
		typeRegistry.default:register(t1.DismissGameFeedbackAction_Params)

		local t499 = {}

		t499.__index = t499

		function t499.new(t500: {[any]: any}?) -- line: 24035
			-- upvalues: t1 (copy), t499 (copy)
			return (setmetatable({
				action_type = if t500 ~= nil and t500.action_type ~= nil then t500.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t500 ~= nil and t500.action_params ~= nil then t500.action_params else nil
			}, t499))
		end
		function t499.encode(p376) -- line: 24046
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n248 = 0

			if p376.action_type ~= nil and (p376.action_type ~= nil and p376.action_type ~= 0 or p376.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3721, v3722 = proto.writeTag(buf, n248, 1, proto.wireTypes.varint)

				buf, n248 = proto.writeVarInt(v3721, v3722, t1.ActionType.toNumber(p376.action_type))
			end

			if p376.action_params ~= nil then
				local v3723 = p376.action_params:encode()
				local v3724, v3725 = proto.writeTag(buf, n248, 2, proto.wireTypes.lengthDelimited)

				buf, n248 = proto.writeBuffer(v3724, v3725, v3723, buffer.len(v3723))
			end

			local buf127 = buffer.create(n248)

			buffer.copy(buf127, 0, buf, 0, n248)

			return buf127
		end
		function t499.decode(p377: buffer) -- line: 24072
			-- upvalues: t499 (copy), proto (copy), t1 (copy)
			local v3728 = t499.new()
			local n249 = 0

			while n249 < buffer.len(p377) do
				local v3730, v3731

				v3730, v3731, n249 = proto.readTag(p377, n249)

				if v3731 == proto.wireTypes.varint then
					if v3730 == 1 then
						local v3732

						v3732, n249 = proto.readVarIntI32(p377, n249)
						v3728.action_type = t1.ActionType.fromNumber(v3732) or v3732
					else
						local v3733

						v3733, n249 = proto.readVarInt(p377, n249)
					end
				elseif v3731 == proto.wireTypes.lengthDelimited then
					if v3730 == 2 then
						local v3734

						v3734, n249 = proto.readBuffer(p377, n249)
						v3728.action_params = t1.OpenGameFeedbackFormAction_Params.decode(v3734)
					else
						local v3735, v3736 = proto.readVarInt(p377, n249)

						n249 = v3736 + v3735
					end
				elseif v3731 == proto.wireTypes.i32 then
					local v3737

					v3737, n249 = proto.readFixed32(p377, n249)
				elseif v3731 == proto.wireTypes.i64 then
					local v3738

					v3738, n249 = proto.readFixed64(p377, n249)
				else
					error("Unsupported wire type: " .. v3731)
				end
			end

			return v3728
		end
		function t499.jsonEncode(p378) -- line: 24120
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
		function t499.jsonDecode(t502: {[any]: any}) -- line: 24142
			-- upvalues: t499 (copy), t1 (copy)
			local v3742 = t499.new()

			if t502.action_type ~= nil then
				v3742.action_type = if typeof(t502.action_type) ~= "number" then t1.ActionType.fromName(t502.action_type) or t502.action_type else t1.ActionType.fromNumber(t502.action_type) or t502.action_type
			end

			if t502.actionType ~= nil then
				v3742.action_type = if typeof(t502.actionType) ~= "number" then t1.ActionType.fromName(t502.actionType) or t502.actionType else t1.ActionType.fromNumber(t502.actionType) or t502.actionType
			end

			if t502.action_params ~= nil then
				v3742.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t502.action_params)
			end

			if t502.actionParams ~= nil then
				v3742.action_params = t1.OpenGameFeedbackFormAction_Params.jsonDecode(t502.actionParams)
			end

			return v3742
		end

		t499.descriptor = {
			name = "OpenGameFeedbackFormAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenGameFeedbackFormAction"
		}
		t1.OpenGameFeedbackFormAction = t499
	end

	typeRegistry.default:register(t1.OpenGameFeedbackFormAction)

	do
		local t503 = {}

		t503.__index = t503

		function t503.new(t504: {[any]: any}?) -- line: 24182
			-- upvalues: t503 (copy)
			return (setmetatable({
				universe_id = if t504 ~= nil and t504.universe_id ~= nil then t504.universe_id else nil,
				root_place_id = if t504 ~= nil and t504.root_place_id ~= nil then t504.root_place_id else nil
			}, t503))
		end
		function t503.encode(p379) -- line: 24191
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n250 = 0

			if p379.universe_id ~= nil then
				local v3747 = p379.universe_id:encode()
				local v3748, v3749 = proto.writeTag(buf, n250, 1, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3748, v3749, v3747, buffer.len(v3747))
			end

			if p379.root_place_id ~= nil then
				local v3750 = p379.root_place_id:encode()
				local v3751, v3752 = proto.writeTag(buf, n250, 2, proto.wireTypes.lengthDelimited)

				buf, n250 = proto.writeBuffer(v3751, v3752, v3750, buffer.len(v3750))
			end

			local buf128 = buffer.create(n250)

			buffer.copy(buf128, 0, buf, 0, n250)

			return buf128
		end
		function t503.decode(p380: buffer) -- line: 24212
			-- upvalues: t503 (copy), proto (copy), prop_types (copy)
			local v3755 = t503.new()
			local n251 = 0

			while n251 < buffer.len(p380) do
				local v3757, v3758

				v3757, v3758, n251 = proto.readTag(p380, n251)

				if v3758 == proto.wireTypes.varint then
					local v3759

					v3759, n251 = proto.readVarInt(p380, n251)
				elseif v3758 == proto.wireTypes.lengthDelimited then
					if v3757 == 1 then
						local v3760

						v3760, n251 = proto.readBuffer(p380, n251)
						v3755.universe_id = prop_types.StringProp.decode(v3760)
					elseif v3757 == 2 then
						local v3761

						v3761, n251 = proto.readBuffer(p380, n251)
						v3755.root_place_id = prop_types.StringProp.decode(v3761)
					else
						local v3762, v3763 = proto.readVarInt(p380, n251)

						n251 = v3763 + v3762
					end
				elseif v3758 == proto.wireTypes.i32 then
					local v3764

					v3764, n251 = proto.readFixed32(p380, n251)
				elseif v3758 == proto.wireTypes.i64 then
					local v3765

					v3765, n251 = proto.readFixed64(p380, n251)
				else
					error("Unsupported wire type: " .. v3758)
				end
			end

			return v3755
		end
		function t503.jsonEncode(p381) -- line: 24260
			local t505 = {}

			if p381.universe_id ~= nil then
				t505.universeId = p381.universe_id:jsonEncode()
			end

			if p381.root_place_id ~= nil then
				t505.rootPlaceId = p381.root_place_id:jsonEncode()
			end

			return t505
		end
		function t503.jsonDecode(t506: {[any]: any}) -- line: 24274
			-- upvalues: t503 (copy), prop_types (copy)
			local v3769 = t503.new()

			if t506.universe_id ~= nil then
				v3769.universe_id = prop_types.StringProp.jsonDecode(t506.universe_id)
			end

			if t506.universeId ~= nil then
				v3769.universe_id = prop_types.StringProp.jsonDecode(t506.universeId)
			end

			if t506.root_place_id ~= nil then
				v3769.root_place_id = prop_types.StringProp.jsonDecode(t506.root_place_id)
			end

			if t506.rootPlaceId ~= nil then
				v3769.root_place_id = prop_types.StringProp.jsonDecode(t506.rootPlaceId)
			end

			return v3769
		end

		t503.descriptor = {
			name = "OpenGameFeedbackFormAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenGameFeedbackFormAction_Params = t503
		typeRegistry.default:register(t1.OpenGameFeedbackFormAction_Params)

		local t507 = {}

		t507.__index = t507

		function t507.new(t508: {[any]: any}?) -- line: 24315
			-- upvalues: t1 (copy), t507 (copy)
			return (setmetatable({
				action_type = if t508 ~= nil and t508.action_type ~= nil then t508.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t508 ~= nil and t508.action_params ~= nil then t508.action_params else nil
			}, t507))
		end
		function t507.encode(p382) -- line: 24324
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n252 = 0

			if p382.action_type ~= nil and (p382.action_type ~= nil and p382.action_type ~= 0 or p382.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3774, v3775 = proto.writeTag(buf, n252, 1, proto.wireTypes.varint)

				buf, n252 = proto.writeVarInt(v3774, v3775, t1.ActionType.toNumber(p382.action_type))
			end

			if p382.action_params ~= nil then
				local v3776 = p382.action_params:encode()
				local v3777, v3778 = proto.writeTag(buf, n252, 2, proto.wireTypes.lengthDelimited)

				buf, n252 = proto.writeBuffer(v3777, v3778, v3776, buffer.len(v3776))
			end

			local buf129 = buffer.create(n252)

			buffer.copy(buf129, 0, buf, 0, n252)

			return buf129
		end
		function t507.decode(p383: buffer) -- line: 24350
			-- upvalues: t507 (copy), proto (copy), t1 (copy)
			local v3781 = t507.new()
			local n253 = 0

			while n253 < buffer.len(p383) do
				local v3783, v3784

				v3783, v3784, n253 = proto.readTag(p383, n253)

				if v3784 == proto.wireTypes.varint then
					if v3783 == 1 then
						local v3785

						v3785, n253 = proto.readVarIntI32(p383, n253)
						v3781.action_type = t1.ActionType.fromNumber(v3785) or v3785
					else
						local v3786

						v3786, n253 = proto.readVarInt(p383, n253)
					end
				elseif v3784 == proto.wireTypes.lengthDelimited then
					if v3783 == 2 then
						local v3787

						v3787, n253 = proto.readBuffer(p383, n253)
						v3781.action_params = t1.AiOverviewFeedbackAction_Params.decode(v3787)
					else
						local v3788, v3789 = proto.readVarInt(p383, n253)

						n253 = v3789 + v3788
					end
				elseif v3784 == proto.wireTypes.i32 then
					local v3790

					v3790, n253 = proto.readFixed32(p383, n253)
				elseif v3784 == proto.wireTypes.i64 then
					local v3791

					v3791, n253 = proto.readFixed64(p383, n253)
				else
					error("Unsupported wire type: " .. v3784)
				end
			end

			return v3781
		end
		function t507.jsonEncode(p384) -- line: 24398
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
		function t507.jsonDecode(t510: {[any]: any}) -- line: 24420
			-- upvalues: t507 (copy), t1 (copy)
			local v3795 = t507.new()

			if t510.action_type ~= nil then
				v3795.action_type = if typeof(t510.action_type) ~= "number" then t1.ActionType.fromName(t510.action_type) or t510.action_type else t1.ActionType.fromNumber(t510.action_type) or t510.action_type
			end

			if t510.actionType ~= nil then
				v3795.action_type = if typeof(t510.actionType) ~= "number" then t1.ActionType.fromName(t510.actionType) or t510.actionType else t1.ActionType.fromNumber(t510.actionType) or t510.actionType
			end

			if t510.action_params ~= nil then
				v3795.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t510.action_params)
			end

			if t510.actionParams ~= nil then
				v3795.action_params = t1.AiOverviewFeedbackAction_Params.jsonDecode(t510.actionParams)
			end

			return v3795
		end

		t507.descriptor = {
			name = "AiOverviewFeedbackAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.AiOverviewFeedbackAction"
		}
		t1.AiOverviewFeedbackAction = t507
	end

	typeRegistry.default:register(t1.AiOverviewFeedbackAction)

	do
		local t511 = {}

		t511.__index = t511

		function t511.new(t512: {[any]: any}?) -- line: 24460
			-- upvalues: t511 (copy)
			return (setmetatable({
				sentiment = if t512 ~= nil and t512.sentiment ~= nil then t512.sentiment else nil,
				dialog_title = if t512 ~= nil and t512.dialog_title ~= nil then t512.dialog_title else nil,
				dialog_text = if t512 ~= nil and t512.dialog_text ~= nil then t512.dialog_text else nil,
				placeholder_text = if t512 ~= nil and t512.placeholder_text ~= nil then t512.placeholder_text else nil
			}, t511))
		end
		function t511.encode(p385) -- line: 24471
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n254 = 0

			if p385.sentiment ~= nil then
				local v3800 = p385.sentiment:encode()
				local v3801, v3802 = proto.writeTag(buf, n254, 1, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3801, v3802, v3800, buffer.len(v3800))
			end

			if p385.dialog_title ~= nil then
				local v3803 = p385.dialog_title:encode()
				local v3804, v3805 = proto.writeTag(buf, n254, 2, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3804, v3805, v3803, buffer.len(v3803))
			end

			if p385.dialog_text ~= nil then
				local v3806 = p385.dialog_text:encode()
				local v3807, v3808 = proto.writeTag(buf, n254, 3, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3807, v3808, v3806, buffer.len(v3806))
			end

			if p385.placeholder_text ~= nil then
				local v3809 = p385.placeholder_text:encode()
				local v3810, v3811 = proto.writeTag(buf, n254, 4, proto.wireTypes.lengthDelimited)

				buf, n254 = proto.writeBuffer(v3810, v3811, v3809, buffer.len(v3809))
			end

			local buf130 = buffer.create(n254)

			buffer.copy(buf130, 0, buf, 0, n254)

			return buf130
		end
		function t511.decode(p386: buffer) -- line: 24504
			-- upvalues: t511 (copy), proto (copy), prop_types (copy)
			local v3814 = t511.new()
			local n255 = 0

			while n255 < buffer.len(p386) do
				local v3816, v3817

				v3816, v3817, n255 = proto.readTag(p386, n255)

				if v3817 == proto.wireTypes.varint then
					local v3818

					v3818, n255 = proto.readVarInt(p386, n255)
				elseif v3817 == proto.wireTypes.lengthDelimited then
					if v3816 == 1 then
						local v3819

						v3819, n255 = proto.readBuffer(p386, n255)
						v3814.sentiment = prop_types.StringProp.decode(v3819)
					elseif v3816 == 2 then
						local v3820

						v3820, n255 = proto.readBuffer(p386, n255)
						v3814.dialog_title = prop_types.StringProp.decode(v3820)
					elseif v3816 == 3 then
						local v3821

						v3821, n255 = proto.readBuffer(p386, n255)
						v3814.dialog_text = prop_types.StringProp.decode(v3821)
					elseif v3816 == 4 then
						local v3822

						v3822, n255 = proto.readBuffer(p386, n255)
						v3814.placeholder_text = prop_types.StringProp.decode(v3822)
					else
						local v3823, v3824 = proto.readVarInt(p386, n255)

						n255 = v3824 + v3823
					end
				elseif v3817 == proto.wireTypes.i32 then
					local v3825

					v3825, n255 = proto.readFixed32(p386, n255)
				elseif v3817 == proto.wireTypes.i64 then
					local v3826

					v3826, n255 = proto.readFixed64(p386, n255)
				else
					error("Unsupported wire type: " .. v3817)
				end
			end

			return v3814
		end
		function t511.jsonEncode(p387) -- line: 24562
			local t513 = {}

			if p387.sentiment ~= nil then
				t513.sentiment = p387.sentiment:jsonEncode()
			end

			if p387.dialog_title ~= nil then
				t513.dialogTitle = p387.dialog_title:jsonEncode()
			end

			if p387.dialog_text ~= nil then
				t513.dialogText = p387.dialog_text:jsonEncode()
			end

			if p387.placeholder_text ~= nil then
				t513.placeholderText = p387.placeholder_text:jsonEncode()
			end

			return t513
		end
		function t511.jsonDecode(t514: {[any]: any}) -- line: 24584
			-- upvalues: t511 (copy), prop_types (copy)
			local v3830 = t511.new()

			if t514.sentiment ~= nil then
				v3830.sentiment = prop_types.StringProp.jsonDecode(t514.sentiment)
			end

			if t514.dialog_title ~= nil then
				v3830.dialog_title = prop_types.StringProp.jsonDecode(t514.dialog_title)
			end

			if t514.dialogTitle ~= nil then
				v3830.dialog_title = prop_types.StringProp.jsonDecode(t514.dialogTitle)
			end

			if t514.dialog_text ~= nil then
				v3830.dialog_text = prop_types.StringProp.jsonDecode(t514.dialog_text)
			end

			if t514.dialogText ~= nil then
				v3830.dialog_text = prop_types.StringProp.jsonDecode(t514.dialogText)
			end

			if t514.placeholder_text ~= nil then
				v3830.placeholder_text = prop_types.StringProp.jsonDecode(t514.placeholder_text)
			end

			if t514.placeholderText ~= nil then
				v3830.placeholder_text = prop_types.StringProp.jsonDecode(t514.placeholderText)
			end

			return v3830
		end

		t511.descriptor = {
			name = "AiOverviewFeedbackAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.AiOverviewFeedbackAction_Params = t511
		typeRegistry.default:register(t1.AiOverviewFeedbackAction_Params)

		local t515 = {}

		t515.__index = t515

		function t515.new(t516: {[any]: any}?) -- line: 24637
			-- upvalues: t1 (copy), t515 (copy)
			return (setmetatable({
				action_type = if t516 ~= nil and t516.action_type ~= nil then t516.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t516 ~= nil and t516.action_params ~= nil then t516.action_params else nil
			}, t515))
		end
		function t515.encode(p388) -- line: 24648
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n256 = 0

			if p388.action_type ~= nil and (p388.action_type ~= nil and p388.action_type ~= 0 or p388.action_type ~= t1.ActionType.fromNumber(0)) then
				local v3835, v3836 = proto.writeTag(buf, n256, 1, proto.wireTypes.varint)

				buf, n256 = proto.writeVarInt(v3835, v3836, t1.ActionType.toNumber(p388.action_type))
			end

			if p388.action_params ~= nil then
				local v3837 = p388.action_params:encode()
				local v3838, v3839 = proto.writeTag(buf, n256, 2, proto.wireTypes.lengthDelimited)

				buf, n256 = proto.writeBuffer(v3838, v3839, v3837, buffer.len(v3837))
			end

			local buf131 = buffer.create(n256)

			buffer.copy(buf131, 0, buf, 0, n256)

			return buf131
		end
		function t515.decode(p389: buffer) -- line: 24674
			-- upvalues: t515 (copy), proto (copy), t1 (copy)
			local v3842 = t515.new()
			local n257 = 0

			while n257 < buffer.len(p389) do
				local v3844, v3845

				v3844, v3845, n257 = proto.readTag(p389, n257)

				if v3845 == proto.wireTypes.varint then
					if v3844 == 1 then
						local v3846

						v3846, n257 = proto.readVarIntI32(p389, n257)
						v3842.action_type = t1.ActionType.fromNumber(v3846) or v3846
					else
						local v3847

						v3847, n257 = proto.readVarInt(p389, n257)
					end
				elseif v3845 == proto.wireTypes.lengthDelimited then
					if v3844 == 2 then
						local v3848

						v3848, n257 = proto.readBuffer(p389, n257)
						v3842.action_params = t1.EnableEventNotificationsAction_Params.decode(v3848)
					else
						local v3849, v3850 = proto.readVarInt(p389, n257)

						n257 = v3850 + v3849
					end
				elseif v3845 == proto.wireTypes.i32 then
					local v3851

					v3851, n257 = proto.readFixed32(p389, n257)
				elseif v3845 == proto.wireTypes.i64 then
					local v3852

					v3852, n257 = proto.readFixed64(p389, n257)
				else
					error("Unsupported wire type: " .. v3845)
				end
			end

			return v3842
		end
		function t515.jsonEncode(p390) -- line: 24722
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
		function t515.jsonDecode(t518: {[any]: any}) -- line: 24744
			-- upvalues: t515 (copy), t1 (copy)
			local v3856 = t515.new()

			if t518.action_type ~= nil then
				v3856.action_type = if typeof(t518.action_type) ~= "number" then t1.ActionType.fromName(t518.action_type) or t518.action_type else t1.ActionType.fromNumber(t518.action_type) or t518.action_type
			end

			if t518.actionType ~= nil then
				v3856.action_type = if typeof(t518.actionType) ~= "number" then t1.ActionType.fromName(t518.actionType) or t518.actionType else t1.ActionType.fromNumber(t518.actionType) or t518.actionType
			end

			if t518.action_params ~= nil then
				v3856.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t518.action_params)
			end

			if t518.actionParams ~= nil then
				v3856.action_params = t1.EnableEventNotificationsAction_Params.jsonDecode(t518.actionParams)
			end

			return v3856
		end

		t515.descriptor = {
			name = "EnableEventNotificationsAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.EnableEventNotificationsAction"
		}
		t1.EnableEventNotificationsAction = t515
	end

	typeRegistry.default:register(t1.EnableEventNotificationsAction)

	do
		local t519 = {}

		t519.__index = t519

		function t519.new(t520: {[any]: any}?) -- line: 24784
			-- upvalues: t519 (copy)
			return (setmetatable({
				event_id = if t520 ~= nil and t520.event_id ~= nil then t520.event_id else nil,
				universe_id = if t520 ~= nil and t520.universe_id ~= nil then t520.universe_id else nil,
				channel = if t520 ~= nil and t520.channel ~= nil then t520.channel else nil
			}, t519))
		end
		function t519.encode(p391) -- line: 24794
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n258 = 0

			if p391.event_id ~= nil then
				local v3861 = p391.event_id:encode()
				local v3862, v3863 = proto.writeTag(buf, n258, 1, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3862, v3863, v3861, buffer.len(v3861))
			end

			if p391.universe_id ~= nil then
				local v3864 = p391.universe_id:encode()
				local v3865, v3866 = proto.writeTag(buf, n258, 2, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3865, v3866, v3864, buffer.len(v3864))
			end

			if p391.channel ~= nil then
				local v3867 = p391.channel:encode()
				local v3868, v3869 = proto.writeTag(buf, n258, 3, proto.wireTypes.lengthDelimited)

				buf, n258 = proto.writeBuffer(v3868, v3869, v3867, buffer.len(v3867))
			end

			local buf132 = buffer.create(n258)

			buffer.copy(buf132, 0, buf, 0, n258)

			return buf132
		end
		function t519.decode(p392: buffer) -- line: 24821
			-- upvalues: t519 (copy), proto (copy), prop_types (copy)
			local v3872 = t519.new()
			local n259 = 0

			while n259 < buffer.len(p392) do
				local v3874, v3875

				v3874, v3875, n259 = proto.readTag(p392, n259)

				if v3875 == proto.wireTypes.varint then
					local v3876

					v3876, n259 = proto.readVarInt(p392, n259)
				elseif v3875 == proto.wireTypes.lengthDelimited then
					if v3874 == 1 then
						local v3877

						v3877, n259 = proto.readBuffer(p392, n259)
						v3872.event_id = prop_types.StringProp.decode(v3877)
					elseif v3874 == 2 then
						local v3878

						v3878, n259 = proto.readBuffer(p392, n259)
						v3872.universe_id = prop_types.StringProp.decode(v3878)
					elseif v3874 == 3 then
						local v3879

						v3879, n259 = proto.readBuffer(p392, n259)
						v3872.channel = prop_types.StringProp.decode(v3879)
					else
						local v3880, v3881 = proto.readVarInt(p392, n259)

						n259 = v3881 + v3880
					end
				elseif v3875 == proto.wireTypes.i32 then
					local v3882

					v3882, n259 = proto.readFixed32(p392, n259)
				elseif v3875 == proto.wireTypes.i64 then
					local v3883

					v3883, n259 = proto.readFixed64(p392, n259)
				else
					error("Unsupported wire type: " .. v3875)
				end
			end

			return v3872
		end
		function t519.jsonEncode(p393) -- line: 24874
			local t521 = {}

			if p393.event_id ~= nil then
				t521.eventId = p393.event_id:jsonEncode()
			end

			if p393.universe_id ~= nil then
				t521.universeId = p393.universe_id:jsonEncode()
			end

			if p393.channel ~= nil then
				t521.channel = p393.channel:jsonEncode()
			end

			return t521
		end
		function t519.jsonDecode(t522: {[any]: any}) -- line: 24892
			-- upvalues: t519 (copy), prop_types (copy)
			local v3887 = t519.new()

			if t522.event_id ~= nil then
				v3887.event_id = prop_types.StringProp.jsonDecode(t522.event_id)
			end

			if t522.eventId ~= nil then
				v3887.event_id = prop_types.StringProp.jsonDecode(t522.eventId)
			end

			if t522.universe_id ~= nil then
				v3887.universe_id = prop_types.StringProp.jsonDecode(t522.universe_id)
			end

			if t522.universeId ~= nil then
				v3887.universe_id = prop_types.StringProp.jsonDecode(t522.universeId)
			end

			if t522.channel ~= nil then
				v3887.channel = prop_types.StringProp.jsonDecode(t522.channel)
			end

			return v3887
		end

		t519.descriptor = {
			name = "EnableEventNotificationsAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.EnableEventNotificationsAction_Params = t519
		typeRegistry.default:register(t1.EnableEventNotificationsAction_Params)

		local t523 = {}

		t523.__index = t523

		function t523.new(t524: {[any]: any}?) -- line: 24935
			-- upvalues: t1 (copy), t523 (copy)
			return (setmetatable({
				action_type = if t524 ~= nil and t524.action_type ~= nil then t524.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t524 ~= nil and t524.action_params ~= nil then t524.action_params else nil
			}, t523))
		end
		function t523.encode(p394) -- line: 24946
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
		function t523.decode(p395: buffer) -- line: 24972
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
						v3899.action_params = t1.DismissEventNotificationsModalAction_Params.decode(v3905)
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
		function t523.jsonEncode(p396) -- line: 25020
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
		function t523.jsonDecode(t526: {[any]: any}) -- line: 25042
			-- upvalues: t523 (copy), t1 (copy)
			local v3913 = t523.new()

			if t526.action_type ~= nil then
				v3913.action_type = if typeof(t526.action_type) ~= "number" then t1.ActionType.fromName(t526.action_type) or t526.action_type else t1.ActionType.fromNumber(t526.action_type) or t526.action_type
			end

			if t526.actionType ~= nil then
				v3913.action_type = if typeof(t526.actionType) ~= "number" then t1.ActionType.fromName(t526.actionType) or t526.actionType else t1.ActionType.fromNumber(t526.actionType) or t526.actionType
			end

			if t526.action_params ~= nil then
				v3913.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t526.action_params)
			end

			if t526.actionParams ~= nil then
				v3913.action_params = t1.DismissEventNotificationsModalAction_Params.jsonDecode(t526.actionParams)
			end

			return v3913
		end

		t523.descriptor = {
			name = "DismissEventNotificationsModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissEventNotificationsModalAction"
		}
		t1.DismissEventNotificationsModalAction = t523
	end

	typeRegistry.default:register(t1.DismissEventNotificationsModalAction)

	do
		local t527 = {}

		t527.__index = t527

		function t527.new(t528: {[any]: any}?) -- line: 25084
			-- upvalues: t527 (copy)
			return (setmetatable({
				event_id = if t528 ~= nil and t528.event_id ~= nil then t528.event_id else nil
			}, t527))
		end
		function t527.encode(p397) -- line: 25092
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n262 = 0

			if p397.event_id ~= nil then
				local v3918 = p397.event_id:encode()
				local v3919, v3920 = proto.writeTag(buf, n262, 1, proto.wireTypes.lengthDelimited)

				buf, n262 = proto.writeBuffer(v3919, v3920, v3918, buffer.len(v3918))
			end

			local buf134 = buffer.create(n262)

			buffer.copy(buf134, 0, buf, 0, n262)

			return buf134
		end
		function t527.decode(p398: buffer) -- line: 25109
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
						v3923.event_id = prop_types.StringProp.decode(v3928)
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
		function t527.jsonEncode(p399) -- line: 25154
			local t529 = {}

			if p399.event_id ~= nil then
				t529.eventId = p399.event_id:jsonEncode()
			end

			return t529
		end
		function t527.jsonDecode(t530: {[any]: any}) -- line: 25166
			-- upvalues: t527 (copy), prop_types (copy)
			local v3936 = t527.new()

			if t530.event_id ~= nil then
				v3936.event_id = prop_types.StringProp.jsonDecode(t530.event_id)
			end

			if t530.eventId ~= nil then
				v3936.event_id = prop_types.StringProp.jsonDecode(t530.eventId)
			end

			return v3936
		end

		t527.descriptor = {
			name = "DismissEventNotificationsModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissEventNotificationsModalAction_Params = t527
		typeRegistry.default:register(t1.DismissEventNotificationsModalAction_Params)

		local t531 = {}

		t531.__index = t531

		function t531.new(t532: {[any]: any}?) -- line: 25196
			-- upvalues: t1 (copy), t531 (copy)
			return (setmetatable({
				action_type = if t532 ~= nil and t532.action_type ~= nil then t532.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t532 ~= nil and t532.action_params ~= nil then t532.action_params else nil
			}, t531))
		end
		function t531.encode(p400) -- line: 25205
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
		function t531.decode(p401: buffer) -- line: 25231
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
						v3948.action_params = t1.OpenAmpWizardAction_Params.decode(v3954)
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
		function t531.jsonEncode(p402) -- line: 25279
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
		function t531.jsonDecode(t534: {[any]: any}) -- line: 25301
			-- upvalues: t531 (copy), t1 (copy)
			local v3962 = t531.new()

			if t534.action_type ~= nil then
				v3962.action_type = if typeof(t534.action_type) ~= "number" then t1.ActionType.fromName(t534.action_type) or t534.action_type else t1.ActionType.fromNumber(t534.action_type) or t534.action_type
			end

			if t534.actionType ~= nil then
				v3962.action_type = if typeof(t534.actionType) ~= "number" then t1.ActionType.fromName(t534.actionType) or t534.actionType else t1.ActionType.fromNumber(t534.actionType) or t534.actionType
			end

			if t534.action_params ~= nil then
				v3962.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t534.action_params)
			end

			if t534.actionParams ~= nil then
				v3962.action_params = t1.OpenAmpWizardAction_Params.jsonDecode(t534.actionParams)
			end

			return v3962
		end

		t531.descriptor = {
			name = "OpenAmpWizardAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenAmpWizardAction"
		}
		t1.OpenAmpWizardAction = t531
	end

	typeRegistry.default:register(t1.OpenAmpWizardAction)

	do
		local t535 = {}

		t535.__index = t535

		function t535.new(t536: {[any]: any}?) -- line: 25341
			-- upvalues: t535 (copy)
			return (setmetatable({
				feature_name = if t536 ~= nil and t536.feature_name ~= nil then t536.feature_name else nil,
				name_space = if t536 ~= nil and t536.name_space ~= nil then t536.name_space else nil,
				entry_point_event_ctx = if t536 ~= nil and t536.entry_point_event_ctx ~= nil then t536.entry_point_event_ctx else nil,
				skip_facial_age_estimation_web_link_modal = if t536 ~= nil and t536.skip_facial_age_estimation_web_link_modal ~= nil then t536.skip_facial_age_estimation_web_link_modal else nil
			}, t535))
		end
		function t535.encode(p403) -- line: 25357
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n266 = 0

			if p403.feature_name ~= nil then
				local v3967 = p403.feature_name:encode()
				local v3968, v3969 = proto.writeTag(buf, n266, 1, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3968, v3969, v3967, buffer.len(v3967))
			end

			if p403.name_space ~= nil then
				local v3970 = p403.name_space:encode()
				local v3971, v3972 = proto.writeTag(buf, n266, 2, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3971, v3972, v3970, buffer.len(v3970))
			end

			if p403.entry_point_event_ctx ~= nil then
				local v3973 = p403.entry_point_event_ctx:encode()
				local v3974, v3975 = proto.writeTag(buf, n266, 3, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3974, v3975, v3973, buffer.len(v3973))
			end

			if p403.skip_facial_age_estimation_web_link_modal ~= nil then
				local v3976 = p403.skip_facial_age_estimation_web_link_modal:encode()
				local v3977, v3978 = proto.writeTag(buf, n266, 4, proto.wireTypes.lengthDelimited)

				buf, n266 = proto.writeBuffer(v3977, v3978, v3976, buffer.len(v3976))
			end

			local buf136 = buffer.create(n266)

			buffer.copy(buf136, 0, buf, 0, n266)

			return buf136
		end
		function t535.decode(p404: buffer) -- line: 25390
			-- upvalues: t535 (copy), proto (copy), prop_types (copy)
			local v3981 = t535.new()
			local n267 = 0

			while n267 < buffer.len(p404) do
				local v3983, v3984

				v3983, v3984, n267 = proto.readTag(p404, n267)

				if v3984 == proto.wireTypes.varint then
					local v3985

					v3985, n267 = proto.readVarInt(p404, n267)
				elseif v3984 == proto.wireTypes.lengthDelimited then
					if v3983 == 1 then
						local v3986

						v3986, n267 = proto.readBuffer(p404, n267)
						v3981.feature_name = prop_types.StringProp.decode(v3986)
					elseif v3983 == 2 then
						local v3987

						v3987, n267 = proto.readBuffer(p404, n267)
						v3981.name_space = prop_types.StringProp.decode(v3987)
					elseif v3983 == 3 then
						local v3988

						v3988, n267 = proto.readBuffer(p404, n267)
						v3981.entry_point_event_ctx = prop_types.StringProp.decode(v3988)
					elseif v3983 == 4 then
						local v3989

						v3989, n267 = proto.readBuffer(p404, n267)
						v3981.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.decode(v3989)
					else
						local v3990, v3991 = proto.readVarInt(p404, n267)

						n267 = v3991 + v3990
					end
				elseif v3984 == proto.wireTypes.i32 then
					local v3992

					v3992, n267 = proto.readFixed32(p404, n267)
				elseif v3984 == proto.wireTypes.i64 then
					local v3993

					v3993, n267 = proto.readFixed64(p404, n267)
				else
					error("Unsupported wire type: " .. v3984)
				end
			end

			return v3981
		end
		function t535.jsonEncode(p405) -- line: 25450
			local t537 = {}

			if p405.feature_name ~= nil then
				t537.featureName = p405.feature_name:jsonEncode()
			end

			if p405.name_space ~= nil then
				t537.nameSpace = p405.name_space:jsonEncode()
			end

			if p405.entry_point_event_ctx ~= nil then
				t537.entryPointEventCtx = p405.entry_point_event_ctx:jsonEncode()
			end

			if p405.skip_facial_age_estimation_web_link_modal ~= nil then
				t537.skipFacialAgeEstimationWebLinkModal = p405.skip_facial_age_estimation_web_link_modal:jsonEncode()
			end

			return t537
		end
		function t535.jsonDecode(t538: {[any]: any}) -- line: 25472
			-- upvalues: t535 (copy), prop_types (copy)
			local v3997 = t535.new()

			if t538.feature_name ~= nil then
				v3997.feature_name = prop_types.StringProp.jsonDecode(t538.feature_name)
			end

			if t538.featureName ~= nil then
				v3997.feature_name = prop_types.StringProp.jsonDecode(t538.featureName)
			end

			if t538.name_space ~= nil then
				v3997.name_space = prop_types.StringProp.jsonDecode(t538.name_space)
			end

			if t538.nameSpace ~= nil then
				v3997.name_space = prop_types.StringProp.jsonDecode(t538.nameSpace)
			end

			if t538.entry_point_event_ctx ~= nil then
				v3997.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t538.entry_point_event_ctx)
			end

			if t538.entryPointEventCtx ~= nil then
				v3997.entry_point_event_ctx = prop_types.StringProp.jsonDecode(t538.entryPointEventCtx)
			end

			if t538.skip_facial_age_estimation_web_link_modal ~= nil then
				v3997.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t538.skip_facial_age_estimation_web_link_modal)
			end

			if t538.skipFacialAgeEstimationWebLinkModal ~= nil then
				v3997.skip_facial_age_estimation_web_link_modal = prop_types.BoolProp.jsonDecode(t538.skipFacialAgeEstimationWebLinkModal)
			end

			return v3997
		end

		t535.descriptor = {
			name = "OpenAmpWizardAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenAmpWizardAction_Params = t535
		typeRegistry.default:register(t1.OpenAmpWizardAction_Params)

		local t539 = {}

		t539.__index = t539

		function t539.new(t540: {[any]: any}?) -- line: 25534
			-- upvalues: t1 (copy), t539 (copy)
			return (setmetatable({
				action_type = if t540 ~= nil and t540.action_type ~= nil then t540.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t540 ~= nil and t540.action_params ~= nil then t540.action_params else nil
			}, t539))
		end
		function t539.encode(p406) -- line: 25545
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n268 = 0

			if p406.action_type ~= nil and (p406.action_type ~= nil and p406.action_type ~= 0 or p406.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4002, v4003 = proto.writeTag(buf, n268, 1, proto.wireTypes.varint)

				buf, n268 = proto.writeVarInt(v4002, v4003, t1.ActionType.toNumber(p406.action_type))
			end

			if p406.action_params ~= nil then
				local v4004 = p406.action_params:encode()
				local v4005, v4006 = proto.writeTag(buf, n268, 2, proto.wireTypes.lengthDelimited)

				buf, n268 = proto.writeBuffer(v4005, v4006, v4004, buffer.len(v4004))
			end

			local buf137 = buffer.create(n268)

			buffer.copy(buf137, 0, buf, 0, n268)

			return buf137
		end
		function t539.decode(p407: buffer) -- line: 25571
			-- upvalues: t539 (copy), proto (copy), t1 (copy)
			local v4009 = t539.new()
			local n269 = 0

			while n269 < buffer.len(p407) do
				local v4011, v4012

				v4011, v4012, n269 = proto.readTag(p407, n269)

				if v4012 == proto.wireTypes.varint then
					if v4011 == 1 then
						local v4013

						v4013, n269 = proto.readVarIntI32(p407, n269)
						v4009.action_type = t1.ActionType.fromNumber(v4013) or v4013
					else
						local v4014

						v4014, n269 = proto.readVarInt(p407, n269)
					end
				elseif v4012 == proto.wireTypes.lengthDelimited then
					if v4011 == 2 then
						local v4015

						v4015, n269 = proto.readBuffer(p407, n269)
						v4009.action_params = t1.OpenSocialProofUserListSheetAction_Params.decode(v4015)
					else
						local v4016, v4017 = proto.readVarInt(p407, n269)

						n269 = v4017 + v4016
					end
				elseif v4012 == proto.wireTypes.i32 then
					local v4018

					v4018, n269 = proto.readFixed32(p407, n269)
				elseif v4012 == proto.wireTypes.i64 then
					local v4019

					v4019, n269 = proto.readFixed64(p407, n269)
				else
					error("Unsupported wire type: " .. v4012)
				end
			end

			return v4009
		end
		function t539.jsonEncode(p408) -- line: 25619
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
		function t539.jsonDecode(t542: {[any]: any}) -- line: 25641
			-- upvalues: t539 (copy), t1 (copy)
			local v4023 = t539.new()

			if t542.action_type ~= nil then
				v4023.action_type = if typeof(t542.action_type) ~= "number" then t1.ActionType.fromName(t542.action_type) or t542.action_type else t1.ActionType.fromNumber(t542.action_type) or t542.action_type
			end

			if t542.actionType ~= nil then
				v4023.action_type = if typeof(t542.actionType) ~= "number" then t1.ActionType.fromName(t542.actionType) or t542.actionType else t1.ActionType.fromNumber(t542.actionType) or t542.actionType
			end

			if t542.action_params ~= nil then
				v4023.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t542.action_params)
			end

			if t542.actionParams ~= nil then
				v4023.action_params = t1.OpenSocialProofUserListSheetAction_Params.jsonDecode(t542.actionParams)
			end

			return v4023
		end

		t539.descriptor = {
			name = "OpenSocialProofUserListSheetAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSocialProofUserListSheetAction"
		}
		t1.OpenSocialProofUserListSheetAction = t539
	end

	typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction)

	do
		local t543 = {}

		t543.__index = t543

		function t543.new(t544: {[any]: any}?) -- line: 25683
			-- upvalues: t543 (copy)
			return (setmetatable({
				universe_id = if t544 ~= nil and t544.universe_id ~= nil then t544.universe_id else nil,
				place_id = if t544 ~= nil and t544.place_id ~= nil then t544.place_id else nil,
				total_connections = if t544 ~= nil and t544.total_connections ~= nil then t544.total_connections else nil,
				user_ids = if t544 ~= nil and t544.user_ids ~= nil then t544.user_ids else nil,
				sheet_title = if t544 ~= nil and t544.sheet_title ~= nil then t544.sheet_title else nil
			}, t543))
		end
		function t543.encode(p409) -- line: 25695
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n270 = 0

			if p409.universe_id ~= nil then
				local v4028 = p409.universe_id:encode()
				local v4029, v4030 = proto.writeTag(buf, n270, 1, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4029, v4030, v4028, buffer.len(v4028))
			end

			if p409.place_id ~= nil then
				local v4031 = p409.place_id:encode()
				local v4032, v4033 = proto.writeTag(buf, n270, 2, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4032, v4033, v4031, buffer.len(v4031))
			end

			if p409.total_connections ~= nil then
				local v4034 = p409.total_connections:encode()
				local v4035, v4036 = proto.writeTag(buf, n270, 3, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4035, v4036, v4034, buffer.len(v4034))
			end

			if p409.user_ids ~= nil then
				local v4037 = p409.user_ids:encode()
				local v4038, v4039 = proto.writeTag(buf, n270, 4, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4038, v4039, v4037, buffer.len(v4037))
			end

			if p409.sheet_title ~= nil then
				local v4040 = p409.sheet_title:encode()
				local v4041, v4042 = proto.writeTag(buf, n270, 5, proto.wireTypes.lengthDelimited)

				buf, n270 = proto.writeBuffer(v4041, v4042, v4040, buffer.len(v4040))
			end

			local buf138 = buffer.create(n270)

			buffer.copy(buf138, 0, buf, 0, n270)

			return buf138
		end
		function t543.decode(p410: buffer) -- line: 25736
			-- upvalues: t543 (copy), proto (copy), prop_types (copy)
			local v4045 = t543.new()
			local n271 = 0

			while n271 < buffer.len(p410) do
				local v4047, v4048

				v4047, v4048, n271 = proto.readTag(p410, n271)

				if v4048 == proto.wireTypes.varint then
					local v4049

					v4049, n271 = proto.readVarInt(p410, n271)
				elseif v4048 == proto.wireTypes.lengthDelimited then
					if v4047 == 1 then
						local v4050

						v4050, n271 = proto.readBuffer(p410, n271)
						v4045.universe_id = prop_types.StringProp.decode(v4050)
					elseif v4047 == 2 then
						local v4051

						v4051, n271 = proto.readBuffer(p410, n271)
						v4045.place_id = prop_types.StringProp.decode(v4051)
					elseif v4047 == 3 then
						local v4052

						v4052, n271 = proto.readBuffer(p410, n271)
						v4045.total_connections = prop_types.Int32Prop.decode(v4052)
					elseif v4047 == 4 then
						local v4053

						v4053, n271 = proto.readBuffer(p410, n271)
						v4045.user_ids = prop_types.ArrayOfAvatarProp.decode(v4053)
					elseif v4047 == 5 then
						local v4054

						v4054, n271 = proto.readBuffer(p410, n271)
						v4045.sheet_title = prop_types.StringProp.decode(v4054)
					else
						local v4055, v4056 = proto.readVarInt(p410, n271)

						n271 = v4056 + v4055
					end
				elseif v4048 == proto.wireTypes.i32 then
					local v4057

					v4057, n271 = proto.readFixed32(p410, n271)
				elseif v4048 == proto.wireTypes.i64 then
					local v4058

					v4058, n271 = proto.readFixed64(p410, n271)
				else
					error("Unsupported wire type: " .. v4048)
				end
			end

			return v4045
		end
		function t543.jsonEncode(p411) -- line: 25801
			local t545 = {}

			if p411.universe_id ~= nil then
				t545.universeId = p411.universe_id:jsonEncode()
			end

			if p411.place_id ~= nil then
				t545.placeId = p411.place_id:jsonEncode()
			end

			if p411.total_connections ~= nil then
				t545.totalConnections = p411.total_connections:jsonEncode()
			end

			if p411.user_ids ~= nil then
				t545.userIds = p411.user_ids:jsonEncode()
			end

			if p411.sheet_title ~= nil then
				t545.sheetTitle = p411.sheet_title:jsonEncode()
			end

			return t545
		end
		function t543.jsonDecode(t546: {[any]: any}) -- line: 25829
			-- upvalues: t543 (copy), prop_types (copy)
			local v4062 = t543.new()

			if t546.universe_id ~= nil then
				v4062.universe_id = prop_types.StringProp.jsonDecode(t546.universe_id)
			end

			if t546.universeId ~= nil then
				v4062.universe_id = prop_types.StringProp.jsonDecode(t546.universeId)
			end

			if t546.place_id ~= nil then
				v4062.place_id = prop_types.StringProp.jsonDecode(t546.place_id)
			end

			if t546.placeId ~= nil then
				v4062.place_id = prop_types.StringProp.jsonDecode(t546.placeId)
			end

			if t546.total_connections ~= nil then
				v4062.total_connections = prop_types.Int32Prop.jsonDecode(t546.total_connections)
			end

			if t546.totalConnections ~= nil then
				v4062.total_connections = prop_types.Int32Prop.jsonDecode(t546.totalConnections)
			end

			if t546.user_ids ~= nil then
				v4062.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t546.user_ids)
			end

			if t546.userIds ~= nil then
				v4062.user_ids = prop_types.ArrayOfAvatarProp.jsonDecode(t546.userIds)
			end

			if t546.sheet_title ~= nil then
				v4062.sheet_title = prop_types.StringProp.jsonDecode(t546.sheet_title)
			end

			if t546.sheetTitle ~= nil then
				v4062.sheet_title = prop_types.StringProp.jsonDecode(t546.sheetTitle)
			end

			return v4062
		end

		t543.descriptor = {
			name = "OpenSocialProofUserListSheetAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSocialProofUserListSheetAction_Params = t543
		typeRegistry.default:register(t1.OpenSocialProofUserListSheetAction_Params)

		local t547 = {}

		t547.__index = t547

		function t547.new(t548: {[any]: any}?) -- line: 25897
			-- upvalues: t1 (copy), t547 (copy)
			return (setmetatable({
				action_type = if t548 ~= nil and t548.action_type ~= nil then t548.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t548 ~= nil and t548.action_params ~= nil then t548.action_params else nil
			}, t547))
		end
		function t547.encode(p412) -- line: 25908
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n272 = 0

			if p412.action_type ~= nil and (p412.action_type ~= nil and p412.action_type ~= 0 or p412.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4067, v4068 = proto.writeTag(buf, n272, 1, proto.wireTypes.varint)

				buf, n272 = proto.writeVarInt(v4067, v4068, t1.ActionType.toNumber(p412.action_type))
			end

			if p412.action_params ~= nil then
				local v4069 = p412.action_params:encode()
				local v4070, v4071 = proto.writeTag(buf, n272, 2, proto.wireTypes.lengthDelimited)

				buf, n272 = proto.writeBuffer(v4070, v4071, v4069, buffer.len(v4069))
			end

			local buf139 = buffer.create(n272)

			buffer.copy(buf139, 0, buf, 0, n272)

			return buf139
		end
		function t547.decode(p413: buffer) -- line: 25934
			-- upvalues: t547 (copy), proto (copy), t1 (copy)
			local v4074 = t547.new()
			local n273 = 0

			while n273 < buffer.len(p413) do
				local v4076, v4077

				v4076, v4077, n273 = proto.readTag(p413, n273)

				if v4077 == proto.wireTypes.varint then
					if v4076 == 1 then
						local v4078

						v4078, n273 = proto.readVarIntI32(p413, n273)
						v4074.action_type = t1.ActionType.fromNumber(v4078) or v4078
					else
						local v4079

						v4079, n273 = proto.readVarInt(p413, n273)
					end
				elseif v4077 == proto.wireTypes.lengthDelimited then
					if v4076 == 2 then
						local v4080

						v4080, n273 = proto.readBuffer(p413, n273)
						v4074.action_params = t1.OpenSearchResultsTabAction_Params.decode(v4080)
					else
						local v4081, v4082 = proto.readVarInt(p413, n273)

						n273 = v4082 + v4081
					end
				elseif v4077 == proto.wireTypes.i32 then
					local v4083

					v4083, n273 = proto.readFixed32(p413, n273)
				elseif v4077 == proto.wireTypes.i64 then
					local v4084

					v4084, n273 = proto.readFixed64(p413, n273)
				else
					error("Unsupported wire type: " .. v4077)
				end
			end

			return v4074
		end
		function t547.jsonEncode(p414) -- line: 25982
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
		function t547.jsonDecode(t550: {[any]: any}) -- line: 26004
			-- upvalues: t547 (copy), t1 (copy)
			local v4088 = t547.new()

			if t550.action_type ~= nil then
				v4088.action_type = if typeof(t550.action_type) ~= "number" then t1.ActionType.fromName(t550.action_type) or t550.action_type else t1.ActionType.fromNumber(t550.action_type) or t550.action_type
			end

			if t550.actionType ~= nil then
				v4088.action_type = if typeof(t550.actionType) ~= "number" then t1.ActionType.fromName(t550.actionType) or t550.actionType else t1.ActionType.fromNumber(t550.actionType) or t550.actionType
			end

			if t550.action_params ~= nil then
				v4088.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t550.action_params)
			end

			if t550.actionParams ~= nil then
				v4088.action_params = t1.OpenSearchResultsTabAction_Params.jsonDecode(t550.actionParams)
			end

			return v4088
		end

		t547.descriptor = {
			name = "OpenSearchResultsTabAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsTabAction"
		}
		t1.OpenSearchResultsTabAction = t547
	end

	typeRegistry.default:register(t1.OpenSearchResultsTabAction)

	do
		local t551 = {}

		t551.__index = t551

		function t551.new(t552: {[any]: any}?) -- line: 26044
			-- upvalues: t551 (copy)
			return (setmetatable({
				search_type = if t552 ~= nil and t552.search_type ~= nil then t552.search_type else nil
			}, t551))
		end
		function t551.encode(p415) -- line: 26052
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n274 = 0

			if p415.search_type ~= nil then
				local v4093 = p415.search_type:encode()
				local v4094, v4095 = proto.writeTag(buf, n274, 1, proto.wireTypes.lengthDelimited)

				buf, n274 = proto.writeBuffer(v4094, v4095, v4093, buffer.len(v4093))
			end

			local buf140 = buffer.create(n274)

			buffer.copy(buf140, 0, buf, 0, n274)

			return buf140
		end
		function t551.decode(p416: buffer) -- line: 26067
			-- upvalues: t551 (copy), proto (copy), prop_types (copy)
			local v4098 = t551.new()
			local n275 = 0

			while n275 < buffer.len(p416) do
				local v4100, v4101

				v4100, v4101, n275 = proto.readTag(p416, n275)

				if v4101 == proto.wireTypes.varint then
					local v4102

					v4102, n275 = proto.readVarInt(p416, n275)
				elseif v4101 == proto.wireTypes.lengthDelimited then
					if v4100 == 1 then
						local v4103

						v4103, n275 = proto.readBuffer(p416, n275)
						v4098.search_type = prop_types.StringProp.decode(v4103)
					else
						local v4104, v4105 = proto.readVarInt(p416, n275)

						n275 = v4105 + v4104
					end
				elseif v4101 == proto.wireTypes.i32 then
					local v4106

					v4106, n275 = proto.readFixed32(p416, n275)
				elseif v4101 == proto.wireTypes.i64 then
					local v4107

					v4107, n275 = proto.readFixed64(p416, n275)
				else
					error("Unsupported wire type: " .. v4101)
				end
			end

			return v4098
		end
		function t551.jsonEncode(p417) -- line: 26110
			local t553 = {}

			if p417.search_type ~= nil then
				t553.searchType = p417.search_type:jsonEncode()
			end

			return t553
		end
		function t551.jsonDecode(t554: {[any]: any}) -- line: 26120
			-- upvalues: t551 (copy), prop_types (copy)
			local v4111 = t551.new()

			if t554.search_type ~= nil then
				v4111.search_type = prop_types.StringProp.jsonDecode(t554.search_type)
			end

			if t554.searchType ~= nil then
				v4111.search_type = prop_types.StringProp.jsonDecode(t554.searchType)
			end

			return v4111
		end

		t551.descriptor = {
			name = "OpenSearchResultsTabAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsTabAction_Params = t551
		typeRegistry.default:register(t1.OpenSearchResultsTabAction_Params)

		local t555 = {}

		t555.__index = t555

		function t555.new(t556: {[any]: any}?) -- line: 26151
			-- upvalues: t1 (copy), t555 (copy)
			return (setmetatable({
				action_type = if t556 ~= nil and t556.action_type ~= nil then t556.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t556 ~= nil and t556.action_params ~= nil then t556.action_params else nil
			}, t555))
		end
		function t555.encode(p418) -- line: 26160
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n276 = 0

			if p418.action_type ~= nil and (p418.action_type ~= nil and p418.action_type ~= 0 or p418.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4116, v4117 = proto.writeTag(buf, n276, 1, proto.wireTypes.varint)

				buf, n276 = proto.writeVarInt(v4116, v4117, t1.ActionType.toNumber(p418.action_type))
			end

			if p418.action_params ~= nil then
				local v4118 = p418.action_params:encode()
				local v4119, v4120 = proto.writeTag(buf, n276, 2, proto.wireTypes.lengthDelimited)

				buf, n276 = proto.writeBuffer(v4119, v4120, v4118, buffer.len(v4118))
			end

			local buf141 = buffer.create(n276)

			buffer.copy(buf141, 0, buf, 0, n276)

			return buf141
		end
		function t555.decode(p419: buffer) -- line: 26186
			-- upvalues: t555 (copy), proto (copy), t1 (copy)
			local v4123 = t555.new()
			local n277 = 0

			while n277 < buffer.len(p419) do
				local v4125, v4126

				v4125, v4126, n277 = proto.readTag(p419, n277)

				if v4126 == proto.wireTypes.varint then
					if v4125 == 1 then
						local v4127

						v4127, n277 = proto.readVarIntI32(p419, n277)
						v4123.action_type = t1.ActionType.fromNumber(v4127) or v4127
					else
						local v4128

						v4128, n277 = proto.readVarInt(p419, n277)
					end
				elseif v4126 == proto.wireTypes.lengthDelimited then
					if v4125 == 2 then
						local v4129

						v4129, n277 = proto.readBuffer(p419, n277)
						v4123.action_params = t1.DismissPromptAction_Params.decode(v4129)
					else
						local v4130, v4131 = proto.readVarInt(p419, n277)

						n277 = v4131 + v4130
					end
				elseif v4126 == proto.wireTypes.i32 then
					local v4132

					v4132, n277 = proto.readFixed32(p419, n277)
				elseif v4126 == proto.wireTypes.i64 then
					local v4133

					v4133, n277 = proto.readFixed64(p419, n277)
				else
					error("Unsupported wire type: " .. v4126)
				end
			end

			return v4123
		end
		function t555.jsonEncode(p420) -- line: 26234
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
		function t555.jsonDecode(t558: {[any]: any}) -- line: 26256
			-- upvalues: t555 (copy), t1 (copy)
			local v4137 = t555.new()

			if t558.action_type ~= nil then
				v4137.action_type = if typeof(t558.action_type) ~= "number" then t1.ActionType.fromName(t558.action_type) or t558.action_type else t1.ActionType.fromNumber(t558.action_type) or t558.action_type
			end

			if t558.actionType ~= nil then
				v4137.action_type = if typeof(t558.actionType) ~= "number" then t1.ActionType.fromName(t558.actionType) or t558.actionType else t1.ActionType.fromNumber(t558.actionType) or t558.actionType
			end

			if t558.action_params ~= nil then
				v4137.action_params = t1.DismissPromptAction_Params.jsonDecode(t558.action_params)
			end

			if t558.actionParams ~= nil then
				v4137.action_params = t1.DismissPromptAction_Params.jsonDecode(t558.actionParams)
			end

			return v4137
		end

		t555.descriptor = {
			name = "DismissPromptAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DismissPromptAction"
		}
		t1.DismissPromptAction = t555
	end

	typeRegistry.default:register(t1.DismissPromptAction)

	do
		local t559 = {}

		t559.__index = t559

		function t559.new(t560: {[any]: any}?) -- line: 26296
			-- upvalues: t559 (copy)
			return (setmetatable({
				prompt_type = if t560 ~= nil and t560.prompt_type ~= nil then t560.prompt_type else nil,
				prompt_id = if t560 ~= nil and t560.prompt_id ~= nil then t560.prompt_id else nil
			}, t559))
		end
		function t559.encode(p421) -- line: 26305
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n278 = 0

			if p421.prompt_type ~= nil then
				local v4142 = p421.prompt_type:encode()
				local v4143, v4144 = proto.writeTag(buf, n278, 1, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4143, v4144, v4142, buffer.len(v4142))
			end

			if p421.prompt_id ~= nil then
				local v4145 = p421.prompt_id:encode()
				local v4146, v4147 = proto.writeTag(buf, n278, 2, proto.wireTypes.lengthDelimited)

				buf, n278 = proto.writeBuffer(v4146, v4147, v4145, buffer.len(v4145))
			end

			local buf142 = buffer.create(n278)

			buffer.copy(buf142, 0, buf, 0, n278)

			return buf142
		end
		function t559.decode(p422: buffer) -- line: 26326
			-- upvalues: t559 (copy), proto (copy), prop_types (copy)
			local v4150 = t559.new()
			local n279 = 0

			while n279 < buffer.len(p422) do
				local v4152, v4153

				v4152, v4153, n279 = proto.readTag(p422, n279)

				if v4153 == proto.wireTypes.varint then
					local v4154

					v4154, n279 = proto.readVarInt(p422, n279)
				elseif v4153 == proto.wireTypes.lengthDelimited then
					if v4152 == 1 then
						local v4155

						v4155, n279 = proto.readBuffer(p422, n279)
						v4150.prompt_type = prop_types.StringProp.decode(v4155)
					elseif v4152 == 2 then
						local v4156

						v4156, n279 = proto.readBuffer(p422, n279)
						v4150.prompt_id = prop_types.StringProp.decode(v4156)
					else
						local v4157, v4158 = proto.readVarInt(p422, n279)

						n279 = v4158 + v4157
					end
				elseif v4153 == proto.wireTypes.i32 then
					local v4159

					v4159, n279 = proto.readFixed32(p422, n279)
				elseif v4153 == proto.wireTypes.i64 then
					local v4160

					v4160, n279 = proto.readFixed64(p422, n279)
				else
					error("Unsupported wire type: " .. v4153)
				end
			end

			return v4150
		end
		function t559.jsonEncode(p423) -- line: 26374
			local t561 = {}

			if p423.prompt_type ~= nil then
				t561.promptType = p423.prompt_type:jsonEncode()
			end

			if p423.prompt_id ~= nil then
				t561.promptId = p423.prompt_id:jsonEncode()
			end

			return t561
		end
		function t559.jsonDecode(t562: {[any]: any}) -- line: 26388
			-- upvalues: t559 (copy), prop_types (copy)
			local v4164 = t559.new()

			if t562.prompt_type ~= nil then
				v4164.prompt_type = prop_types.StringProp.jsonDecode(t562.prompt_type)
			end

			if t562.promptType ~= nil then
				v4164.prompt_type = prop_types.StringProp.jsonDecode(t562.promptType)
			end

			if t562.prompt_id ~= nil then
				v4164.prompt_id = prop_types.StringProp.jsonDecode(t562.prompt_id)
			end

			if t562.promptId ~= nil then
				v4164.prompt_id = prop_types.StringProp.jsonDecode(t562.promptId)
			end

			return v4164
		end

		t559.descriptor = {
			name = "DismissPromptAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.DismissPromptAction_Params = t559
		typeRegistry.default:register(t1.DismissPromptAction_Params)

		local t563 = {}

		t563.__index = t563

		function t563.new(t564: {[any]: any}?) -- line: 26426
			-- upvalues: t1 (copy), t563 (copy)
			return (setmetatable({
				action_type = if t564 ~= nil and t564.action_type ~= nil then t564.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t564 ~= nil and t564.action_params ~= nil then t564.action_params else nil
			}, t563))
		end
		function t563.encode(p424) -- line: 26440
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n280 = 0

			if p424.action_type ~= nil and (p424.action_type ~= nil and p424.action_type ~= 0 or p424.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4169, v4170 = proto.writeTag(buf, n280, 1, proto.wireTypes.varint)

				buf, n280 = proto.writeVarInt(v4169, v4170, t1.ActionType.toNumber(p424.action_type))
			end

			if p424.action_params ~= nil then
				local v4171 = p424.action_params:encode()
				local v4172, v4173 = proto.writeTag(buf, n280, 2, proto.wireTypes.lengthDelimited)

				buf, n280 = proto.writeBuffer(v4172, v4173, v4171, buffer.len(v4171))
			end

			local buf143 = buffer.create(n280)

			buffer.copy(buf143, 0, buf, 0, n280)

			return buf143
		end
		function t563.decode(p425: buffer) -- line: 26468
			-- upvalues: t563 (copy), proto (copy), t1 (copy)
			local v4176 = t563.new()
			local n281 = 0

			while n281 < buffer.len(p425) do
				local v4178, v4179

				v4178, v4179, n281 = proto.readTag(p425, n281)

				if v4179 == proto.wireTypes.varint then
					if v4178 == 1 then
						local v4180

						v4180, n281 = proto.readVarIntI32(p425, n281)
						v4176.action_type = t1.ActionType.fromNumber(v4180) or v4180
					else
						local v4181

						v4181, n281 = proto.readVarInt(p425, n281)
					end
				elseif v4179 == proto.wireTypes.lengthDelimited then
					if v4178 == 2 then
						local v4182

						v4182, n281 = proto.readBuffer(p425, n281)
						v4176.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.decode(v4182)
					else
						local v4183, v4184 = proto.readVarInt(p425, n281)

						n281 = v4184 + v4183
					end
				elseif v4179 == proto.wireTypes.i32 then
					local v4185

					v4185, n281 = proto.readFixed32(p425, n281)
				elseif v4179 == proto.wireTypes.i64 then
					local v4186

					v4186, n281 = proto.readFixed64(p425, n281)
				else
					error("Unsupported wire type: " .. v4179)
				end
			end

			return v4176
		end
		function t563.jsonEncode(p426) -- line: 26519
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
		function t563.jsonDecode(t566: {[any]: any}) -- line: 26543
			-- upvalues: t563 (copy), t1 (copy)
			local v4190 = t563.new()

			if t566.action_type ~= nil then
				v4190.action_type = if typeof(t566.action_type) ~= "number" then t1.ActionType.fromName(t566.action_type) or t566.action_type else t1.ActionType.fromNumber(t566.action_type) or t566.action_type
			end

			if t566.actionType ~= nil then
				v4190.action_type = if typeof(t566.actionType) ~= "number" then t1.ActionType.fromName(t566.actionType) or t566.actionType else t1.ActionType.fromNumber(t566.actionType) or t566.actionType
			end

			if t566.action_params ~= nil then
				v4190.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t566.action_params)
			end

			if t566.actionParams ~= nil then
				v4190.action_params = t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params.jsonDecode(t566.actionParams)
			end

			return v4190
		end

		t563.descriptor = {
			name = "RecordPartyChatConversationUpsellAcknowledgementAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RecordPartyChatConversationUpsellAcknowledgementAction"
		}
		t1.RecordPartyChatConversationUpsellAcknowledgementAction = t563
	end

	typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction)

	do
		local t567 = {}

		t567.__index = t567

		function t567.new(t568: {[any]: any}?) -- line: 26589
			-- upvalues: t567 (copy)
			return (setmetatable({
				modal_action = if t568 ~= nil and t568.modal_action ~= nil then t568.modal_action else nil,
				modal_variant = if t568 ~= nil and t568.modal_variant ~= nil then t568.modal_variant else nil,
				modal_sequence = if t568 ~= nil and t568.modal_sequence ~= nil then t568.modal_sequence else nil,
				conversation_id = if t568 ~= nil and t568.conversation_id ~= nil then t568.conversation_id else nil,
				friend_id = if t568 ~= nil and t568.friend_id ~= nil then t568.friend_id else nil
			}, t567))
		end
		function t567.encode(p427) -- line: 26604
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n282 = 0

			if p427.modal_action ~= nil then
				local v4195 = p427.modal_action:encode()
				local v4196, v4197 = proto.writeTag(buf, n282, 1, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4196, v4197, v4195, buffer.len(v4195))
			end

			if p427.modal_variant ~= nil then
				local v4198 = p427.modal_variant:encode()
				local v4199, v4200 = proto.writeTag(buf, n282, 2, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4199, v4200, v4198, buffer.len(v4198))
			end

			if p427.modal_sequence ~= nil then
				local v4201 = p427.modal_sequence:encode()
				local v4202, v4203 = proto.writeTag(buf, n282, 3, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4202, v4203, v4201, buffer.len(v4201))
			end

			if p427.conversation_id ~= nil then
				local v4204 = p427.conversation_id:encode()
				local v4205, v4206 = proto.writeTag(buf, n282, 4, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4205, v4206, v4204, buffer.len(v4204))
			end

			if p427.friend_id ~= nil then
				local v4207 = p427.friend_id:encode()
				local v4208, v4209 = proto.writeTag(buf, n282, 5, proto.wireTypes.lengthDelimited)

				buf, n282 = proto.writeBuffer(v4208, v4209, v4207, buffer.len(v4207))
			end

			local buf144 = buffer.create(n282)

			buffer.copy(buf144, 0, buf, 0, n282)

			return buf144
		end
		function t567.decode(p428: buffer) -- line: 26645
			-- upvalues: t567 (copy), proto (copy), prop_types (copy)
			local v4212 = t567.new()
			local n283 = 0

			while n283 < buffer.len(p428) do
				local v4214, v4215

				v4214, v4215, n283 = proto.readTag(p428, n283)

				if v4215 == proto.wireTypes.varint then
					local v4216

					v4216, n283 = proto.readVarInt(p428, n283)
				elseif v4215 == proto.wireTypes.lengthDelimited then
					if v4214 == 1 then
						local v4217

						v4217, n283 = proto.readBuffer(p428, n283)
						v4212.modal_action = prop_types.StringProp.decode(v4217)
					elseif v4214 == 2 then
						local v4218

						v4218, n283 = proto.readBuffer(p428, n283)
						v4212.modal_variant = prop_types.StringProp.decode(v4218)
					elseif v4214 == 3 then
						local v4219

						v4219, n283 = proto.readBuffer(p428, n283)
						v4212.modal_sequence = prop_types.StringProp.decode(v4219)
					elseif v4214 == 4 then
						local v4220

						v4220, n283 = proto.readBuffer(p428, n283)
						v4212.conversation_id = prop_types.StringProp.decode(v4220)
					elseif v4214 == 5 then
						local v4221

						v4221, n283 = proto.readBuffer(p428, n283)
						v4212.friend_id = prop_types.StringProp.decode(v4221)
					else
						local v4222, v4223 = proto.readVarInt(p428, n283)

						n283 = v4223 + v4222
					end
				elseif v4215 == proto.wireTypes.i32 then
					local v4224

					v4224, n283 = proto.readFixed32(p428, n283)
				elseif v4215 == proto.wireTypes.i64 then
					local v4225

					v4225, n283 = proto.readFixed64(p428, n283)
				else
					error("Unsupported wire type: " .. v4215)
				end
			end

			return v4212
		end
		function t567.jsonEncode(p429) -- line: 26710
			local t569 = {}

			if p429.modal_action ~= nil then
				t569.modalAction = p429.modal_action:jsonEncode()
			end

			if p429.modal_variant ~= nil then
				t569.modalVariant = p429.modal_variant:jsonEncode()
			end

			if p429.modal_sequence ~= nil then
				t569.modalSequence = p429.modal_sequence:jsonEncode()
			end

			if p429.conversation_id ~= nil then
				t569.conversationId = p429.conversation_id:jsonEncode()
			end

			if p429.friend_id ~= nil then
				t569.friendId = p429.friend_id:jsonEncode()
			end

			return t569
		end
		function t567.jsonDecode(t570: {[any]: any}) -- line: 26738
			-- upvalues: t567 (copy), prop_types (copy)
			local v4229 = t567.new()

			if t570.modal_action ~= nil then
				v4229.modal_action = prop_types.StringProp.jsonDecode(t570.modal_action)
			end

			if t570.modalAction ~= nil then
				v4229.modal_action = prop_types.StringProp.jsonDecode(t570.modalAction)
			end

			if t570.modal_variant ~= nil then
				v4229.modal_variant = prop_types.StringProp.jsonDecode(t570.modal_variant)
			end

			if t570.modalVariant ~= nil then
				v4229.modal_variant = prop_types.StringProp.jsonDecode(t570.modalVariant)
			end

			if t570.modal_sequence ~= nil then
				v4229.modal_sequence = prop_types.StringProp.jsonDecode(t570.modal_sequence)
			end

			if t570.modalSequence ~= nil then
				v4229.modal_sequence = prop_types.StringProp.jsonDecode(t570.modalSequence)
			end

			if t570.conversation_id ~= nil then
				v4229.conversation_id = prop_types.StringProp.jsonDecode(t570.conversation_id)
			end

			if t570.conversationId ~= nil then
				v4229.conversation_id = prop_types.StringProp.jsonDecode(t570.conversationId)
			end

			if t570.friend_id ~= nil then
				v4229.friend_id = prop_types.StringProp.jsonDecode(t570.friend_id)
			end

			if t570.friendId ~= nil then
				v4229.friend_id = prop_types.StringProp.jsonDecode(t570.friendId)
			end

			return v4229
		end

		t567.descriptor = {
			name = "RecordPartyChatConversationUpsellAcknowledgementAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params = t567
		typeRegistry.default:register(t1.RecordPartyChatConversationUpsellAcknowledgementAction_Params)

		local t571 = {}

		t571.__index = t571

		function t571.new(t572: {[any]: any}?) -- line: 26809
			-- upvalues: t1 (copy), t571 (copy)
			return (setmetatable({
				action_type = if t572 ~= nil and t572.action_type ~= nil then t572.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t572 ~= nil and t572.action_params ~= nil then t572.action_params else nil
			}, t571))
		end
		function t571.encode(p430) -- line: 26818
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n284 = 0

			if p430.action_type ~= nil and (p430.action_type ~= nil and p430.action_type ~= 0 or p430.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4234, v4235 = proto.writeTag(buf, n284, 1, proto.wireTypes.varint)

				buf, n284 = proto.writeVarInt(v4234, v4235, t1.ActionType.toNumber(p430.action_type))
			end

			if p430.action_params ~= nil then
				local v4236 = p430.action_params:encode()
				local v4237, v4238 = proto.writeTag(buf, n284, 2, proto.wireTypes.lengthDelimited)

				buf, n284 = proto.writeBuffer(v4237, v4238, v4236, buffer.len(v4236))
			end

			local buf145 = buffer.create(n284)

			buffer.copy(buf145, 0, buf, 0, n284)

			return buf145
		end
		function t571.decode(p431: buffer) -- line: 26844
			-- upvalues: t571 (copy), proto (copy), t1 (copy)
			local v4241 = t571.new()
			local n285 = 0

			while n285 < buffer.len(p431) do
				local v4243, v4244

				v4243, v4244, n285 = proto.readTag(p431, n285)

				if v4244 == proto.wireTypes.varint then
					if v4243 == 1 then
						local v4245

						v4245, n285 = proto.readVarIntI32(p431, n285)
						v4241.action_type = t1.ActionType.fromNumber(v4245) or v4245
					else
						local v4246

						v4246, n285 = proto.readVarInt(p431, n285)
					end
				elseif v4244 == proto.wireTypes.lengthDelimited then
					if v4243 == 2 then
						local v4247

						v4247, n285 = proto.readBuffer(p431, n285)
						v4241.action_params = t1.RequestFriendshipAction_Params.decode(v4247)
					else
						local v4248, v4249 = proto.readVarInt(p431, n285)

						n285 = v4249 + v4248
					end
				elseif v4244 == proto.wireTypes.i32 then
					local v4250

					v4250, n285 = proto.readFixed32(p431, n285)
				elseif v4244 == proto.wireTypes.i64 then
					local v4251

					v4251, n285 = proto.readFixed64(p431, n285)
				else
					error("Unsupported wire type: " .. v4244)
				end
			end

			return v4241
		end
		function t571.jsonEncode(p432) -- line: 26892
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
		function t571.jsonDecode(t574: {[any]: any}) -- line: 26914
			-- upvalues: t571 (copy), t1 (copy)
			local v4255 = t571.new()

			if t574.action_type ~= nil then
				v4255.action_type = if typeof(t574.action_type) ~= "number" then t1.ActionType.fromName(t574.action_type) or t574.action_type else t1.ActionType.fromNumber(t574.action_type) or t574.action_type
			end

			if t574.actionType ~= nil then
				v4255.action_type = if typeof(t574.actionType) ~= "number" then t1.ActionType.fromName(t574.actionType) or t574.actionType else t1.ActionType.fromNumber(t574.actionType) or t574.actionType
			end

			if t574.action_params ~= nil then
				v4255.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t574.action_params)
			end

			if t574.actionParams ~= nil then
				v4255.action_params = t1.RequestFriendshipAction_Params.jsonDecode(t574.actionParams)
			end

			return v4255
		end

		t571.descriptor = {
			name = "RequestFriendshipAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.RequestFriendshipAction"
		}
		t1.RequestFriendshipAction = t571
	end

	typeRegistry.default:register(t1.RequestFriendshipAction)

	do
		local t575 = {}

		t575.__index = t575

		function t575.new(t576: {[any]: any}?) -- line: 26954
			-- upvalues: t575 (copy)
			return (setmetatable({
				target_user_id = if t576 ~= nil and t576.target_user_id ~= nil then t576.target_user_id else nil,
				source = if t576 ~= nil and t576.source ~= nil then t576.source else nil
			}, t575))
		end
		function t575.encode(p433) -- line: 26963
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n286 = 0

			if p433.target_user_id ~= nil then
				local v4260 = p433.target_user_id:encode()
				local v4261, v4262 = proto.writeTag(buf, n286, 1, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4261, v4262, v4260, buffer.len(v4260))
			end

			if p433.source ~= nil then
				local v4263 = p433.source:encode()
				local v4264, v4265 = proto.writeTag(buf, n286, 2, proto.wireTypes.lengthDelimited)

				buf, n286 = proto.writeBuffer(v4264, v4265, v4263, buffer.len(v4263))
			end

			local buf146 = buffer.create(n286)

			buffer.copy(buf146, 0, buf, 0, n286)

			return buf146
		end
		function t575.decode(p434: buffer) -- line: 26984
			-- upvalues: t575 (copy), proto (copy), prop_types (copy)
			local v4268 = t575.new()
			local n287 = 0

			while n287 < buffer.len(p434) do
				local v4270, v4271

				v4270, v4271, n287 = proto.readTag(p434, n287)

				if v4271 == proto.wireTypes.varint then
					local v4272

					v4272, n287 = proto.readVarInt(p434, n287)
				elseif v4271 == proto.wireTypes.lengthDelimited then
					if v4270 == 1 then
						local v4273

						v4273, n287 = proto.readBuffer(p434, n287)
						v4268.target_user_id = prop_types.StringProp.decode(v4273)
					elseif v4270 == 2 then
						local v4274

						v4274, n287 = proto.readBuffer(p434, n287)
						v4268.source = prop_types.StringProp.decode(v4274)
					else
						local v4275, v4276 = proto.readVarInt(p434, n287)

						n287 = v4276 + v4275
					end
				elseif v4271 == proto.wireTypes.i32 then
					local v4277

					v4277, n287 = proto.readFixed32(p434, n287)
				elseif v4271 == proto.wireTypes.i64 then
					local v4278

					v4278, n287 = proto.readFixed64(p434, n287)
				else
					error("Unsupported wire type: " .. v4271)
				end
			end

			return v4268
		end
		function t575.jsonEncode(p435) -- line: 27032
			local t577 = {}

			if p435.target_user_id ~= nil then
				t577.targetUserId = p435.target_user_id:jsonEncode()
			end

			if p435.source ~= nil then
				t577.source = p435.source:jsonEncode()
			end

			return t577
		end
		function t575.jsonDecode(t578: {[any]: any}) -- line: 27046
			-- upvalues: t575 (copy), prop_types (copy)
			local v4282 = t575.new()

			if t578.target_user_id ~= nil then
				v4282.target_user_id = prop_types.StringProp.jsonDecode(t578.target_user_id)
			end

			if t578.targetUserId ~= nil then
				v4282.target_user_id = prop_types.StringProp.jsonDecode(t578.targetUserId)
			end

			if t578.source ~= nil then
				v4282.source = prop_types.StringProp.jsonDecode(t578.source)
			end

			return v4282
		end

		t575.descriptor = {
			name = "RequestFriendshipAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.RequestFriendshipAction_Params = t575
		typeRegistry.default:register(t1.RequestFriendshipAction_Params)

		local t579 = {}

		t579.__index = t579

		function t579.new(t580: {[any]: any}?) -- line: 27080
			-- upvalues: t1 (copy), t579 (copy)
			return (setmetatable({
				action_type = if t580 ~= nil and t580.action_type ~= nil then t580.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t580 ~= nil and t580.action_params ~= nil then t580.action_params else nil
			}, t579))
		end
		function t579.encode(p436) -- line: 27091
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n288 = 0

			if p436.action_type ~= nil and (p436.action_type ~= nil and p436.action_type ~= 0 or p436.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4287, v4288 = proto.writeTag(buf, n288, 1, proto.wireTypes.varint)

				buf, n288 = proto.writeVarInt(v4287, v4288, t1.ActionType.toNumber(p436.action_type))
			end

			if p436.action_params ~= nil then
				local v4289 = p436.action_params:encode()
				local v4290, v4291 = proto.writeTag(buf, n288, 2, proto.wireTypes.lengthDelimited)

				buf, n288 = proto.writeBuffer(v4290, v4291, v4289, buffer.len(v4289))
			end

			local buf147 = buffer.create(n288)

			buffer.copy(buf147, 0, buf, 0, n288)

			return buf147
		end
		function t579.decode(p437: buffer) -- line: 27117
			-- upvalues: t579 (copy), proto (copy), t1 (copy)
			local v4294 = t579.new()
			local n289 = 0

			while n289 < buffer.len(p437) do
				local v4296, v4297

				v4296, v4297, n289 = proto.readTag(p437, n289)

				if v4297 == proto.wireTypes.varint then
					if v4296 == 1 then
						local v4298

						v4298, n289 = proto.readVarIntI32(p437, n289)
						v4294.action_type = t1.ActionType.fromNumber(v4298) or v4298
					else
						local v4299

						v4299, n289 = proto.readVarInt(p437, n289)
					end
				elseif v4297 == proto.wireTypes.lengthDelimited then
					if v4296 == 2 then
						local v4300

						v4300, n289 = proto.readBuffer(p437, n289)
						v4294.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.decode(v4300)
					else
						local v4301, v4302 = proto.readVarInt(p437, n289)

						n289 = v4302 + v4301
					end
				elseif v4297 == proto.wireTypes.i32 then
					local v4303

					v4303, n289 = proto.readFixed32(p437, n289)
				elseif v4297 == proto.wireTypes.i64 then
					local v4304

					v4304, n289 = proto.readFixed64(p437, n289)
				else
					error("Unsupported wire type: " .. v4297)
				end
			end

			return v4294
		end
		function t579.jsonEncode(p438) -- line: 27165
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
		function t579.jsonDecode(t582: {[any]: any}) -- line: 27187
			-- upvalues: t579 (copy), t1 (copy)
			local v4308 = t579.new()

			if t582.action_type ~= nil then
				v4308.action_type = if typeof(t582.action_type) ~= "number" then t1.ActionType.fromName(t582.action_type) or t582.action_type else t1.ActionType.fromNumber(t582.action_type) or t582.action_type
			end

			if t582.actionType ~= nil then
				v4308.action_type = if typeof(t582.actionType) ~= "number" then t1.ActionType.fromName(t582.actionType) or t582.actionType else t1.ActionType.fromNumber(t582.actionType) or t582.actionType
			end

			if t582.action_params ~= nil then
				v4308.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t582.action_params)
			end

			if t582.actionParams ~= nil then
				v4308.action_params = t1.OpenTrustedFriendsUpsellModalAction_Params.jsonDecode(t582.actionParams)
			end

			return v4308
		end

		t579.descriptor = {
			name = "OpenTrustedFriendsUpsellModalAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenTrustedFriendsUpsellModalAction"
		}
		t1.OpenTrustedFriendsUpsellModalAction = t579
	end

	typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction)

	do
		local t583 = {}

		t583.__index = t583

		function t583.new(t584: {[any]: any}?) -- line: 27229
			-- upvalues: t583 (copy)
			return (setmetatable({
				target_user_id = if t584 ~= nil and t584.target_user_id ~= nil then t584.target_user_id else nil
			}, t583))
		end
		function t583.encode(p439) -- line: 27237
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n290 = 0

			if p439.target_user_id ~= nil then
				local v4313 = p439.target_user_id:encode()
				local v4314, v4315 = proto.writeTag(buf, n290, 1, proto.wireTypes.lengthDelimited)

				buf, n290 = proto.writeBuffer(v4314, v4315, v4313, buffer.len(v4313))
			end

			local buf148 = buffer.create(n290)

			buffer.copy(buf148, 0, buf, 0, n290)

			return buf148
		end
		function t583.decode(p440: buffer) -- line: 27254
			-- upvalues: t583 (copy), proto (copy), prop_types (copy)
			local v4318 = t583.new()
			local n291 = 0

			while n291 < buffer.len(p440) do
				local v4320, v4321

				v4320, v4321, n291 = proto.readTag(p440, n291)

				if v4321 == proto.wireTypes.varint then
					local v4322

					v4322, n291 = proto.readVarInt(p440, n291)
				elseif v4321 == proto.wireTypes.lengthDelimited then
					if v4320 == 1 then
						local v4323

						v4323, n291 = proto.readBuffer(p440, n291)
						v4318.target_user_id = prop_types.StringProp.decode(v4323)
					else
						local v4324, v4325 = proto.readVarInt(p440, n291)

						n291 = v4325 + v4324
					end
				elseif v4321 == proto.wireTypes.i32 then
					local v4326

					v4326, n291 = proto.readFixed32(p440, n291)
				elseif v4321 == proto.wireTypes.i64 then
					local v4327

					v4327, n291 = proto.readFixed64(p440, n291)
				else
					error("Unsupported wire type: " .. v4321)
				end
			end

			return v4318
		end
		function t583.jsonEncode(p441) -- line: 27299
			local t585 = {}

			if p441.target_user_id ~= nil then
				t585.targetUserId = p441.target_user_id:jsonEncode()
			end

			return t585
		end
		function t583.jsonDecode(t586: {[any]: any}) -- line: 27311
			-- upvalues: t583 (copy), prop_types (copy)
			local v4331 = t583.new()

			if t586.target_user_id ~= nil then
				v4331.target_user_id = prop_types.StringProp.jsonDecode(t586.target_user_id)
			end

			if t586.targetUserId ~= nil then
				v4331.target_user_id = prop_types.StringProp.jsonDecode(t586.targetUserId)
			end

			return v4331
		end

		t583.descriptor = {
			name = "OpenTrustedFriendsUpsellModalAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenTrustedFriendsUpsellModalAction_Params = t583
		typeRegistry.default:register(t1.OpenTrustedFriendsUpsellModalAction_Params)

		local t587 = {}

		t587.__index = t587

		function t587.new(t588: {[any]: any}?) -- line: 27343
			-- upvalues: t1 (copy), t587 (copy)
			return (setmetatable({
				action_type = if t588 ~= nil and t588.action_type ~= nil then t588.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t588 ~= nil and t588.action_params ~= nil then t588.action_params else nil
			}, t587))
		end
		function t587.encode(p442) -- line: 27354
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n292 = 0

			if p442.action_type ~= nil and (p442.action_type ~= nil and p442.action_type ~= 0 or p442.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4336, v4337 = proto.writeTag(buf, n292, 1, proto.wireTypes.varint)

				buf, n292 = proto.writeVarInt(v4336, v4337, t1.ActionType.toNumber(p442.action_type))
			end

			if p442.action_params ~= nil then
				local v4338 = p442.action_params:encode()
				local v4339, v4340 = proto.writeTag(buf, n292, 2, proto.wireTypes.lengthDelimited)

				buf, n292 = proto.writeBuffer(v4339, v4340, v4338, buffer.len(v4338))
			end

			local buf149 = buffer.create(n292)

			buffer.copy(buf149, 0, buf, 0, n292)

			return buf149
		end
		function t587.decode(p443: buffer) -- line: 27380
			-- upvalues: t587 (copy), proto (copy), t1 (copy)
			local v4343 = t587.new()
			local n293 = 0

			while n293 < buffer.len(p443) do
				local v4345, v4346

				v4345, v4346, n293 = proto.readTag(p443, n293)

				if v4346 == proto.wireTypes.varint then
					if v4345 == 1 then
						local v4347

						v4347, n293 = proto.readVarIntI32(p443, n293)
						v4343.action_type = t1.ActionType.fromNumber(v4347) or v4347
					else
						local v4348

						v4348, n293 = proto.readVarInt(p443, n293)
					end
				elseif v4346 == proto.wireTypes.lengthDelimited then
					if v4345 == 2 then
						local v4349

						v4349, n293 = proto.readBuffer(p443, n293)
						v4343.action_params = t1.OpenSearchResultsWithQueryAction_Params.decode(v4349)
					else
						local v4350, v4351 = proto.readVarInt(p443, n293)

						n293 = v4351 + v4350
					end
				elseif v4346 == proto.wireTypes.i32 then
					local v4352

					v4352, n293 = proto.readFixed32(p443, n293)
				elseif v4346 == proto.wireTypes.i64 then
					local v4353

					v4353, n293 = proto.readFixed64(p443, n293)
				else
					error("Unsupported wire type: " .. v4346)
				end
			end

			return v4343
		end
		function t587.jsonEncode(p444) -- line: 27428
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
		function t587.jsonDecode(t590: {[any]: any}) -- line: 27450
			-- upvalues: t587 (copy), t1 (copy)
			local v4357 = t587.new()

			if t590.action_type ~= nil then
				v4357.action_type = if typeof(t590.action_type) ~= "number" then t1.ActionType.fromName(t590.action_type) or t590.action_type else t1.ActionType.fromNumber(t590.action_type) or t590.action_type
			end

			if t590.actionType ~= nil then
				v4357.action_type = if typeof(t590.actionType) ~= "number" then t1.ActionType.fromName(t590.actionType) or t590.actionType else t1.ActionType.fromNumber(t590.actionType) or t590.actionType
			end

			if t590.action_params ~= nil then
				v4357.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t590.action_params)
			end

			if t590.actionParams ~= nil then
				v4357.action_params = t1.OpenSearchResultsWithQueryAction_Params.jsonDecode(t590.actionParams)
			end

			return v4357
		end

		t587.descriptor = {
			name = "OpenSearchResultsWithQueryAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.OpenSearchResultsWithQueryAction"
		}
		t1.OpenSearchResultsWithQueryAction = t587
	end

	typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction)

	do
		local t591 = {}

		t591.__index = t591

		function t591.new(t592: {[any]: any}?) -- line: 27492
			-- upvalues: t591 (copy)
			return (setmetatable({
				search_query = if t592 ~= nil and t592.search_query ~= nil then t592.search_query else nil,
				search_type = if t592 ~= nil and t592.search_type ~= nil then t592.search_type else nil
			}, t591))
		end
		function t591.encode(p445) -- line: 27501
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n294 = 0

			if p445.search_query ~= nil then
				local v4362 = p445.search_query:encode()
				local v4363, v4364 = proto.writeTag(buf, n294, 1, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4363, v4364, v4362, buffer.len(v4362))
			end

			if p445.search_type ~= nil then
				local v4365 = p445.search_type:encode()
				local v4366, v4367 = proto.writeTag(buf, n294, 2, proto.wireTypes.lengthDelimited)

				buf, n294 = proto.writeBuffer(v4366, v4367, v4365, buffer.len(v4365))
			end

			local buf150 = buffer.create(n294)

			buffer.copy(buf150, 0, buf, 0, n294)

			return buf150
		end
		function t591.decode(p446: buffer) -- line: 27522
			-- upvalues: t591 (copy), proto (copy), prop_types (copy)
			local v4370 = t591.new()
			local n295 = 0

			while n295 < buffer.len(p446) do
				local v4372, v4373

				v4372, v4373, n295 = proto.readTag(p446, n295)

				if v4373 == proto.wireTypes.varint then
					local v4374

					v4374, n295 = proto.readVarInt(p446, n295)
				elseif v4373 == proto.wireTypes.lengthDelimited then
					if v4372 == 1 then
						local v4375

						v4375, n295 = proto.readBuffer(p446, n295)
						v4370.search_query = prop_types.StringProp.decode(v4375)
					elseif v4372 == 2 then
						local v4376

						v4376, n295 = proto.readBuffer(p446, n295)
						v4370.search_type = prop_types.StringProp.decode(v4376)
					else
						local v4377, v4378 = proto.readVarInt(p446, n295)

						n295 = v4378 + v4377
					end
				elseif v4373 == proto.wireTypes.i32 then
					local v4379

					v4379, n295 = proto.readFixed32(p446, n295)
				elseif v4373 == proto.wireTypes.i64 then
					local v4380

					v4380, n295 = proto.readFixed64(p446, n295)
				else
					error("Unsupported wire type: " .. v4373)
				end
			end

			return v4370
		end
		function t591.jsonEncode(p447) -- line: 27570
			local t593 = {}

			if p447.search_query ~= nil then
				t593.searchQuery = p447.search_query:jsonEncode()
			end

			if p447.search_type ~= nil then
				t593.searchType = p447.search_type:jsonEncode()
			end

			return t593
		end
		function t591.jsonDecode(t594: {[any]: any}) -- line: 27584
			-- upvalues: t591 (copy), prop_types (copy)
			local v4384 = t591.new()

			if t594.search_query ~= nil then
				v4384.search_query = prop_types.StringProp.jsonDecode(t594.search_query)
			end

			if t594.searchQuery ~= nil then
				v4384.search_query = prop_types.StringProp.jsonDecode(t594.searchQuery)
			end

			if t594.search_type ~= nil then
				v4384.search_type = prop_types.StringProp.jsonDecode(t594.search_type)
			end

			if t594.searchType ~= nil then
				v4384.search_type = prop_types.StringProp.jsonDecode(t594.searchType)
			end

			return v4384
		end

		t591.descriptor = {
			name = "OpenSearchResultsWithQueryAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.OpenSearchResultsWithQueryAction_Params = t591
		typeRegistry.default:register(t1.OpenSearchResultsWithQueryAction_Params)

		local t595 = {}

		t595.__index = t595

		function t595.new(t596: {[any]: any}?) -- line: 27625
			-- upvalues: t1 (copy), t595 (copy)
			return (setmetatable({
				action_type = if t596 ~= nil and t596.action_type ~= nil then t596.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t596 ~= nil and t596.action_params ~= nil then t596.action_params else nil
			}, t595))
		end
		function t595.encode(p448) -- line: 27636
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n296 = 0

			if p448.action_type ~= nil and (p448.action_type ~= nil and p448.action_type ~= 0 or p448.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4389, v4390 = proto.writeTag(buf, n296, 1, proto.wireTypes.varint)

				buf, n296 = proto.writeVarInt(v4389, v4390, t1.ActionType.toNumber(p448.action_type))
			end

			if p448.action_params ~= nil then
				local v4391 = p448.action_params:encode()
				local v4392, v4393 = proto.writeTag(buf, n296, 2, proto.wireTypes.lengthDelimited)

				buf, n296 = proto.writeBuffer(v4392, v4393, v4391, buffer.len(v4391))
			end

			local buf151 = buffer.create(n296)

			buffer.copy(buf151, 0, buf, 0, n296)

			return buf151
		end
		function t595.decode(p449: buffer) -- line: 27662
			-- upvalues: t595 (copy), proto (copy), t1 (copy)
			local v4396 = t595.new()
			local n297 = 0

			while n297 < buffer.len(p449) do
				local v4398, v4399

				v4398, v4399, n297 = proto.readTag(p449, n297)

				if v4399 == proto.wireTypes.varint then
					if v4398 == 1 then
						local v4400

						v4400, n297 = proto.readVarIntI32(p449, n297)
						v4396.action_type = t1.ActionType.fromNumber(v4400) or v4400
					else
						local v4401

						v4401, n297 = proto.readVarInt(p449, n297)
					end
				elseif v4399 == proto.wireTypes.lengthDelimited then
					if v4398 == 2 then
						local v4402

						v4402, n297 = proto.readBuffer(p449, n297)
						v4396.action_params = t1.SelectMarketplaceFavoritesCategory_Params.decode(v4402)
					else
						local v4403, v4404 = proto.readVarInt(p449, n297)

						n297 = v4404 + v4403
					end
				elseif v4399 == proto.wireTypes.i32 then
					local v4405

					v4405, n297 = proto.readFixed32(p449, n297)
				elseif v4399 == proto.wireTypes.i64 then
					local v4406

					v4406, n297 = proto.readFixed64(p449, n297)
				else
					error("Unsupported wire type: " .. v4399)
				end
			end

			return v4396
		end
		function t595.jsonEncode(p450) -- line: 27710
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
		function t595.jsonDecode(t598: {[any]: any}) -- line: 27732
			-- upvalues: t595 (copy), t1 (copy)
			local v4410 = t595.new()

			if t598.action_type ~= nil then
				v4410.action_type = if typeof(t598.action_type) ~= "number" then t1.ActionType.fromName(t598.action_type) or t598.action_type else t1.ActionType.fromNumber(t598.action_type) or t598.action_type
			end

			if t598.actionType ~= nil then
				v4410.action_type = if typeof(t598.actionType) ~= "number" then t1.ActionType.fromName(t598.actionType) or t598.actionType else t1.ActionType.fromNumber(t598.actionType) or t598.actionType
			end

			if t598.action_params ~= nil then
				v4410.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t598.action_params)
			end

			if t598.actionParams ~= nil then
				v4410.action_params = t1.SelectMarketplaceFavoritesCategory_Params.jsonDecode(t598.actionParams)
			end

			return v4410
		end

		t595.descriptor = {
			name = "SelectMarketplaceFavoritesCategory",
			fullName = "roblox.apppageplatform.shared.v1beta1.SelectMarketplaceFavoritesCategory"
		}
		t1.SelectMarketplaceFavoritesCategory = t595
	end

	typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory)

	do
		local t599 = {}

		t599.__index = t599

		function t599.new(t600: {[any]: any}?) -- line: 27774
			-- upvalues: t599 (copy)
			return (setmetatable({
				category_id = if t600 ~= nil and t600.category_id ~= nil then t600.category_id else nil
			}, t599))
		end
		function t599.encode(p451) -- line: 27782
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n298 = 0

			if p451.category_id ~= nil then
				local v4415 = p451.category_id:encode()
				local v4416, v4417 = proto.writeTag(buf, n298, 1, proto.wireTypes.lengthDelimited)

				buf, n298 = proto.writeBuffer(v4416, v4417, v4415, buffer.len(v4415))
			end

			local buf152 = buffer.create(n298)

			buffer.copy(buf152, 0, buf, 0, n298)

			return buf152
		end
		function t599.decode(p452: buffer) -- line: 27799
			-- upvalues: t599 (copy), proto (copy), prop_types (copy)
			local v4420 = t599.new()
			local n299 = 0

			while n299 < buffer.len(p452) do
				local v4422, v4423

				v4422, v4423, n299 = proto.readTag(p452, n299)

				if v4423 == proto.wireTypes.varint then
					local v4424

					v4424, n299 = proto.readVarInt(p452, n299)
				elseif v4423 == proto.wireTypes.lengthDelimited then
					if v4422 == 1 then
						local v4425

						v4425, n299 = proto.readBuffer(p452, n299)
						v4420.category_id = prop_types.StringProp.decode(v4425)
					else
						local v4426, v4427 = proto.readVarInt(p452, n299)

						n299 = v4427 + v4426
					end
				elseif v4423 == proto.wireTypes.i32 then
					local v4428

					v4428, n299 = proto.readFixed32(p452, n299)
				elseif v4423 == proto.wireTypes.i64 then
					local v4429

					v4429, n299 = proto.readFixed64(p452, n299)
				else
					error("Unsupported wire type: " .. v4423)
				end
			end

			return v4420
		end
		function t599.jsonEncode(p453) -- line: 27844
			local t601 = {}

			if p453.category_id ~= nil then
				t601.categoryId = p453.category_id:jsonEncode()
			end

			return t601
		end
		function t599.jsonDecode(t602: {[any]: any}) -- line: 27856
			-- upvalues: t599 (copy), prop_types (copy)
			local v4433 = t599.new()

			if t602.category_id ~= nil then
				v4433.category_id = prop_types.StringProp.jsonDecode(t602.category_id)
			end

			if t602.categoryId ~= nil then
				v4433.category_id = prop_types.StringProp.jsonDecode(t602.categoryId)
			end

			return v4433
		end

		t599.descriptor = {
			name = "SelectMarketplaceFavoritesCategory_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.SelectMarketplaceFavoritesCategory_Params = t599
		typeRegistry.default:register(t1.SelectMarketplaceFavoritesCategory_Params)

		local t603 = {}

		t603.__index = t603

		function t603.new(t604: {[any]: any}?) -- line: 27887
			-- upvalues: t1 (copy), t603 (copy)
			return (setmetatable({
				action_type = if t604 ~= nil and t604.action_type ~= nil then t604.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t604 ~= nil and t604.action_params ~= nil then t604.action_params else nil
			}, t603))
		end
		function t603.encode(p454) -- line: 27898
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n300 = 0

			if p454.action_type ~= nil and (p454.action_type ~= nil and p454.action_type ~= 0 or p454.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4438, v4439 = proto.writeTag(buf, n300, 1, proto.wireTypes.varint)

				buf, n300 = proto.writeVarInt(v4438, v4439, t1.ActionType.toNumber(p454.action_type))
			end

			if p454.action_params ~= nil then
				local v4440 = p454.action_params:encode()
				local v4441, v4442 = proto.writeTag(buf, n300, 2, proto.wireTypes.lengthDelimited)

				buf, n300 = proto.writeBuffer(v4441, v4442, v4440, buffer.len(v4440))
			end

			local buf153 = buffer.create(n300)

			buffer.copy(buf153, 0, buf, 0, n300)

			return buf153
		end
		function t603.decode(p455: buffer) -- line: 27924
			-- upvalues: t603 (copy), proto (copy), t1 (copy)
			local v4445 = t603.new()
			local n301 = 0

			while n301 < buffer.len(p455) do
				local v4447, v4448

				v4447, v4448, n301 = proto.readTag(p455, n301)

				if v4448 == proto.wireTypes.varint then
					if v4447 == 1 then
						local v4449

						v4449, n301 = proto.readVarIntI32(p455, n301)
						v4445.action_type = t1.ActionType.fromNumber(v4449) or v4449
					else
						local v4450

						v4450, n301 = proto.readVarInt(p455, n301)
					end
				elseif v4448 == proto.wireTypes.lengthDelimited then
					if v4447 == 2 then
						local v4451

						v4451, n301 = proto.readBuffer(p455, n301)
						v4445.action_params = t1.PinExperienceShortcutAction_Params.decode(v4451)
					else
						local v4452, v4453 = proto.readVarInt(p455, n301)

						n301 = v4453 + v4452
					end
				elseif v4448 == proto.wireTypes.i32 then
					local v4454

					v4454, n301 = proto.readFixed32(p455, n301)
				elseif v4448 == proto.wireTypes.i64 then
					local v4455

					v4455, n301 = proto.readFixed64(p455, n301)
				else
					error("Unsupported wire type: " .. v4448)
				end
			end

			return v4445
		end
		function t603.jsonEncode(p456) -- line: 27972
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
		function t603.jsonDecode(t606: {[any]: any}) -- line: 27994
			-- upvalues: t603 (copy), t1 (copy)
			local v4459 = t603.new()

			if t606.action_type ~= nil then
				v4459.action_type = if typeof(t606.action_type) ~= "number" then t1.ActionType.fromName(t606.action_type) or t606.action_type else t1.ActionType.fromNumber(t606.action_type) or t606.action_type
			end

			if t606.actionType ~= nil then
				v4459.action_type = if typeof(t606.actionType) ~= "number" then t1.ActionType.fromName(t606.actionType) or t606.actionType else t1.ActionType.fromNumber(t606.actionType) or t606.actionType
			end

			if t606.action_params ~= nil then
				v4459.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t606.action_params)
			end

			if t606.actionParams ~= nil then
				v4459.action_params = t1.PinExperienceShortcutAction_Params.jsonDecode(t606.actionParams)
			end

			return v4459
		end

		t603.descriptor = {
			name = "PinExperienceShortcutAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.PinExperienceShortcutAction"
		}
		t1.PinExperienceShortcutAction = t603
	end

	typeRegistry.default:register(t1.PinExperienceShortcutAction)

	do
		local t607 = {}

		t607.__index = t607

		function t607.new(t608: {[any]: any}?) -- line: 28034
			-- upvalues: t607 (copy)
			return (setmetatable({
				place_id = if t608 ~= nil and t608.place_id ~= nil then t608.place_id else nil,
				universe_id = if t608 ~= nil and t608.universe_id ~= nil then t608.universe_id else nil,
				game_name = if t608 ~= nil and t608.game_name ~= nil then t608.game_name else nil
			}, t607))
		end
		function t607.encode(p457) -- line: 28044
			-- upvalues: proto (copy)
			local buf = buffer.create(0)
			local n302 = 0

			if p457.place_id ~= nil then
				local v4464 = p457.place_id:encode()
				local v4465, v4466 = proto.writeTag(buf, n302, 1, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4465, v4466, v4464, buffer.len(v4464))
			end

			if p457.universe_id ~= nil then
				local v4467 = p457.universe_id:encode()
				local v4468, v4469 = proto.writeTag(buf, n302, 2, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4468, v4469, v4467, buffer.len(v4467))
			end

			if p457.game_name ~= nil then
				local v4470 = p457.game_name:encode()
				local v4471, v4472 = proto.writeTag(buf, n302, 3, proto.wireTypes.lengthDelimited)

				buf, n302 = proto.writeBuffer(v4471, v4472, v4470, buffer.len(v4470))
			end

			local buf154 = buffer.create(n302)

			buffer.copy(buf154, 0, buf, 0, n302)

			return buf154
		end
		function t607.decode(p458: buffer) -- line: 28071
			-- upvalues: t607 (copy), proto (copy), prop_types (copy)
			local v4475 = t607.new()
			local n303 = 0

			while n303 < buffer.len(p458) do
				local v4477, v4478

				v4477, v4478, n303 = proto.readTag(p458, n303)

				if v4478 == proto.wireTypes.varint then
					local v4479

					v4479, n303 = proto.readVarInt(p458, n303)
				elseif v4478 == proto.wireTypes.lengthDelimited then
					if v4477 == 1 then
						local v4480

						v4480, n303 = proto.readBuffer(p458, n303)
						v4475.place_id = prop_types.StringProp.decode(v4480)
					elseif v4477 == 2 then
						local v4481

						v4481, n303 = proto.readBuffer(p458, n303)
						v4475.universe_id = prop_types.StringProp.decode(v4481)
					elseif v4477 == 3 then
						local v4482

						v4482, n303 = proto.readBuffer(p458, n303)
						v4475.game_name = prop_types.StringProp.decode(v4482)
					else
						local v4483, v4484 = proto.readVarInt(p458, n303)

						n303 = v4484 + v4483
					end
				elseif v4478 == proto.wireTypes.i32 then
					local v4485

					v4485, n303 = proto.readFixed32(p458, n303)
				elseif v4478 == proto.wireTypes.i64 then
					local v4486

					v4486, n303 = proto.readFixed64(p458, n303)
				else
					error("Unsupported wire type: " .. v4478)
				end
			end

			return v4475
		end
		function t607.jsonEncode(p459) -- line: 28124
			local t609 = {}

			if p459.place_id ~= nil then
				t609.placeId = p459.place_id:jsonEncode()
			end

			if p459.universe_id ~= nil then
				t609.universeId = p459.universe_id:jsonEncode()
			end

			if p459.game_name ~= nil then
				t609.gameName = p459.game_name:jsonEncode()
			end

			return t609
		end
		function t607.jsonDecode(t610: {[any]: any}) -- line: 28142
			-- upvalues: t607 (copy), prop_types (copy)
			local v4490 = t607.new()

			if t610.place_id ~= nil then
				v4490.place_id = prop_types.StringProp.jsonDecode(t610.place_id)
			end

			if t610.placeId ~= nil then
				v4490.place_id = prop_types.StringProp.jsonDecode(t610.placeId)
			end

			if t610.universe_id ~= nil then
				v4490.universe_id = prop_types.StringProp.jsonDecode(t610.universe_id)
			end

			if t610.universeId ~= nil then
				v4490.universe_id = prop_types.StringProp.jsonDecode(t610.universeId)
			end

			if t610.game_name ~= nil then
				v4490.game_name = prop_types.StringProp.jsonDecode(t610.game_name)
			end

			if t610.gameName ~= nil then
				v4490.game_name = prop_types.StringProp.jsonDecode(t610.gameName)
			end

			return v4490
		end

		t607.descriptor = {
			name = "PinExperienceShortcutAction_Params",
			fullName = "roblox.apppageplatform.shared.v1beta1.Params"
		}
		t1.PinExperienceShortcutAction_Params = t607
		typeRegistry.default:register(t1.PinExperienceShortcutAction_Params)

		local t611 = {}

		t611.__index = t611

		function t611.new(t612: {[any]: any}?) -- line: 28189
			-- upvalues: t1 (copy), t611 (copy)
			return (setmetatable({
				action_type = if t612 ~= nil and t612.action_type ~= nil then t612.action_type else assert(t1.ActionType.fromNumber(0), "Enum has no 0 default"),
				action_params = if t612 ~= nil and t612.action_params ~= nil then t612.action_params else nil
			}, t611))
		end
		function t611.encode(p460) -- line: 28198
			-- upvalues: t1 (copy), proto (copy)
			local buf = buffer.create(0)
			local n304 = 0

			if p460.action_type ~= nil and (p460.action_type ~= nil and p460.action_type ~= 0 or p460.action_type ~= t1.ActionType.fromNumber(0)) then
				local v4495, v4496 = proto.writeTag(buf, n304, 1, proto.wireTypes.varint)

				buf, n304 = proto.writeVarInt(v4495, v4496, t1.ActionType.toNumber(p460.action_type))
			end

			if p460.action_params ~= nil then
				local v4497 = p460.action_params:encode()
				local v4498, v4499 = proto.writeTag(buf, n304, 2, proto.wireTypes.lengthDelimited)

				buf, n304 = proto.writeBuffer(v4498, v4499, v4497, buffer.len(v4497))
			end

			local buf155 = buffer.create(n304)

			buffer.copy(buf155, 0, buf, 0, n304)

			return buf155
		end
		function t611.decode(p461: buffer) -- line: 28224
			-- upvalues: t611 (copy), proto (copy), t1 (copy)
			local v4502 = t611.new()
			local n305 = 0

			while n305 < buffer.len(p461) do
				local v4504, v4505

				v4504, v4505, n305 = proto.readTag(p461, n305)

				if v4505 == proto.wireTypes.varint then
					if v4504 == 1 then
						local v4506

						v4506, n305 = proto.readVarIntI32(p461, n305)
						v4502.action_type = t1.ActionType.fromNumber(v4506) or v4506
					else
						local v4507

						v4507, n305 = proto.readVarInt(p461, n305)
					end
				elseif v4505 == proto.wireTypes.lengthDelimited then
					if v4504 == 2 then
						local v4508

						v4508, n305 = proto.readBuffer(p461, n305)
						v4502.action_params = t1.DownloadAppAction_Params.decode(v4508)
					else
						local v4509, v4510 = proto.readVarInt(p461, n305)

						n305 = v4510 + v4509
					end
				elseif v4505 == proto.wireTypes.i32 then
					local v4511

					v4511, n305 = proto.readFixed32(p461, n305)
				elseif v4505 == proto.wireTypes.i64 then
					local v4512

					v4512, n305 = proto.readFixed64(p461, n305)
				else
					error("Unsupported wire type: " .. v4505)
				end
			end

			return v4502
		end
		function t611.jsonEncode(p462) -- line: 28272
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
		function t611.jsonDecode(t614: {[any]: any}) -- line: 28294
			-- upvalues: t611 (copy), t1 (copy)
			local v4516 = t611.new()

			if t614.action_type ~= nil then
				v4516.action_type = if typeof(t614.action_type) ~= "number" then t1.ActionType.fromName(t614.action_type) or t614.action_type else t1.ActionType.fromNumber(t614.action_type) or t614.action_type
			end

			if t614.actionType ~= nil then
				v4516.action_type = if typeof(t614.actionType) ~= "number" then t1.ActionType.fromName(t614.actionType) or t614.actionType else t1.ActionType.fromNumber(t614.actionType) or t614.actionType
			end

			if t614.action_params ~= nil then
				v4516.action_params = t1.DownloadAppAction_Params.jsonDecode(t614.action_params)
			end

			if t614.actionParams ~= nil then
				v4516.action_params = t1.DownloadAppAction_Params.jsonDecode(t614.actionParams)
			end

			return v4516
		end

		t611.descriptor = {
			name = "DownloadAppAction",
			fullName = "roblox.apppageplatform.shared.v1beta1.DownloadAppAction"
		}
		t1.DownloadAppAction = t611
	end

	typeRegistry.default:register(t1.DownloadAppAction)

	local t615 = {}

	t615.__index = t615

	function t615.new(t616: {[any]: any}?) -- line: 28334
		-- upvalues: t615 (copy)
		return (setmetatable({
			source = if t616 ~= nil and t616.source ~= nil then t616.source else nil,
			download_type = if t616 ~= nil and t616.download_type ~= nil then t616.download_type else nil
		}, t615))
	end
	function t615.encode(p463) -- line: 28341
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n306 = 0

		if p463.source ~= nil then
			local v4521 = p463.source:encode()
			local v4522, v4523 = proto.writeTag(buf, n306, 1, proto.wireTypes.lengthDelimited)

			buf, n306 = proto.writeBuffer(v4522, v4523, v4521, buffer.len(v4521))
		end

		if p463.download_type ~= nil then
			local v4524 = p463.download_type:encode()
			local v4525, v4526 = proto.writeTag(buf, n306, 2, proto.wireTypes.lengthDelimited)

			buf, n306 = proto.writeBuffer(v4525, v4526, v4524, buffer.len(v4524))
		end

		local buf156 = buffer.create(n306)

		buffer.copy(buf156, 0, buf, 0, n306)

		return buf156
	end
	function t615.decode(p464: buffer) -- line: 28362
		-- upvalues: t615 (copy), proto (copy), prop_types (copy)
		local v4529 = t615.new()
		local n307 = 0

		while n307 < buffer.len(p464) do
			local v4531, v4532

			v4531, v4532, n307 = proto.readTag(p464, n307)

			if v4532 == proto.wireTypes.varint then
				local v4533

				v4533, n307 = proto.readVarInt(p464, n307)
			elseif v4532 == proto.wireTypes.lengthDelimited then
				if v4531 == 1 then
					local v4534

					v4534, n307 = proto.readBuffer(p464, n307)
					v4529.source = prop_types.StringProp.decode(v4534)
				elseif v4531 == 2 then
					local v4535

					v4535, n307 = proto.readBuffer(p464, n307)
					v4529.download_type = prop_types.StringProp.decode(v4535)
				else
					local v4536, v4537 = proto.readVarInt(p464, n307)

					n307 = v4537 + v4536
				end
			elseif v4532 == proto.wireTypes.i32 then
				local v4538

				v4538, n307 = proto.readFixed32(p464, n307)
			elseif v4532 == proto.wireTypes.i64 then
				local v4539

				v4539, n307 = proto.readFixed64(p464, n307)
			else
				error("Unsupported wire type: " .. v4532)
			end
		end

		return v4529
	end
	function t615.jsonEncode(p465) -- line: 28410
		local t617 = {}

		if p465.source ~= nil then
			t617.source = p465.source:jsonEncode()
		end

		if p465.download_type ~= nil then
			t617.downloadType = p465.download_type:jsonEncode()
		end

		return t617
	end
	function t615.jsonDecode(t618: {[any]: any}) -- line: 28424
		-- upvalues: t615 (copy), prop_types (copy)
		local v4543 = t615.new()

		if t618.source ~= nil then
			v4543.source = prop_types.StringProp.jsonDecode(t618.source)
		end

		if t618.download_type ~= nil then
			v4543.download_type = prop_types.StringProp.jsonDecode(t618.download_type)
		end

		if t618.downloadType ~= nil then
			v4543.download_type = prop_types.StringProp.jsonDecode(t618.downloadType)
		end

		return v4543
	end

	t615.descriptor = {
		name = "DownloadAppAction_Params",
		fullName = "roblox.apppageplatform.shared.v1beta1.Params"
	}
	t1.DownloadAppAction_Params = t615
	typeRegistry.default:register(t1.DownloadAppAction_Params)

	local t619 = {}

	t619.__index = t619

	function t619.new(t620: {[any]: any}?) -- line: 28458
		-- upvalues: t619 (copy)
		return (setmetatable({
			kind = if t620 ~= nil and t620.kind ~= nil then t620.kind else nil,
			telemetry_handler = if t620 ~= nil and t620.telemetry_handler ~= nil then t620.telemetry_handler else nil,
			accessibility_label = if t620 ~= nil and t620.accessibility_label ~= nil then t620.accessibility_label else nil
		}, t619))
	end
	function t619.encode(p466) -- line: 28468
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n308 = 0

		if p466.kind ~= nil then
			if p466.kind.type == "dismiss_dialog_action" then
				local v4548 = p466.kind.value:encode()
				local v4549, v4550 = proto.writeTag(buf, n308, 1, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4549, v4550, v4548, buffer.len(v4548))
			elseif p466.kind.type == "link_action" then
				local v4551 = p466.kind.value:encode()
				local v4552, v4553 = proto.writeTag(buf, n308, 2, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4552, v4553, v4551, buffer.len(v4551))
			elseif p466.kind.type == "open_game_details_action" then
				local v4554 = p466.kind.value:encode()
				local v4555, v4556 = proto.writeTag(buf, n308, 3, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4555, v4556, v4554, buffer.len(v4554))
			elseif p466.kind.type == "open_join_friends_action" then
				local v4557 = p466.kind.value:encode()
				local v4558, v4559 = proto.writeTag(buf, n308, 4, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4558, v4559, v4557, buffer.len(v4557))
			elseif p466.kind.type == "open_marketplace_try_on_action" then
				local v4560 = p466.kind.value:encode()
				local v4561, v4562 = proto.writeTag(buf, n308, 5, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4561, v4562, v4560, buffer.len(v4560))
			elseif p466.kind.type == "open_see_all_action" then
				local v4563 = p466.kind.value:encode()
				local v4564, v4565 = proto.writeTag(buf, n308, 6, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4564, v4565, v4563, buffer.len(v4563))
			elseif p466.kind.type == "open_sponsored_tooltip_action" then
				local v4566 = p466.kind.value:encode()
				local v4567, v4568 = proto.writeTag(buf, n308, 7, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4567, v4568, v4566, buffer.len(v4566))
			elseif p466.kind.type == "play_button_click_action" then
				local v4569 = p466.kind.value:encode()
				local v4570, v4571 = proto.writeTag(buf, n308, 8, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4570, v4571, v4569, buffer.len(v4569))
			elseif p466.kind.type == "update_user_settings_action" then
				local v4572 = p466.kind.value:encode()
				local v4573, v4574 = proto.writeTag(buf, n308, 9, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4573, v4574, v4572, buffer.len(v4572))
			elseif p466.kind.type == "open_tooltip_action" then
				local v4575 = p466.kind.value:encode()
				local v4576, v4577 = proto.writeTag(buf, n308, 10, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4576, v4577, v4575, buffer.len(v4575))
			elseif p466.kind.type == "open_badge_details_action" then
				local v4578 = p466.kind.value:encode()
				local v4579, v4580 = proto.writeTag(buf, n308, 11, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4579, v4580, v4578, buffer.len(v4578))
			elseif p466.kind.type == "load_more_from_api_action" then
				local v4581 = p466.kind.value:encode()
				local v4582, v4583 = proto.writeTag(buf, n308, 12, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4582, v4583, v4581, buffer.len(v4581))
			elseif p466.kind.type == "share_action" then
				local v4584 = p466.kind.value:encode()
				local v4585, v4586 = proto.writeTag(buf, n308, 13, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4585, v4586, v4584, buffer.len(v4584))
			elseif p466.kind.type == "open_abuse_report_action" then
				local v4587 = p466.kind.value:encode()
				local v4588, v4589 = proto.writeTag(buf, n308, 14, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4588, v4589, v4587, buffer.len(v4587))
			elseif p466.kind.type == "remove_badge_from_inventory_action" then
				local v4590 = p466.kind.value:encode()
				local v4591, v4592 = proto.writeTag(buf, n308, 15, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4591, v4592, v4590, buffer.len(v4590))
			elseif p466.kind.type == "open_profile_action" then
				local v4593 = p466.kind.value:encode()
				local v4594, v4595 = proto.writeTag(buf, n308, 16, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4594, v4595, v4593, buffer.len(v4593))
			elseif p466.kind.type == "open_facial_age_estimation_action" then
				local v4596 = p466.kind.value:encode()
				local v4597, v4598 = proto.writeTag(buf, n308, 17, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4597, v4598, v4596, buffer.len(v4596))
			elseif p466.kind.type == "open_add_connections_page_action" then
				local v4599 = p466.kind.value:encode()
				local v4600, v4601 = proto.writeTag(buf, n308, 18, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4600, v4601, v4599, buffer.len(v4599))
			elseif p466.kind.type == "open_marketplace_action" then
				local v4602 = p466.kind.value:encode()
				local v4603, v4604 = proto.writeTag(buf, n308, 19, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4603, v4604, v4602, buffer.len(v4602))
			elseif p466.kind.type == "hide_profile_completion_action" then
				local v4605 = p466.kind.value:encode()
				local v4606, v4607 = proto.writeTag(buf, n308, 20, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4606, v4607, v4605, buffer.len(v4605))
			elseif p466.kind.type == "select_marketplace_catalog_category" then
				local v4608 = p466.kind.value:encode()
				local v4609, v4610 = proto.writeTag(buf, n308, 21, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4609, v4610, v4608, buffer.len(v4608))
			elseif p466.kind.type == "select_marketplace_catalog_subcategory" then
				local v4611 = p466.kind.value:encode()
				local v4612, v4613 = proto.writeTag(buf, n308, 22, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4612, v4613, v4611, buffer.len(v4611))
			elseif p466.kind.type == "open_marketplace_catalog_see_all" then
				local v4614 = p466.kind.value:encode()
				local v4615, v4616 = proto.writeTag(buf, n308, 23, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4615, v4616, v4614, buffer.len(v4614))
			elseif p466.kind.type == "close_marketplace_category_tooltip" then
				local v4617 = p466.kind.value:encode()
				local v4618, v4619 = proto.writeTag(buf, n308, 24, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4618, v4619, v4617, buffer.len(v4617))
			elseif p466.kind.type == "resize_marketplace_catalog" then
				local v4620 = p466.kind.value:encode()
				local v4621, v4622 = proto.writeTag(buf, n308, 25, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4621, v4622, v4620, buffer.len(v4620))
			elseif p466.kind.type == "open_marketplace_catalog_filters" then
				local v4623 = p466.kind.value:encode()
				local v4624, v4625 = proto.writeTag(buf, n308, 26, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4624, v4625, v4623, buffer.len(v4623))
			elseif p466.kind.type == "open_social_link_action" then
				local v4626 = p466.kind.value:encode()
				local v4627, v4628 = proto.writeTag(buf, n308, 27, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4627, v4628, v4626, buffer.len(v4626))
			elseif p466.kind.type == "open_charts_sort_detail_action" then
				local v4629 = p466.kind.value:encode()
				local v4630, v4631 = proto.writeTag(buf, n308, 28, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4630, v4631, v4629, buffer.len(v4629))
			elseif p466.kind.type == "open_song_detail_action" then
				local v4632 = p466.kind.value:encode()
				local v4633, v4634 = proto.writeTag(buf, n308, 29, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4633, v4634, v4632, buffer.len(v4632))
			elseif p466.kind.type == "refresh_from_api_action" then
				local v4635 = p466.kind.value:encode()
				local v4636, v4637 = proto.writeTag(buf, n308, 30, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4636, v4637, v4635, buffer.len(v4635))
			elseif p466.kind.type == "rsvp_to_event_action" then
				local v4638 = p466.kind.value:encode()
				local v4639, v4640 = proto.writeTag(buf, n308, 31, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4639, v4640, v4638, buffer.len(v4638))
			elseif p466.kind.type == "apply_charts_filter_action" then
				local v4641 = p466.kind.value:encode()
				local v4642, v4643 = proto.writeTag(buf, n308, 32, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4642, v4643, v4641, buffer.len(v4641))
			elseif p466.kind.type == "analytics_event_action" then
				local v4644 = p466.kind.value:encode()
				local v4645, v4646 = proto.writeTag(buf, n308, 33, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4645, v4646, v4644, buffer.len(v4644))
			elseif p466.kind.type == "custom_analytics_event_action" then
				local v4647 = p466.kind.value:encode()
				local v4648, v4649 = proto.writeTag(buf, n308, 34, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4648, v4649, v4647, buffer.len(v4647))
			elseif p466.kind.type == "open_game_invite_action" then
				local v4650 = p466.kind.value:encode()
				local v4651, v4652 = proto.writeTag(buf, n308, 35, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4651, v4652, v4650, buffer.len(v4650))
			elseif p466.kind.type == "open_event_details_action" then
				local v4653 = p466.kind.value:encode()
				local v4654, v4655 = proto.writeTag(buf, n308, 36, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4654, v4655, v4653, buffer.len(v4653))
			elseif p466.kind.type == "launch_experience_action" then
				local v4656 = p466.kind.value:encode()
				local v4657, v4658 = proto.writeTag(buf, n308, 37, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4657, v4658, v4656, buffer.len(v4656))
			elseif p466.kind.type == "toggle_experience_favorite_action" then
				local v4659 = p466.kind.value:encode()
				local v4660, v4661 = proto.writeTag(buf, n308, 38, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4660, v4661, v4659, buffer.len(v4659))
			elseif p466.kind.type == "toggle_experience_follow_action" then
				local v4662 = p466.kind.value:encode()
				local v4663, v4664 = proto.writeTag(buf, n308, 39, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4663, v4664, v4662, buffer.len(v4662))
			elseif p466.kind.type == "toggle_experience_vote_action" then
				local v4665 = p466.kind.value:encode()
				local v4666, v4667 = proto.writeTag(buf, n308, 40, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4666, v4667, v4665, buffer.len(v4665))
			elseif p466.kind.type == "open_purchase_prompt_action" then
				local v4668 = p466.kind.value:encode()
				local v4669, v4670 = proto.writeTag(buf, n308, 41, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4669, v4670, v4668, buffer.len(v4668))
			elseif p466.kind.type == "open_sdui_overlay_action" then
				local v4671 = p466.kind.value:encode()
				local v4672, v4673 = proto.writeTag(buf, n308, 42, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4672, v4673, v4671, buffer.len(v4671))
			elseif p466.kind.type == "open_badges_see_all_action" then
				local v4674 = p466.kind.value:encode()
				local v4675, v4676 = proto.writeTag(buf, n308, 43, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4675, v4676, v4674, buffer.len(v4674))
			elseif p466.kind.type == "open_experience_store_see_all_action" then
				local v4677 = p466.kind.value:encode()
				local v4678, v4679 = proto.writeTag(buf, n308, 44, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4678, v4679, v4677, buffer.len(v4677))
			elseif p466.kind.type == "dismiss_game_feedback_action" then
				local v4680 = p466.kind.value:encode()
				local v4681, v4682 = proto.writeTag(buf, n308, 45, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4681, v4682, v4680, buffer.len(v4680))
			elseif p466.kind.type == "open_game_feedback_form_action" then
				local v4683 = p466.kind.value:encode()
				local v4684, v4685 = proto.writeTag(buf, n308, 46, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4684, v4685, v4683, buffer.len(v4683))
			elseif p466.kind.type == "enable_event_notifications_action" then
				local v4686 = p466.kind.value:encode()
				local v4687, v4688 = proto.writeTag(buf, n308, 47, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4687, v4688, v4686, buffer.len(v4686))
			elseif p466.kind.type == "dismiss_event_notifications_modal_action" then
				local v4689 = p466.kind.value:encode()
				local v4690, v4691 = proto.writeTag(buf, n308, 48, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4690, v4691, v4689, buffer.len(v4689))
			elseif p466.kind.type == "open_amp_wizard_action" then
				local v4692 = p466.kind.value:encode()
				local v4693, v4694 = proto.writeTag(buf, n308, 49, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4693, v4694, v4692, buffer.len(v4692))
			elseif p466.kind.type == "open_subscription_purchase_page_action" then
				local v4695 = p466.kind.value:encode()
				local v4696, v4697 = proto.writeTag(buf, n308, 50, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4696, v4697, v4695, buffer.len(v4695))
			elseif p466.kind.type == "refresh_game_passes_action" then
				local v4698 = p466.kind.value:encode()
				local v4699, v4700 = proto.writeTag(buf, n308, 51, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4699, v4700, v4698, buffer.len(v4698))
			elseif p466.kind.type == "refresh_playability_action" then
				local v4701 = p466.kind.value:encode()
				local v4702, v4703 = proto.writeTag(buf, n308, 52, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4702, v4703, v4701, buffer.len(v4701))
			elseif p466.kind.type == "open_social_proof_user_list_sheet_action" then
				local v4704 = p466.kind.value:encode()
				local v4705, v4706 = proto.writeTag(buf, n308, 53, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4705, v4706, v4704, buffer.len(v4704))
			elseif p466.kind.type == "report_surface_load_time_milestone_action" then
				local v4707 = p466.kind.value:encode()
				local v4708, v4709 = proto.writeTag(buf, n308, 54, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4708, v4709, v4707, buffer.len(v4707))
			elseif p466.kind.type == "open_search_results_tab_action" then
				local v4710 = p466.kind.value:encode()
				local v4711, v4712 = proto.writeTag(buf, n308, 55, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4711, v4712, v4710, buffer.len(v4710))
			elseif p466.kind.type == "open_phone_upsell_modal_action" then
				local v4713 = p466.kind.value:encode()
				local v4714, v4715 = proto.writeTag(buf, n308, 56, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4714, v4715, v4713, buffer.len(v4713))
			elseif p466.kind.type == "open_email_upsell_modal_action" then
				local v4716 = p466.kind.value:encode()
				local v4717, v4718 = proto.writeTag(buf, n308, 57, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4717, v4718, v4716, buffer.len(v4716))
			elseif p466.kind.type == "dismiss_prompt_action" then
				local v4719 = p466.kind.value:encode()
				local v4720, v4721 = proto.writeTag(buf, n308, 58, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4720, v4721, v4719, buffer.len(v4719))
			elseif p466.kind.type == "request_friendship_action" then
				local v4722 = p466.kind.value:encode()
				local v4723, v4724 = proto.writeTag(buf, n308, 59, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4723, v4724, v4722, buffer.len(v4722))
			elseif p466.kind.type == "refresh_developer_products_action" then
				local v4725 = p466.kind.value:encode()
				local v4726, v4727 = proto.writeTag(buf, n308, 60, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4726, v4727, v4725, buffer.len(v4725))
			elseif p466.kind.type == "open_fae_trial_upsell_action" then
				local v4728 = p466.kind.value:encode()
				local v4729, v4730 = proto.writeTag(buf, n308, 61, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4729, v4730, v4728, buffer.len(v4728))
			elseif p466.kind.type == "refresh_omni_recommendation_feed_item_action" then
				local v4731 = p466.kind.value:encode()
				local v4732, v4733 = proto.writeTag(buf, n308, 62, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4732, v4733, v4731, buffer.len(v4731))
			elseif p466.kind.type == "ai_overview_feedback_action" then
				local v4734 = p466.kind.value:encode()
				local v4735, v4736 = proto.writeTag(buf, n308, 63, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4735, v4736, v4734, buffer.len(v4734))
			elseif p466.kind.type == "open_trusted_friends_upsell_modal_action" then
				local v4737 = p466.kind.value:encode()
				local v4738, v4739 = proto.writeTag(buf, n308, 64, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4738, v4739, v4737, buffer.len(v4737))
			elseif p466.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				local v4740 = p466.kind.value:encode()
				local v4741, v4742 = proto.writeTag(buf, n308, 65, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4741, v4742, v4740, buffer.len(v4740))
			elseif p466.kind.type == "open_search_results_with_query_action" then
				local v4743 = p466.kind.value:encode()
				local v4744, v4745 = proto.writeTag(buf, n308, 66, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4744, v4745, v4743, buffer.len(v4743))
			elseif p466.kind.type == "select_marketplace_favorites_category" then
				local v4746 = p466.kind.value:encode()
				local v4747, v4748 = proto.writeTag(buf, n308, 67, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4747, v4748, v4746, buffer.len(v4746))
			elseif p466.kind.type == "download_app_action" then
				local v4749 = p466.kind.value:encode()
				local v4750, v4751 = proto.writeTag(buf, n308, 68, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4750, v4751, v4749, buffer.len(v4749))
			elseif p466.kind.type == "refresh_charts_sort_detail_action" then
				local v4752 = p466.kind.value:encode()
				local v4753, v4754 = proto.writeTag(buf, n308, 69, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4753, v4754, v4752, buffer.len(v4752))
			elseif p466.kind.type == "join_community_action" then
				local v4755 = p466.kind.value:encode()
				local v4756, v4757 = proto.writeTag(buf, n308, 70, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4756, v4757, v4755, buffer.len(v4755))
			elseif p466.kind.type == "view_community_action" then
				local v4758 = p466.kind.value:encode()
				local v4759, v4760 = proto.writeTag(buf, n308, 71, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4759, v4760, v4758, buffer.len(v4758))
			elseif p466.kind.type == "pin_experience_shortcut_action" then
				local v4761 = p466.kind.value:encode()
				local v4762, v4763 = proto.writeTag(buf, n308, 72, proto.wireTypes.lengthDelimited)

				buf, n308 = proto.writeBuffer(v4762, v4763, v4761, buffer.len(v4761))
			end
		end

		if p466.telemetry_handler ~= nil then
			local v4764 = p466.telemetry_handler:encode()
			local v4765, v4766 = proto.writeTag(buf, n308, 1000, proto.wireTypes.lengthDelimited)

			buf, n308 = proto.writeBuffer(v4765, v4766, v4764, buffer.len(v4764))
		end

		if p466.accessibility_label ~= nil then
			local v4767 = p466.accessibility_label:encode()
			local v4768, v4769 = proto.writeTag(buf, n308, 1001, proto.wireTypes.lengthDelimited)

			buf, n308 = proto.writeBuffer(v4768, v4769, v4767, buffer.len(v4767))
		end

		local buf157 = buffer.create(n308)

		buffer.copy(buf157, 0, buf, 0, n308)

		return buf157
	end
	function t619.decode(p467: buffer) -- line: 28781
		-- upvalues: t619 (copy), proto (copy), t1 (copy), prop_types (copy)
		local v4772 = t619.new()
		local n309 = 0

		while n309 < buffer.len(p467) do
			local v4774, v4775

			v4774, v4775, n309 = proto.readTag(p467, n309)

			if v4775 == proto.wireTypes.varint then
				local v4776

				v4776, n309 = proto.readVarInt(p467, n309)
			elseif v4775 == proto.wireTypes.lengthDelimited then
				if v4774 == 1 then
					local v4777

					v4777, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "dismiss_dialog_action",
						value = t1.DismissDialogAction.decode(v4777)
					}
				elseif v4774 == 2 then
					local v4778

					v4778, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "link_action",
						value = t1.LinkAction.decode(v4778)
					}
				elseif v4774 == 3 then
					local v4779

					v4779, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_game_details_action",
						value = t1.OpenGameDetailsAction.decode(v4779)
					}
				elseif v4774 == 4 then
					local v4780

					v4780, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_join_friends_action",
						value = t1.OpenJoinFriendsAction.decode(v4780)
					}
				elseif v4774 == 5 then
					local v4781

					v4781, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_marketplace_try_on_action",
						value = t1.OpenMarketplaceTryOnAction.decode(v4781)
					}
				elseif v4774 == 6 then
					local v4782

					v4782, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_see_all_action",
						value = t1.OpenSeeAllAction.decode(v4782)
					}
				elseif v4774 == 7 then
					local v4783

					v4783, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_sponsored_tooltip_action",
						value = t1.OpenSponsoredTooltipAction.decode(v4783)
					}
				elseif v4774 == 8 then
					local v4784

					v4784, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "play_button_click_action",
						value = t1.PlayButtonClickAction.decode(v4784)
					}
				elseif v4774 == 9 then
					local v4785

					v4785, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "update_user_settings_action",
						value = t1.UpdateUserSettingsAction.decode(v4785)
					}
				elseif v4774 == 10 then
					local v4786

					v4786, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_tooltip_action",
						value = t1.OpenTooltipAction.decode(v4786)
					}
				elseif v4774 == 11 then
					local v4787

					v4787, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_badge_details_action",
						value = t1.OpenBadgeDetailsAction.decode(v4787)
					}
				elseif v4774 == 12 then
					local v4788

					v4788, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "load_more_from_api_action",
						value = t1.LoadMoreFromApiAction.decode(v4788)
					}
				elseif v4774 == 13 then
					local v4789

					v4789, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "share_action",
						value = t1.ShareAction.decode(v4789)
					}
				elseif v4774 == 14 then
					local v4790

					v4790, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_abuse_report_action",
						value = t1.OpenAbuseReportAction.decode(v4790)
					}
				elseif v4774 == 15 then
					local v4791

					v4791, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "remove_badge_from_inventory_action",
						value = t1.RemoveBadgeFromInventoryAction.decode(v4791)
					}
				elseif v4774 == 16 then
					local v4792

					v4792, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_profile_action",
						value = t1.OpenProfileAction.decode(v4792)
					}
				elseif v4774 == 17 then
					local v4793

					v4793, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_facial_age_estimation_action",
						value = t1.OpenFacialAgeEstimationAction.decode(v4793)
					}
				elseif v4774 == 18 then
					local v4794

					v4794, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_add_connections_page_action",
						value = t1.OpenAddConnectionsPageAction.decode(v4794)
					}
				elseif v4774 == 19 then
					local v4795

					v4795, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_marketplace_action",
						value = t1.OpenMarketplaceAction.decode(v4795)
					}
				elseif v4774 == 20 then
					local v4796

					v4796, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "hide_profile_completion_action",
						value = t1.HideProfileCompletionAction.decode(v4796)
					}
				elseif v4774 == 21 then
					local v4797

					v4797, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "select_marketplace_catalog_category",
						value = t1.SelectMarketplaceCatalogCategory.decode(v4797)
					}
				elseif v4774 == 22 then
					local v4798

					v4798, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "select_marketplace_catalog_subcategory",
						value = t1.SelectMarketplaceCatalogSubcategory.decode(v4798)
					}
				elseif v4774 == 23 then
					local v4799

					v4799, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_marketplace_catalog_see_all",
						value = t1.OpenMarketplaceCatalogSeeAll.decode(v4799)
					}
				elseif v4774 == 24 then
					local v4800

					v4800, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "close_marketplace_category_tooltip",
						value = t1.CloseMarketplaceCategoryTooltip.decode(v4800)
					}
				elseif v4774 == 25 then
					local v4801

					v4801, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "resize_marketplace_catalog",
						value = t1.ResizeMarketplaceCatalog.decode(v4801)
					}
				elseif v4774 == 26 then
					local v4802

					v4802, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_marketplace_catalog_filters",
						value = t1.OpenMarketplaceCatalogFilters.decode(v4802)
					}
				elseif v4774 == 27 then
					local v4803

					v4803, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_social_link_action",
						value = t1.OpenSocialLinkAction.decode(v4803)
					}
				elseif v4774 == 28 then
					local v4804

					v4804, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_charts_sort_detail_action",
						value = t1.OpenChartsSortDetailAction.decode(v4804)
					}
				elseif v4774 == 29 then
					local v4805

					v4805, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_song_detail_action",
						value = t1.OpenSongDetailAction.decode(v4805)
					}
				elseif v4774 == 30 then
					local v4806

					v4806, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_from_api_action",
						value = t1.RefreshFromApiAction.decode(v4806)
					}
				elseif v4774 == 31 then
					local v4807

					v4807, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "rsvp_to_event_action",
						value = t1.RsvpToEventAction.decode(v4807)
					}
				elseif v4774 == 32 then
					local v4808

					v4808, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "apply_charts_filter_action",
						value = t1.ApplyChartsFilterAction.decode(v4808)
					}
				elseif v4774 == 33 then
					local v4809

					v4809, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "analytics_event_action",
						value = t1.AnalyticsEventAction.decode(v4809)
					}
				elseif v4774 == 34 then
					local v4810

					v4810, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "custom_analytics_event_action",
						value = t1.CustomAnalyticsEventAction.decode(v4810)
					}
				elseif v4774 == 35 then
					local v4811

					v4811, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_game_invite_action",
						value = t1.OpenGameInviteAction.decode(v4811)
					}
				elseif v4774 == 36 then
					local v4812

					v4812, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_event_details_action",
						value = t1.OpenEventDetailsAction.decode(v4812)
					}
				elseif v4774 == 37 then
					local v4813

					v4813, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "launch_experience_action",
						value = t1.LaunchExperienceAction.decode(v4813)
					}
				elseif v4774 == 38 then
					local v4814

					v4814, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "toggle_experience_favorite_action",
						value = t1.ToggleExperienceFavoriteAction.decode(v4814)
					}
				elseif v4774 == 39 then
					local v4815

					v4815, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "toggle_experience_follow_action",
						value = t1.ToggleExperienceFollowAction.decode(v4815)
					}
				elseif v4774 == 40 then
					local v4816

					v4816, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "toggle_experience_vote_action",
						value = t1.ToggleExperienceVoteAction.decode(v4816)
					}
				elseif v4774 == 41 then
					local v4817

					v4817, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_purchase_prompt_action",
						value = t1.OpenPurchasePromptAction.decode(v4817)
					}
				elseif v4774 == 42 then
					local v4818

					v4818, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_sdui_overlay_action",
						value = t1.OpenSduiOverlayAction.decode(v4818)
					}
				elseif v4774 == 43 then
					local v4819

					v4819, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_badges_see_all_action",
						value = t1.OpenBadgesSeeAllAction.decode(v4819)
					}
				elseif v4774 == 44 then
					local v4820

					v4820, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_experience_store_see_all_action",
						value = t1.OpenExperienceStoreSeeAllAction.decode(v4820)
					}
				elseif v4774 == 45 then
					local v4821

					v4821, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "dismiss_game_feedback_action",
						value = t1.DismissGameFeedbackAction.decode(v4821)
					}
				elseif v4774 == 46 then
					local v4822

					v4822, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_game_feedback_form_action",
						value = t1.OpenGameFeedbackFormAction.decode(v4822)
					}
				elseif v4774 == 47 then
					local v4823

					v4823, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "enable_event_notifications_action",
						value = t1.EnableEventNotificationsAction.decode(v4823)
					}
				elseif v4774 == 48 then
					local v4824

					v4824, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "dismiss_event_notifications_modal_action",
						value = t1.DismissEventNotificationsModalAction.decode(v4824)
					}
				elseif v4774 == 49 then
					local v4825

					v4825, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_amp_wizard_action",
						value = t1.OpenAmpWizardAction.decode(v4825)
					}
				elseif v4774 == 50 then
					local v4826

					v4826, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_subscription_purchase_page_action",
						value = t1.OpenSubscriptionPurchasePageAction.decode(v4826)
					}
				elseif v4774 == 51 then
					local v4827

					v4827, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_game_passes_action",
						value = t1.RefreshGamePassesAction.decode(v4827)
					}
				elseif v4774 == 52 then
					local v4828

					v4828, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_playability_action",
						value = t1.RefreshPlayabilityAction.decode(v4828)
					}
				elseif v4774 == 53 then
					local v4829

					v4829, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_social_proof_user_list_sheet_action",
						value = t1.OpenSocialProofUserListSheetAction.decode(v4829)
					}
				elseif v4774 == 54 then
					local v4830

					v4830, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "report_surface_load_time_milestone_action",
						value = t1.ReportSurfaceLoadTimeMilestoneAction.decode(v4830)
					}
				elseif v4774 == 55 then
					local v4831

					v4831, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_search_results_tab_action",
						value = t1.OpenSearchResultsTabAction.decode(v4831)
					}
				elseif v4774 == 56 then
					local v4832

					v4832, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_phone_upsell_modal_action",
						value = t1.OpenPhoneUpsellModalAction.decode(v4832)
					}
				elseif v4774 == 57 then
					local v4833

					v4833, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_email_upsell_modal_action",
						value = t1.OpenEmailUpsellModalAction.decode(v4833)
					}
				elseif v4774 == 58 then
					local v4834

					v4834, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "dismiss_prompt_action",
						value = t1.DismissPromptAction.decode(v4834)
					}
				elseif v4774 == 59 then
					local v4835

					v4835, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "request_friendship_action",
						value = t1.RequestFriendshipAction.decode(v4835)
					}
				elseif v4774 == 60 then
					local v4836

					v4836, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_developer_products_action",
						value = t1.RefreshDeveloperProductsAction.decode(v4836)
					}
				elseif v4774 == 61 then
					local v4837

					v4837, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_fae_trial_upsell_action",
						value = t1.OpenFaeTrialUpsellAction.decode(v4837)
					}
				elseif v4774 == 62 then
					local v4838

					v4838, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_omni_recommendation_feed_item_action",
						value = t1.RefreshOmniRecommendationFeedItemAction.decode(v4838)
					}
				elseif v4774 == 63 then
					local v4839

					v4839, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "ai_overview_feedback_action",
						value = t1.AiOverviewFeedbackAction.decode(v4839)
					}
				elseif v4774 == 64 then
					local v4840

					v4840, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_trusted_friends_upsell_modal_action",
						value = t1.OpenTrustedFriendsUpsellModalAction.decode(v4840)
					}
				elseif v4774 == 65 then
					local v4841

					v4841, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "record_party_chat_conversation_upsell_acknowledgement_action",
						value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.decode(v4841)
					}
				elseif v4774 == 66 then
					local v4842

					v4842, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "open_search_results_with_query_action",
						value = t1.OpenSearchResultsWithQueryAction.decode(v4842)
					}
				elseif v4774 == 67 then
					local v4843

					v4843, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "select_marketplace_favorites_category",
						value = t1.SelectMarketplaceFavoritesCategory.decode(v4843)
					}
				elseif v4774 == 68 then
					local v4844

					v4844, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "download_app_action",
						value = t1.DownloadAppAction.decode(v4844)
					}
				elseif v4774 == 69 then
					local v4845

					v4845, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "refresh_charts_sort_detail_action",
						value = t1.RefreshChartsSortDetailAction.decode(v4845)
					}
				elseif v4774 == 70 then
					local v4846

					v4846, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "join_community_action",
						value = t1.JoinCommunityAction.decode(v4846)
					}
				elseif v4774 == 71 then
					local v4847

					v4847, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "view_community_action",
						value = t1.ViewCommunityAction.decode(v4847)
					}
				elseif v4774 == 72 then
					local v4848

					v4848, n309 = proto.readBuffer(p467, n309)
					v4772.kind = {
						type = "pin_experience_shortcut_action",
						value = t1.PinExperienceShortcutAction.decode(v4848)
					}
				elseif v4774 == 1000 then
					local v4849

					v4849, n309 = proto.readBuffer(p467, n309)
					v4772.telemetry_handler = prop_types.StringProp.decode(v4849)
				elseif v4774 == 1001 then
					local v4850

					v4850, n309 = proto.readBuffer(p467, n309)
					v4772.accessibility_label = prop_types.StringFormat.decode(v4850)
				else
					local v4851, v4852 = proto.readVarInt(p467, n309)

					n309 = v4852 + v4851
				end
			elseif v4775 == proto.wireTypes.i32 then
				local v4853

				v4853, n309 = proto.readFixed32(p467, n309)
			elseif v4775 == proto.wireTypes.i64 then
				local v4854

				v4854, n309 = proto.readFixed64(p467, n309)
			else
				error("Unsupported wire type: " .. v4775)
			end
		end

		return v4772
	end
	function t619.jsonEncode(p468) -- line: 29327
		local t621 = {}

		if p468.kind ~= nil then
			if p468.kind.type == "dismiss_dialog_action" then
				t621.dismissDialogAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "link_action" then
				t621.linkAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_game_details_action" then
				t621.openGameDetailsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_join_friends_action" then
				t621.openJoinFriendsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_marketplace_try_on_action" then
				t621.openMarketplaceTryOnAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_see_all_action" then
				t621.openSeeAllAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_sponsored_tooltip_action" then
				t621.openSponsoredTooltipAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "play_button_click_action" then
				t621.playButtonClickAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "update_user_settings_action" then
				t621.updateUserSettingsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_tooltip_action" then
				t621.openTooltipAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_badge_details_action" then
				t621.openBadgeDetailsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "load_more_from_api_action" then
				t621.loadMoreFromApiAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "share_action" then
				t621.shareAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_abuse_report_action" then
				t621.openAbuseReportAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "remove_badge_from_inventory_action" then
				t621.removeBadgeFromInventoryAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_profile_action" then
				t621.openProfileAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_facial_age_estimation_action" then
				t621.openFacialAgeEstimationAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_add_connections_page_action" then
				t621.openAddConnectionsPageAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_marketplace_action" then
				t621.openMarketplaceAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "hide_profile_completion_action" then
				t621.hideProfileCompletionAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "select_marketplace_catalog_category" then
				t621.selectMarketplaceCatalogCategory = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "select_marketplace_catalog_subcategory" then
				t621.selectMarketplaceCatalogSubcategory = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_marketplace_catalog_see_all" then
				t621.openMarketplaceCatalogSeeAll = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "close_marketplace_category_tooltip" then
				t621.closeMarketplaceCategoryTooltip = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "resize_marketplace_catalog" then
				t621.resizeMarketplaceCatalog = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_marketplace_catalog_filters" then
				t621.openMarketplaceCatalogFilters = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_social_link_action" then
				t621.openSocialLinkAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_charts_sort_detail_action" then
				t621.openChartsSortDetailAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_song_detail_action" then
				t621.openSongDetailAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_from_api_action" then
				t621.refreshFromApiAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "rsvp_to_event_action" then
				t621.rsvpToEventAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "apply_charts_filter_action" then
				t621.applyChartsFilterAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "analytics_event_action" then
				t621.analyticsEventAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "custom_analytics_event_action" then
				t621.customAnalyticsEventAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_game_invite_action" then
				t621.openGameInviteAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_event_details_action" then
				t621.openEventDetailsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "launch_experience_action" then
				t621.launchExperienceAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "toggle_experience_favorite_action" then
				t621.toggleExperienceFavoriteAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "toggle_experience_follow_action" then
				t621.toggleExperienceFollowAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "toggle_experience_vote_action" then
				t621.toggleExperienceVoteAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_purchase_prompt_action" then
				t621.openPurchasePromptAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_sdui_overlay_action" then
				t621.openSduiOverlayAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_badges_see_all_action" then
				t621.openBadgesSeeAllAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_experience_store_see_all_action" then
				t621.openExperienceStoreSeeAllAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "dismiss_game_feedback_action" then
				t621.dismissGameFeedbackAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_game_feedback_form_action" then
				t621.openGameFeedbackFormAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "enable_event_notifications_action" then
				t621.enableEventNotificationsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "dismiss_event_notifications_modal_action" then
				t621.dismissEventNotificationsModalAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_amp_wizard_action" then
				t621.openAmpWizardAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_subscription_purchase_page_action" then
				t621.openSubscriptionPurchasePageAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_game_passes_action" then
				t621.refreshGamePassesAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_playability_action" then
				t621.refreshPlayabilityAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_social_proof_user_list_sheet_action" then
				t621.openSocialProofUserListSheetAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "report_surface_load_time_milestone_action" then
				t621.reportSurfaceLoadTimeMilestoneAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_search_results_tab_action" then
				t621.openSearchResultsTabAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_phone_upsell_modal_action" then
				t621.openPhoneUpsellModalAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_email_upsell_modal_action" then
				t621.openEmailUpsellModalAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "dismiss_prompt_action" then
				t621.dismissPromptAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "request_friendship_action" then
				t621.requestFriendshipAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_developer_products_action" then
				t621.refreshDeveloperProductsAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_fae_trial_upsell_action" then
				t621.openFaeTrialUpsellAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_omni_recommendation_feed_item_action" then
				t621.refreshOmniRecommendationFeedItemAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "ai_overview_feedback_action" then
				t621.aiOverviewFeedbackAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_trusted_friends_upsell_modal_action" then
				t621.openTrustedFriendsUpsellModalAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "record_party_chat_conversation_upsell_acknowledgement_action" then
				t621.recordPartyChatConversationUpsellAcknowledgementAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "open_search_results_with_query_action" then
				t621.openSearchResultsWithQueryAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "select_marketplace_favorites_category" then
				t621.selectMarketplaceFavoritesCategory = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "download_app_action" then
				t621.downloadAppAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "refresh_charts_sort_detail_action" then
				t621.refreshChartsSortDetailAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "join_community_action" then
				t621.joinCommunityAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "view_community_action" then
				t621.viewCommunityAction = p468.kind.value:jsonEncode()
			elseif p468.kind.type == "pin_experience_shortcut_action" then
				t621.pinExperienceShortcutAction = p468.kind.value:jsonEncode()
			end
		end

		if p468.telemetry_handler ~= nil then
			t621.telemetryHandler = p468.telemetry_handler:jsonEncode()
		end

		if p468.accessibility_label ~= nil then
			t621.accessibilityLabel = p468.accessibility_label:jsonEncode()
		end

		return t621
	end
	function t619.jsonDecode(t622: {[any]: any}) -- line: 29489
		-- upvalues: t619 (copy), t1 (copy), prop_types (copy)
		local v4858 = t619.new()

		if t622.dismiss_dialog_action ~= nil then
			v4858.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t622.dismiss_dialog_action)
			}
		end

		if t622.dismissDialogAction ~= nil then
			v4858.kind = {
				type = "dismiss_dialog_action",
				value = t1.DismissDialogAction.jsonDecode(t622.dismissDialogAction)
			}
		end

		if t622.link_action ~= nil then
			v4858.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t622.link_action)
			}
		end

		if t622.linkAction ~= nil then
			v4858.kind = {
				type = "link_action",
				value = t1.LinkAction.jsonDecode(t622.linkAction)
			}
		end

		if t622.open_game_details_action ~= nil then
			v4858.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t622.open_game_details_action)
			}
		end

		if t622.openGameDetailsAction ~= nil then
			v4858.kind = {
				type = "open_game_details_action",
				value = t1.OpenGameDetailsAction.jsonDecode(t622.openGameDetailsAction)
			}
		end

		if t622.open_join_friends_action ~= nil then
			v4858.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t622.open_join_friends_action)
			}
		end

		if t622.openJoinFriendsAction ~= nil then
			v4858.kind = {
				type = "open_join_friends_action",
				value = t1.OpenJoinFriendsAction.jsonDecode(t622.openJoinFriendsAction)
			}
		end

		if t622.open_marketplace_try_on_action ~= nil then
			v4858.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t622.open_marketplace_try_on_action)
			}
		end

		if t622.openMarketplaceTryOnAction ~= nil then
			v4858.kind = {
				type = "open_marketplace_try_on_action",
				value = t1.OpenMarketplaceTryOnAction.jsonDecode(t622.openMarketplaceTryOnAction)
			}
		end

		if t622.open_see_all_action ~= nil then
			v4858.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t622.open_see_all_action)
			}
		end

		if t622.openSeeAllAction ~= nil then
			v4858.kind = {
				type = "open_see_all_action",
				value = t1.OpenSeeAllAction.jsonDecode(t622.openSeeAllAction)
			}
		end

		if t622.open_sponsored_tooltip_action ~= nil then
			v4858.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t622.open_sponsored_tooltip_action)
			}
		end

		if t622.openSponsoredTooltipAction ~= nil then
			v4858.kind = {
				type = "open_sponsored_tooltip_action",
				value = t1.OpenSponsoredTooltipAction.jsonDecode(t622.openSponsoredTooltipAction)
			}
		end

		if t622.play_button_click_action ~= nil then
			v4858.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t622.play_button_click_action)
			}
		end

		if t622.playButtonClickAction ~= nil then
			v4858.kind = {
				type = "play_button_click_action",
				value = t1.PlayButtonClickAction.jsonDecode(t622.playButtonClickAction)
			}
		end

		if t622.update_user_settings_action ~= nil then
			v4858.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t622.update_user_settings_action)
			}
		end

		if t622.updateUserSettingsAction ~= nil then
			v4858.kind = {
				type = "update_user_settings_action",
				value = t1.UpdateUserSettingsAction.jsonDecode(t622.updateUserSettingsAction)
			}
		end

		if t622.open_tooltip_action ~= nil then
			v4858.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t622.open_tooltip_action)
			}
		end

		if t622.openTooltipAction ~= nil then
			v4858.kind = {
				type = "open_tooltip_action",
				value = t1.OpenTooltipAction.jsonDecode(t622.openTooltipAction)
			}
		end

		if t622.open_badge_details_action ~= nil then
			v4858.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t622.open_badge_details_action)
			}
		end

		if t622.openBadgeDetailsAction ~= nil then
			v4858.kind = {
				type = "open_badge_details_action",
				value = t1.OpenBadgeDetailsAction.jsonDecode(t622.openBadgeDetailsAction)
			}
		end

		if t622.load_more_from_api_action ~= nil then
			v4858.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t622.load_more_from_api_action)
			}
		end

		if t622.loadMoreFromApiAction ~= nil then
			v4858.kind = {
				type = "load_more_from_api_action",
				value = t1.LoadMoreFromApiAction.jsonDecode(t622.loadMoreFromApiAction)
			}
		end

		if t622.share_action ~= nil then
			v4858.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t622.share_action)
			}
		end

		if t622.shareAction ~= nil then
			v4858.kind = {
				type = "share_action",
				value = t1.ShareAction.jsonDecode(t622.shareAction)
			}
		end

		if t622.open_abuse_report_action ~= nil then
			v4858.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t622.open_abuse_report_action)
			}
		end

		if t622.openAbuseReportAction ~= nil then
			v4858.kind = {
				type = "open_abuse_report_action",
				value = t1.OpenAbuseReportAction.jsonDecode(t622.openAbuseReportAction)
			}
		end

		if t622.remove_badge_from_inventory_action ~= nil then
			v4858.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t622.remove_badge_from_inventory_action)
			}
		end

		if t622.removeBadgeFromInventoryAction ~= nil then
			v4858.kind = {
				type = "remove_badge_from_inventory_action",
				value = t1.RemoveBadgeFromInventoryAction.jsonDecode(t622.removeBadgeFromInventoryAction)
			}
		end

		if t622.open_profile_action ~= nil then
			v4858.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t622.open_profile_action)
			}
		end

		if t622.openProfileAction ~= nil then
			v4858.kind = {
				type = "open_profile_action",
				value = t1.OpenProfileAction.jsonDecode(t622.openProfileAction)
			}
		end

		if t622.open_facial_age_estimation_action ~= nil then
			v4858.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t622.open_facial_age_estimation_action)
			}
		end

		if t622.openFacialAgeEstimationAction ~= nil then
			v4858.kind = {
				type = "open_facial_age_estimation_action",
				value = t1.OpenFacialAgeEstimationAction.jsonDecode(t622.openFacialAgeEstimationAction)
			}
		end

		if t622.open_add_connections_page_action ~= nil then
			v4858.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t622.open_add_connections_page_action)
			}
		end

		if t622.openAddConnectionsPageAction ~= nil then
			v4858.kind = {
				type = "open_add_connections_page_action",
				value = t1.OpenAddConnectionsPageAction.jsonDecode(t622.openAddConnectionsPageAction)
			}
		end

		if t622.open_marketplace_action ~= nil then
			v4858.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t622.open_marketplace_action)
			}
		end

		if t622.openMarketplaceAction ~= nil then
			v4858.kind = {
				type = "open_marketplace_action",
				value = t1.OpenMarketplaceAction.jsonDecode(t622.openMarketplaceAction)
			}
		end

		if t622.hide_profile_completion_action ~= nil then
			v4858.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t622.hide_profile_completion_action)
			}
		end

		if t622.hideProfileCompletionAction ~= nil then
			v4858.kind = {
				type = "hide_profile_completion_action",
				value = t1.HideProfileCompletionAction.jsonDecode(t622.hideProfileCompletionAction)
			}
		end

		if t622.select_marketplace_catalog_category ~= nil then
			v4858.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t622.select_marketplace_catalog_category)
			}
		end

		if t622.selectMarketplaceCatalogCategory ~= nil then
			v4858.kind = {
				type = "select_marketplace_catalog_category",
				value = t1.SelectMarketplaceCatalogCategory.jsonDecode(t622.selectMarketplaceCatalogCategory)
			}
		end

		if t622.select_marketplace_catalog_subcategory ~= nil then
			v4858.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t622.select_marketplace_catalog_subcategory)
			}
		end

		if t622.selectMarketplaceCatalogSubcategory ~= nil then
			v4858.kind = {
				type = "select_marketplace_catalog_subcategory",
				value = t1.SelectMarketplaceCatalogSubcategory.jsonDecode(t622.selectMarketplaceCatalogSubcategory)
			}
		end

		if t622.open_marketplace_catalog_see_all ~= nil then
			v4858.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t622.open_marketplace_catalog_see_all)
			}
		end

		if t622.openMarketplaceCatalogSeeAll ~= nil then
			v4858.kind = {
				type = "open_marketplace_catalog_see_all",
				value = t1.OpenMarketplaceCatalogSeeAll.jsonDecode(t622.openMarketplaceCatalogSeeAll)
			}
		end

		if t622.close_marketplace_category_tooltip ~= nil then
			v4858.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t622.close_marketplace_category_tooltip)
			}
		end

		if t622.closeMarketplaceCategoryTooltip ~= nil then
			v4858.kind = {
				type = "close_marketplace_category_tooltip",
				value = t1.CloseMarketplaceCategoryTooltip.jsonDecode(t622.closeMarketplaceCategoryTooltip)
			}
		end

		if t622.resize_marketplace_catalog ~= nil then
			v4858.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t622.resize_marketplace_catalog)
			}
		end

		if t622.resizeMarketplaceCatalog ~= nil then
			v4858.kind = {
				type = "resize_marketplace_catalog",
				value = t1.ResizeMarketplaceCatalog.jsonDecode(t622.resizeMarketplaceCatalog)
			}
		end

		if t622.open_marketplace_catalog_filters ~= nil then
			v4858.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t622.open_marketplace_catalog_filters)
			}
		end

		if t622.openMarketplaceCatalogFilters ~= nil then
			v4858.kind = {
				type = "open_marketplace_catalog_filters",
				value = t1.OpenMarketplaceCatalogFilters.jsonDecode(t622.openMarketplaceCatalogFilters)
			}
		end

		if t622.open_social_link_action ~= nil then
			v4858.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t622.open_social_link_action)
			}
		end

		if t622.openSocialLinkAction ~= nil then
			v4858.kind = {
				type = "open_social_link_action",
				value = t1.OpenSocialLinkAction.jsonDecode(t622.openSocialLinkAction)
			}
		end

		if t622.open_charts_sort_detail_action ~= nil then
			v4858.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t622.open_charts_sort_detail_action)
			}
		end

		if t622.openChartsSortDetailAction ~= nil then
			v4858.kind = {
				type = "open_charts_sort_detail_action",
				value = t1.OpenChartsSortDetailAction.jsonDecode(t622.openChartsSortDetailAction)
			}
		end

		if t622.open_song_detail_action ~= nil then
			v4858.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t622.open_song_detail_action)
			}
		end

		if t622.openSongDetailAction ~= nil then
			v4858.kind = {
				type = "open_song_detail_action",
				value = t1.OpenSongDetailAction.jsonDecode(t622.openSongDetailAction)
			}
		end

		if t622.refresh_from_api_action ~= nil then
			v4858.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t622.refresh_from_api_action)
			}
		end

		if t622.refreshFromApiAction ~= nil then
			v4858.kind = {
				type = "refresh_from_api_action",
				value = t1.RefreshFromApiAction.jsonDecode(t622.refreshFromApiAction)
			}
		end

		if t622.rsvp_to_event_action ~= nil then
			v4858.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t622.rsvp_to_event_action)
			}
		end

		if t622.rsvpToEventAction ~= nil then
			v4858.kind = {
				type = "rsvp_to_event_action",
				value = t1.RsvpToEventAction.jsonDecode(t622.rsvpToEventAction)
			}
		end

		if t622.apply_charts_filter_action ~= nil then
			v4858.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t622.apply_charts_filter_action)
			}
		end

		if t622.applyChartsFilterAction ~= nil then
			v4858.kind = {
				type = "apply_charts_filter_action",
				value = t1.ApplyChartsFilterAction.jsonDecode(t622.applyChartsFilterAction)
			}
		end

		if t622.analytics_event_action ~= nil then
			v4858.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t622.analytics_event_action)
			}
		end

		if t622.analyticsEventAction ~= nil then
			v4858.kind = {
				type = "analytics_event_action",
				value = t1.AnalyticsEventAction.jsonDecode(t622.analyticsEventAction)
			}
		end

		if t622.custom_analytics_event_action ~= nil then
			v4858.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t622.custom_analytics_event_action)
			}
		end

		if t622.customAnalyticsEventAction ~= nil then
			v4858.kind = {
				type = "custom_analytics_event_action",
				value = t1.CustomAnalyticsEventAction.jsonDecode(t622.customAnalyticsEventAction)
			}
		end

		if t622.open_game_invite_action ~= nil then
			v4858.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t622.open_game_invite_action)
			}
		end

		if t622.openGameInviteAction ~= nil then
			v4858.kind = {
				type = "open_game_invite_action",
				value = t1.OpenGameInviteAction.jsonDecode(t622.openGameInviteAction)
			}
		end

		if t622.open_event_details_action ~= nil then
			v4858.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t622.open_event_details_action)
			}
		end

		if t622.openEventDetailsAction ~= nil then
			v4858.kind = {
				type = "open_event_details_action",
				value = t1.OpenEventDetailsAction.jsonDecode(t622.openEventDetailsAction)
			}
		end

		if t622.launch_experience_action ~= nil then
			v4858.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t622.launch_experience_action)
			}
		end

		if t622.launchExperienceAction ~= nil then
			v4858.kind = {
				type = "launch_experience_action",
				value = t1.LaunchExperienceAction.jsonDecode(t622.launchExperienceAction)
			}
		end

		if t622.toggle_experience_favorite_action ~= nil then
			v4858.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t622.toggle_experience_favorite_action)
			}
		end

		if t622.toggleExperienceFavoriteAction ~= nil then
			v4858.kind = {
				type = "toggle_experience_favorite_action",
				value = t1.ToggleExperienceFavoriteAction.jsonDecode(t622.toggleExperienceFavoriteAction)
			}
		end

		if t622.toggle_experience_follow_action ~= nil then
			v4858.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t622.toggle_experience_follow_action)
			}
		end

		if t622.toggleExperienceFollowAction ~= nil then
			v4858.kind = {
				type = "toggle_experience_follow_action",
				value = t1.ToggleExperienceFollowAction.jsonDecode(t622.toggleExperienceFollowAction)
			}
		end

		if t622.toggle_experience_vote_action ~= nil then
			v4858.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t622.toggle_experience_vote_action)
			}
		end

		if t622.toggleExperienceVoteAction ~= nil then
			v4858.kind = {
				type = "toggle_experience_vote_action",
				value = t1.ToggleExperienceVoteAction.jsonDecode(t622.toggleExperienceVoteAction)
			}
		end

		if t622.open_purchase_prompt_action ~= nil then
			v4858.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t622.open_purchase_prompt_action)
			}
		end

		if t622.openPurchasePromptAction ~= nil then
			v4858.kind = {
				type = "open_purchase_prompt_action",
				value = t1.OpenPurchasePromptAction.jsonDecode(t622.openPurchasePromptAction)
			}
		end

		if t622.open_sdui_overlay_action ~= nil then
			v4858.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t622.open_sdui_overlay_action)
			}
		end

		if t622.openSduiOverlayAction ~= nil then
			v4858.kind = {
				type = "open_sdui_overlay_action",
				value = t1.OpenSduiOverlayAction.jsonDecode(t622.openSduiOverlayAction)
			}
		end

		if t622.open_badges_see_all_action ~= nil then
			v4858.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t622.open_badges_see_all_action)
			}
		end

		if t622.openBadgesSeeAllAction ~= nil then
			v4858.kind = {
				type = "open_badges_see_all_action",
				value = t1.OpenBadgesSeeAllAction.jsonDecode(t622.openBadgesSeeAllAction)
			}
		end

		if t622.open_experience_store_see_all_action ~= nil then
			v4858.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t622.open_experience_store_see_all_action)
			}
		end

		if t622.openExperienceStoreSeeAllAction ~= nil then
			v4858.kind = {
				type = "open_experience_store_see_all_action",
				value = t1.OpenExperienceStoreSeeAllAction.jsonDecode(t622.openExperienceStoreSeeAllAction)
			}
		end

		if t622.dismiss_game_feedback_action ~= nil then
			v4858.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t622.dismiss_game_feedback_action)
			}
		end

		if t622.dismissGameFeedbackAction ~= nil then
			v4858.kind = {
				type = "dismiss_game_feedback_action",
				value = t1.DismissGameFeedbackAction.jsonDecode(t622.dismissGameFeedbackAction)
			}
		end

		if t622.open_game_feedback_form_action ~= nil then
			v4858.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t622.open_game_feedback_form_action)
			}
		end

		if t622.openGameFeedbackFormAction ~= nil then
			v4858.kind = {
				type = "open_game_feedback_form_action",
				value = t1.OpenGameFeedbackFormAction.jsonDecode(t622.openGameFeedbackFormAction)
			}
		end

		if t622.enable_event_notifications_action ~= nil then
			v4858.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t622.enable_event_notifications_action)
			}
		end

		if t622.enableEventNotificationsAction ~= nil then
			v4858.kind = {
				type = "enable_event_notifications_action",
				value = t1.EnableEventNotificationsAction.jsonDecode(t622.enableEventNotificationsAction)
			}
		end

		if t622.dismiss_event_notifications_modal_action ~= nil then
			v4858.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t622.dismiss_event_notifications_modal_action)
			}
		end

		if t622.dismissEventNotificationsModalAction ~= nil then
			v4858.kind = {
				type = "dismiss_event_notifications_modal_action",
				value = t1.DismissEventNotificationsModalAction.jsonDecode(t622.dismissEventNotificationsModalAction)
			}
		end

		if t622.open_amp_wizard_action ~= nil then
			v4858.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t622.open_amp_wizard_action)
			}
		end

		if t622.openAmpWizardAction ~= nil then
			v4858.kind = {
				type = "open_amp_wizard_action",
				value = t1.OpenAmpWizardAction.jsonDecode(t622.openAmpWizardAction)
			}
		end

		if t622.open_subscription_purchase_page_action ~= nil then
			v4858.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t622.open_subscription_purchase_page_action)
			}
		end

		if t622.openSubscriptionPurchasePageAction ~= nil then
			v4858.kind = {
				type = "open_subscription_purchase_page_action",
				value = t1.OpenSubscriptionPurchasePageAction.jsonDecode(t622.openSubscriptionPurchasePageAction)
			}
		end

		if t622.refresh_game_passes_action ~= nil then
			v4858.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t622.refresh_game_passes_action)
			}
		end

		if t622.refreshGamePassesAction ~= nil then
			v4858.kind = {
				type = "refresh_game_passes_action",
				value = t1.RefreshGamePassesAction.jsonDecode(t622.refreshGamePassesAction)
			}
		end

		if t622.refresh_playability_action ~= nil then
			v4858.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t622.refresh_playability_action)
			}
		end

		if t622.refreshPlayabilityAction ~= nil then
			v4858.kind = {
				type = "refresh_playability_action",
				value = t1.RefreshPlayabilityAction.jsonDecode(t622.refreshPlayabilityAction)
			}
		end

		if t622.open_social_proof_user_list_sheet_action ~= nil then
			v4858.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t622.open_social_proof_user_list_sheet_action)
			}
		end

		if t622.openSocialProofUserListSheetAction ~= nil then
			v4858.kind = {
				type = "open_social_proof_user_list_sheet_action",
				value = t1.OpenSocialProofUserListSheetAction.jsonDecode(t622.openSocialProofUserListSheetAction)
			}
		end

		if t622.report_surface_load_time_milestone_action ~= nil then
			v4858.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t622.report_surface_load_time_milestone_action)
			}
		end

		if t622.reportSurfaceLoadTimeMilestoneAction ~= nil then
			v4858.kind = {
				type = "report_surface_load_time_milestone_action",
				value = t1.ReportSurfaceLoadTimeMilestoneAction.jsonDecode(t622.reportSurfaceLoadTimeMilestoneAction)
			}
		end

		if t622.open_search_results_tab_action ~= nil then
			v4858.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t622.open_search_results_tab_action)
			}
		end

		if t622.openSearchResultsTabAction ~= nil then
			v4858.kind = {
				type = "open_search_results_tab_action",
				value = t1.OpenSearchResultsTabAction.jsonDecode(t622.openSearchResultsTabAction)
			}
		end

		if t622.open_phone_upsell_modal_action ~= nil then
			v4858.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t622.open_phone_upsell_modal_action)
			}
		end

		if t622.openPhoneUpsellModalAction ~= nil then
			v4858.kind = {
				type = "open_phone_upsell_modal_action",
				value = t1.OpenPhoneUpsellModalAction.jsonDecode(t622.openPhoneUpsellModalAction)
			}
		end

		if t622.open_email_upsell_modal_action ~= nil then
			v4858.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t622.open_email_upsell_modal_action)
			}
		end

		if t622.openEmailUpsellModalAction ~= nil then
			v4858.kind = {
				type = "open_email_upsell_modal_action",
				value = t1.OpenEmailUpsellModalAction.jsonDecode(t622.openEmailUpsellModalAction)
			}
		end

		if t622.dismiss_prompt_action ~= nil then
			v4858.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t622.dismiss_prompt_action)
			}
		end

		if t622.dismissPromptAction ~= nil then
			v4858.kind = {
				type = "dismiss_prompt_action",
				value = t1.DismissPromptAction.jsonDecode(t622.dismissPromptAction)
			}
		end

		if t622.request_friendship_action ~= nil then
			v4858.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t622.request_friendship_action)
			}
		end

		if t622.requestFriendshipAction ~= nil then
			v4858.kind = {
				type = "request_friendship_action",
				value = t1.RequestFriendshipAction.jsonDecode(t622.requestFriendshipAction)
			}
		end

		if t622.refresh_developer_products_action ~= nil then
			v4858.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t622.refresh_developer_products_action)
			}
		end

		if t622.refreshDeveloperProductsAction ~= nil then
			v4858.kind = {
				type = "refresh_developer_products_action",
				value = t1.RefreshDeveloperProductsAction.jsonDecode(t622.refreshDeveloperProductsAction)
			}
		end

		if t622.open_fae_trial_upsell_action ~= nil then
			v4858.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t622.open_fae_trial_upsell_action)
			}
		end

		if t622.openFaeTrialUpsellAction ~= nil then
			v4858.kind = {
				type = "open_fae_trial_upsell_action",
				value = t1.OpenFaeTrialUpsellAction.jsonDecode(t622.openFaeTrialUpsellAction)
			}
		end

		if t622.refresh_omni_recommendation_feed_item_action ~= nil then
			v4858.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t622.refresh_omni_recommendation_feed_item_action)
			}
		end

		if t622.refreshOmniRecommendationFeedItemAction ~= nil then
			v4858.kind = {
				type = "refresh_omni_recommendation_feed_item_action",
				value = t1.RefreshOmniRecommendationFeedItemAction.jsonDecode(t622.refreshOmniRecommendationFeedItemAction)
			}
		end

		if t622.ai_overview_feedback_action ~= nil then
			v4858.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t622.ai_overview_feedback_action)
			}
		end

		if t622.aiOverviewFeedbackAction ~= nil then
			v4858.kind = {
				type = "ai_overview_feedback_action",
				value = t1.AiOverviewFeedbackAction.jsonDecode(t622.aiOverviewFeedbackAction)
			}
		end

		if t622.open_trusted_friends_upsell_modal_action ~= nil then
			v4858.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t622.open_trusted_friends_upsell_modal_action)
			}
		end

		if t622.openTrustedFriendsUpsellModalAction ~= nil then
			v4858.kind = {
				type = "open_trusted_friends_upsell_modal_action",
				value = t1.OpenTrustedFriendsUpsellModalAction.jsonDecode(t622.openTrustedFriendsUpsellModalAction)
			}
		end

		if t622.record_party_chat_conversation_upsell_acknowledgement_action ~= nil then
			v4858.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t622.record_party_chat_conversation_upsell_acknowledgement_action)
			}
		end

		if t622.recordPartyChatConversationUpsellAcknowledgementAction ~= nil then
			v4858.kind = {
				type = "record_party_chat_conversation_upsell_acknowledgement_action",
				value = t1.RecordPartyChatConversationUpsellAcknowledgementAction.jsonDecode(t622.recordPartyChatConversationUpsellAcknowledgementAction)
			}
		end

		if t622.open_search_results_with_query_action ~= nil then
			v4858.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t622.open_search_results_with_query_action)
			}
		end

		if t622.openSearchResultsWithQueryAction ~= nil then
			v4858.kind = {
				type = "open_search_results_with_query_action",
				value = t1.OpenSearchResultsWithQueryAction.jsonDecode(t622.openSearchResultsWithQueryAction)
			}
		end

		if t622.select_marketplace_favorites_category ~= nil then
			v4858.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t622.select_marketplace_favorites_category)
			}
		end

		if t622.selectMarketplaceFavoritesCategory ~= nil then
			v4858.kind = {
				type = "select_marketplace_favorites_category",
				value = t1.SelectMarketplaceFavoritesCategory.jsonDecode(t622.selectMarketplaceFavoritesCategory)
			}
		end

		if t622.download_app_action ~= nil then
			v4858.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t622.download_app_action)
			}
		end

		if t622.downloadAppAction ~= nil then
			v4858.kind = {
				type = "download_app_action",
				value = t1.DownloadAppAction.jsonDecode(t622.downloadAppAction)
			}
		end

		if t622.refresh_charts_sort_detail_action ~= nil then
			v4858.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t622.refresh_charts_sort_detail_action)
			}
		end

		if t622.refreshChartsSortDetailAction ~= nil then
			v4858.kind = {
				type = "refresh_charts_sort_detail_action",
				value = t1.RefreshChartsSortDetailAction.jsonDecode(t622.refreshChartsSortDetailAction)
			}
		end

		if t622.join_community_action ~= nil then
			v4858.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t622.join_community_action)
			}
		end

		if t622.joinCommunityAction ~= nil then
			v4858.kind = {
				type = "join_community_action",
				value = t1.JoinCommunityAction.jsonDecode(t622.joinCommunityAction)
			}
		end

		if t622.view_community_action ~= nil then
			v4858.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t622.view_community_action)
			}
		end

		if t622.viewCommunityAction ~= nil then
			v4858.kind = {
				type = "view_community_action",
				value = t1.ViewCommunityAction.jsonDecode(t622.viewCommunityAction)
			}
		end

		if t622.pin_experience_shortcut_action ~= nil then
			v4858.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t622.pin_experience_shortcut_action)
			}
		end

		if t622.pinExperienceShortcutAction ~= nil then
			v4858.kind = {
				type = "pin_experience_shortcut_action",
				value = t1.PinExperienceShortcutAction.jsonDecode(t622.pinExperienceShortcutAction)
			}
		end

		if t622.telemetry_handler ~= nil then
			v4858.telemetry_handler = prop_types.StringProp.jsonDecode(t622.telemetry_handler)
		end

		if t622.telemetryHandler ~= nil then
			v4858.telemetry_handler = prop_types.StringProp.jsonDecode(t622.telemetryHandler)
		end

		if t622.accessibility_label ~= nil then
			v4858.accessibility_label = prop_types.StringFormat.jsonDecode(t622.accessibility_label)
		end

		if t622.accessibilityLabel ~= nil then
			v4858.accessibility_label = prop_types.StringFormat.jsonDecode(t622.accessibilityLabel)
		end

		return v4858
	end

	t619.descriptor = {
		name = "Action",
		fullName = "roblox.apppageplatform.shared.v1beta1.Action"
	}
	t1.Action = t619
end

typeRegistry.default:register(t1.Action)

do
	local t623 = {}

	t623.__index = t623

	function t623.new(t624: {[any]: any}?) -- line: 30555
		-- upvalues: t623 (copy)
		return (setmetatable({
			kind = if t624 ~= nil and t624.kind ~= nil then t624.kind else nil
		}, t623))
	end
	function t623.encode(p469) -- line: 30561
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n310 = 0

		if p469.kind ~= nil then
			if p469.kind.type == "value" then
				local v4863 = p469.kind.value:encode()
				local v4864, v4865 = proto.writeTag(buf, n310, 1, proto.wireTypes.lengthDelimited)

				buf, n310 = proto.writeBuffer(v4864, v4865, v4863, buffer.len(v4863))
			elseif p469.kind.type == "conditional" then
				local v4866 = p469.kind.value:encode()
				local v4867, v4868 = proto.writeTag(buf, n310, 2, proto.wireTypes.lengthDelimited)

				buf, n310 = proto.writeBuffer(v4867, v4868, v4866, buffer.len(v4866))
			end
		end

		local buf158 = buffer.create(n310)

		buffer.copy(buf158, 0, buf, 0, n310)

		return buf158
	end
	function t623.decode(p470: buffer) -- line: 30582
		-- upvalues: t623 (copy), proto (copy), t1 (copy)
		local v4871 = t623.new()
		local n311 = 0

		while n311 < buffer.len(p470) do
			local v4873, v4874

			v4873, v4874, n311 = proto.readTag(p470, n311)

			if v4874 == proto.wireTypes.varint then
				local v4875

				v4875, n311 = proto.readVarInt(p470, n311)
			elseif v4874 == proto.wireTypes.lengthDelimited then
				if v4873 == 1 then
					local v4876

					v4876, n311 = proto.readBuffer(p470, n311)
					v4871.kind = {
						type = "value",
						value = t1.Action.decode(v4876)
					}
				elseif v4873 == 2 then
					local v4877

					v4877, n311 = proto.readBuffer(p470, n311)
					v4871.kind = {
						type = "conditional",
						value = t1.ActionProp_ConditionalOptions.decode(v4877)
					}
				else
					local v4878, v4879 = proto.readVarInt(p470, n311)

					n311 = v4879 + v4878
				end
			elseif v4874 == proto.wireTypes.i32 then
				local v4880

				v4880, n311 = proto.readFixed32(p470, n311)
			elseif v4874 == proto.wireTypes.i64 then
				local v4881

				v4881, n311 = proto.readFixed64(p470, n311)
			else
				error("Unsupported wire type: " .. v4874)
			end
		end

		return v4871
	end
	function t623.jsonEncode(p471) -- line: 30630
		local t625 = {}

		if p471.kind ~= nil then
			if p471.kind.type == "value" then
				t625.value = p471.kind.value:jsonEncode()

				return t625
			end

			if p471.kind.type == "conditional" then
				t625.conditional = p471.kind.value:jsonEncode()
			end
		end

		return t625
	end
	function t623.jsonDecode(t626: {[any]: any}) -- line: 30644
		-- upvalues: t623 (copy), t1 (copy)
		local v4885 = t623.new()

		if t626.value ~= nil then
			v4885.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t626.value)
			}
		end

		if t626.conditional ~= nil then
			v4885.kind = {
				type = "conditional",
				value = t1.ActionProp_ConditionalOptions.jsonDecode(t626.conditional)
			}
		end

		return v4885
	end

	t623.descriptor = {
		name = "ActionProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.ActionProp"
	}
	t1.ActionProp = t623
	typeRegistry.default:register(t1.ActionProp)

	local t627 = {}

	t627.__index = t627

	function t627.new(t628: {[any]: any}?) -- line: 30673
		-- upvalues: t627 (copy)
		return (setmetatable({
			condition = if t628 ~= nil and t628.condition ~= nil then t628.condition else nil,
			kind = if t628 ~= nil and t628.kind ~= nil then t628.kind else nil
		}, t627))
	end
	function t627.encode(p472) -- line: 30682
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n312 = 0

		if p472.condition ~= nil then
			local v4890 = p472.condition:encode()
			local v4891, v4892 = proto.writeTag(buf, n312, 1, proto.wireTypes.lengthDelimited)

			buf, n312 = proto.writeBuffer(v4891, v4892, v4890, buffer.len(v4890))
		end

		if p472.kind ~= nil and p472.kind.type == "value" then
			local v4893 = p472.kind.value:encode()
			local v4894, v4895 = proto.writeTag(buf, n312, 3, proto.wireTypes.lengthDelimited)

			buf, n312 = proto.writeBuffer(v4894, v4895, v4893, buffer.len(v4893))
		end

		local buf159 = buffer.create(n312)

		buffer.copy(buf159, 0, buf, 0, n312)

		return buf159
	end
	function t627.decode(p473: buffer) -- line: 30705
		-- upvalues: t627 (copy), proto (copy), prop_condition (copy), t1 (copy)
		local v4898 = t627.new()
		local n313 = 0

		while n313 < buffer.len(p473) do
			local v4900, v4901

			v4900, v4901, n313 = proto.readTag(p473, n313)

			if v4901 == proto.wireTypes.varint then
				local v4902

				v4902, n313 = proto.readVarInt(p473, n313)
			elseif v4901 == proto.wireTypes.lengthDelimited then
				if v4900 == 1 then
					local v4903

					v4903, n313 = proto.readBuffer(p473, n313)
					v4898.condition = prop_condition.PropCondition.decode(v4903)
				elseif v4900 == 3 then
					local v4904

					v4904, n313 = proto.readBuffer(p473, n313)
					v4898.kind = {
						type = "value",
						value = t1.Action.decode(v4904)
					}
				else
					local v4905, v4906 = proto.readVarInt(p473, n313)

					n313 = v4906 + v4905
				end
			elseif v4901 == proto.wireTypes.i32 then
				local v4907

				v4907, n313 = proto.readFixed32(p473, n313)
			elseif v4901 == proto.wireTypes.i64 then
				local v4908

				v4908, n313 = proto.readFixed64(p473, n313)
			else
				error("Unsupported wire type: " .. v4901)
			end
		end

		return v4898
	end
	function t627.jsonEncode(p474) -- line: 30753
		local t629 = {}

		if p474.condition ~= nil then
			t629.condition = p474.condition:jsonEncode()
		end

		if p474.kind ~= nil and p474.kind.type == "value" then
			t629.value = p474.kind.value:jsonEncode()
		end

		return t629
	end
	function t627.jsonDecode(t630: {[any]: any}) -- line: 30769
		-- upvalues: t627 (copy), prop_condition (copy), t1 (copy)
		local v4912 = t627.new()

		if t630.condition ~= nil then
			v4912.condition = prop_condition.PropCondition.jsonDecode(t630.condition)
		end

		if t630.value ~= nil then
			v4912.kind = {
				type = "value",
				value = t1.Action.jsonDecode(t630.value)
			}
		end

		return v4912
	end

	t627.descriptor = {
		name = "ActionProp_ConditionalOption",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
	}
	t1.ActionProp_ConditionalOption = t627
	typeRegistry.default:register(t1.ActionProp_ConditionalOption)

	local t631 = {}

	t631.__index = t631

	function t631.new(t632: {[any]: any}?) -- line: 30798
		-- upvalues: t631 (copy)
		return (setmetatable({
			options = if t632 ~= nil and t632.options ~= nil then t632.options else {}
		}, t631))
	end
	function t631.encode(p475) -- line: 30806
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n314 = 0

		if p475.options ~= nil and #p475.options > 0 then
			for _, v4918 in p475.options do
				local v4919 = v4918:encode()
				local v4920, v4921 = proto.writeTag(buf, n314, 1, proto.wireTypes.lengthDelimited)

				buf, n314 = proto.writeBuffer(v4920, v4921, v4919, buffer.len(v4919))
			end
		end

		local buf160 = buffer.create(n314)

		buffer.copy(buf160, 0, buf, 0, n314)

		return buf160
	end
	function t631.decode(p476: buffer) -- line: 30823
		-- upvalues: t631 (copy), proto (copy), t1 (copy)
		local v4924 = t631.new()
		local n315 = 0

		while n315 < buffer.len(p476) do
			local v4926, v4927

			v4926, v4927, n315 = proto.readTag(p476, n315)

			if v4927 == proto.wireTypes.varint then
				local v4928

				v4928, n315 = proto.readVarInt(p476, n315)
			elseif v4927 == proto.wireTypes.lengthDelimited then
				if v4926 == 1 then
					local v4929

					v4929, n315 = proto.readBuffer(p476, n315)
					table.insert(v4924.options, t1.ActionProp_ConditionalOption.decode(v4929))
				else
					local v4930, v4931 = proto.readVarInt(p476, n315)

					n315 = v4931 + v4930
				end
			elseif v4927 == proto.wireTypes.i32 then
				local v4932

				v4932, n315 = proto.readFixed32(p476, n315)
			elseif v4927 == proto.wireTypes.i64 then
				local v4933

				v4933, n315 = proto.readFixed64(p476, n315)
			else
				error("Unsupported wire type: " .. v4927)
			end
		end

		return v4924
	end
	function t631.jsonEncode(p477) -- line: 30866
		local t633 = {}

		if p477.options ~= nil and #p477.options > 0 then
			local t634 = {}

			for _, v4938 in p477.options do
				table.insert(t634, v4938:jsonEncode())
			end

			t633.options = t634
		end

		return t633
	end
	function t631.jsonDecode(t635: {[any]: any}) -- line: 30880
		-- upvalues: t631 (copy), t1 (copy)
		local v4940 = t631.new()

		if t635.options ~= nil then
			local t636 = {}

			for _, v4943 in t635.options do
				table.insert(t636, t1.ActionProp_ConditionalOption.jsonDecode(v4943))
			end

			v4940.options = t636
		end

		return v4940
	end

	t631.descriptor = {
		name = "ActionProp_ConditionalOptions",
		fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
	}
	t1.ActionProp_ConditionalOptions = t631
	typeRegistry.default:register(t1.ActionProp_ConditionalOptions)

	local t637 = {}

	t637.__index = t637

	function t637.new(t638: {[any]: any}?) -- line: 30909
		-- upvalues: t637 (copy)
		return (setmetatable({
			kind = if t638 ~= nil and t638.kind ~= nil then t638.kind else nil
		}, t637))
	end
	function t637.encode(p478) -- line: 30915
		-- upvalues: proto (copy)
		local buf = buffer.create(0)
		local n316 = 0

		if p478.kind ~= nil then
			if p478.kind.type == "literal" then
				local v4948 = p478.kind.value:encode()
				local v4949, v4950 = proto.writeTag(buf, n316, 1, proto.wireTypes.lengthDelimited)

				buf, n316 = proto.writeBuffer(v4949, v4950, v4948, buffer.len(v4948))
			elseif p478.kind.type == "conditional" then
				local v4951 = p478.kind.value:encode()
				local v4952, v4953 = proto.writeTag(buf, n316, 2, proto.wireTypes.lengthDelimited)

				buf, n316 = proto.writeBuffer(v4952, v4953, v4951, buffer.len(v4951))
			elseif p478.kind.type == "binding_path" then
				local v4954, v4955 = proto.writeTag(buf, n316, 3, proto.wireTypes.lengthDelimited)

				buf, n316 = proto.writeString(v4954, v4955, p478.kind.value)
			end
		end

		local buf161 = buffer.create(n316)

		buffer.copy(buf161, 0, buf, 0, n316)

		return buf161
	end
	function t637.decode(p479: buffer) -- line: 30939
		-- upvalues: t637 (copy), proto (copy), t1 (copy)
		local v4958 = t637.new()
		local n317 = 0

		while n317 < buffer.len(p479) do
			local v4960, v4961

			v4960, v4961, n317 = proto.readTag(p479, n317)

			if v4961 == proto.wireTypes.varint then
				local v4962

				v4962, n317 = proto.readVarInt(p479, n317)
			elseif v4961 == proto.wireTypes.lengthDelimited then
				if v4960 == 1 then
					local v4963

					v4963, n317 = proto.readBuffer(p479, n317)
					v4958.kind = {
						type = "literal",
						value = t1.FocusNavActionsProp_FocusNavData.decode(v4963)
					}
				elseif v4960 == 2 then
					local v4964

					v4964, n317 = proto.readBuffer(p479, n317)
					v4958.kind = {
						type = "conditional",
						value = t1.FocusNavActionsProp_ConditionalOptions.decode(v4964)
					}
				elseif v4960 == 3 then
					local v4965

					v4965, n317 = proto.readBuffer(p479, n317)
					v4958.kind = {
						type = "binding_path",
						value = buffer.tostring(v4965)
					}
				else
					local v4966, v4967 = proto.readVarInt(p479, n317)

					n317 = v4967 + v4966
				end
			elseif v4961 == proto.wireTypes.i32 then
				local v4968

				v4968, n317 = proto.readFixed32(p479, n317)
			elseif v4961 == proto.wireTypes.i64 then
				local v4969

				v4969, n317 = proto.readFixed64(p479, n317)
			else
				error("Unsupported wire type: " .. v4961)
			end
		end

		return v4958
	end
	function t637.jsonEncode(p480) -- line: 30993
		local t639 = {}

		if p480.kind ~= nil then
			if p480.kind.type == "literal" then
				t639.literal = p480.kind.value:jsonEncode()

				return t639
			end

			if p480.kind.type == "conditional" then
				t639.conditional = p480.kind.value:jsonEncode()

				return t639
			end

			if p480.kind.type == "binding_path" then
				t639.bindingPath = p480.kind.value
			end
		end

		return t639
	end
	function t637.jsonDecode(t640: {[any]: any}) -- line: 31009
		-- upvalues: t637 (copy), t1 (copy)
		local v4973 = t637.new()

		if t640.literal ~= nil then
			v4973.kind = {
				type = "literal",
				value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t640.literal)
			}
		end

		if t640.conditional ~= nil then
			v4973.kind = {
				type = "conditional",
				value = t1.FocusNavActionsProp_ConditionalOptions.jsonDecode(t640.conditional)
			}
		end

		if t640.binding_path ~= nil then
			v4973.kind = {
				type = "binding_path",
				value = t640.binding_path
			}
		end

		if t640.bindingPath ~= nil then
			v4973.kind = {
				type = "binding_path",
				value = t640.bindingPath
			}
		end

		return v4973
	end

	t637.descriptor = {
		name = "FocusNavActionsProp",
		fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavActionsProp"
	}
	t1.FocusNavActionsProp = t637
end

typeRegistry.default:register(t1.FocusNavActionsProp)

local t641 = {}

t641.__index = t641

function t641.new(t642: {[any]: any}?) -- line: 31049
	-- upvalues: t641 (copy)
	return (setmetatable({
		condition = if t642 ~= nil and t642.condition ~= nil then t642.condition else nil,
		kind = if t642 ~= nil and t642.kind ~= nil then t642.kind else nil
	}, t641))
end
function t641.encode(p481) -- line: 31058
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n318 = 0

	if p481.condition ~= nil then
		local v4978 = p481.condition:encode()
		local v4979, v4980 = proto.writeTag(buf, n318, 1, proto.wireTypes.lengthDelimited)

		buf, n318 = proto.writeBuffer(v4979, v4980, v4978, buffer.len(v4978))
	end

	if p481.kind ~= nil then
		if p481.kind.type == "literal" then
			local v4981 = p481.kind.value:encode()
			local v4982, v4983 = proto.writeTag(buf, n318, 3, proto.wireTypes.lengthDelimited)

			buf, n318 = proto.writeBuffer(v4982, v4983, v4981, buffer.len(v4981))
		elseif p481.kind.type == "binding_path" then
			local v4984, v4985 = proto.writeTag(buf, n318, 4, proto.wireTypes.lengthDelimited)

			buf, n318 = proto.writeString(v4984, v4985, p481.kind.value)
		end
	end

	local buf162 = buffer.create(n318)

	buffer.copy(buf162, 0, buf, 0, n318)

	return buf162
end
function t641.decode(p482: buffer) -- line: 31084
	-- upvalues: t641 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v4988 = t641.new()
	local n319 = 0

	while n319 < buffer.len(p482) do
		local v4990, v4991

		v4990, v4991, n319 = proto.readTag(p482, n319)

		if v4991 == proto.wireTypes.varint then
			local v4992

			v4992, n319 = proto.readVarInt(p482, n319)
		elseif v4991 == proto.wireTypes.lengthDelimited then
			if v4990 == 1 then
				local v4993

				v4993, n319 = proto.readBuffer(p482, n319)
				v4988.condition = prop_condition.PropCondition.decode(v4993)
			elseif v4990 == 3 then
				local v4994

				v4994, n319 = proto.readBuffer(p482, n319)
				v4988.kind = {
					type = "literal",
					value = t1.FocusNavActionsProp_FocusNavData.decode(v4994)
				}
			elseif v4990 == 4 then
				local v4995

				v4995, n319 = proto.readBuffer(p482, n319)
				v4988.kind = {
					type = "binding_path",
					value = buffer.tostring(v4995)
				}
			else
				local v4996, v4997 = proto.readVarInt(p482, n319)

				n319 = v4997 + v4996
			end
		elseif v4991 == proto.wireTypes.i32 then
			local v4998

			v4998, n319 = proto.readFixed32(p482, n319)
		elseif v4991 == proto.wireTypes.i64 then
			local v4999

			v4999, n319 = proto.readFixed64(p482, n319)
		else
			error("Unsupported wire type: " .. v4991)
		end
	end

	return v4988
end
function t641.jsonEncode(p483) -- line: 31137
	local t643 = {}

	if p483.condition ~= nil then
		t643.condition = p483.condition:jsonEncode()
	end

	if p483.kind ~= nil then
		if p483.kind.type == "literal" then
			t643.literal = p483.kind.value:jsonEncode()

			return t643
		end

		if p483.kind.type == "binding_path" then
			t643.bindingPath = p483.kind.value
		end
	end

	return t643
end
function t641.jsonDecode(t644: {[any]: any}) -- line: 31155
	-- upvalues: t641 (copy), prop_condition (copy), t1 (copy)
	local v5003 = t641.new()

	if t644.condition ~= nil then
		v5003.condition = prop_condition.PropCondition.jsonDecode(t644.condition)
	end

	if t644.literal ~= nil then
		v5003.kind = {
			type = "literal",
			value = t1.FocusNavActionsProp_FocusNavData.jsonDecode(t644.literal)
		}
	end

	if t644.binding_path ~= nil then
		v5003.kind = {
			type = "binding_path",
			value = t644.binding_path
		}
	end

	if t644.bindingPath ~= nil then
		v5003.kind = {
			type = "binding_path",
			value = t644.bindingPath
		}
	end

	return v5003
end

t641.descriptor = {
	name = "FocusNavActionsProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FocusNavActionsProp_ConditionalOption = t641
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOption)

local t645 = {}

t645.__index = t645

function t645.new(t646: {[any]: any}?) -- line: 31195
	-- upvalues: t645 (copy)
	return (setmetatable({
		options = if t646 ~= nil and t646.options ~= nil then t646.options else {}
	}, t645))
end
function t645.encode(p484) -- line: 31203
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n320 = 0

	if p484.options ~= nil and #p484.options > 0 then
		for _, v5009 in p484.options do
			local v5010 = v5009:encode()
			local v5011, v5012 = proto.writeTag(buf, n320, 1, proto.wireTypes.lengthDelimited)

			buf, n320 = proto.writeBuffer(v5011, v5012, v5010, buffer.len(v5010))
		end
	end

	local buf163 = buffer.create(n320)

	buffer.copy(buf163, 0, buf, 0, n320)

	return buf163
end
function t645.decode(p485: buffer) -- line: 31220
	-- upvalues: t645 (copy), proto (copy), t1 (copy)
	local v5015 = t645.new()
	local n321 = 0

	while n321 < buffer.len(p485) do
		local v5017, v5018

		v5017, v5018, n321 = proto.readTag(p485, n321)

		if v5018 == proto.wireTypes.varint then
			local v5019

			v5019, n321 = proto.readVarInt(p485, n321)
		elseif v5018 == proto.wireTypes.lengthDelimited then
			if v5017 == 1 then
				local v5020

				v5020, n321 = proto.readBuffer(p485, n321)
				table.insert(v5015.options, t1.FocusNavActionsProp_ConditionalOption.decode(v5020))
			else
				local v5021, v5022 = proto.readVarInt(p485, n321)

				n321 = v5022 + v5021
			end
		elseif v5018 == proto.wireTypes.i32 then
			local v5023

			v5023, n321 = proto.readFixed32(p485, n321)
		elseif v5018 == proto.wireTypes.i64 then
			local v5024

			v5024, n321 = proto.readFixed64(p485, n321)
		else
			error("Unsupported wire type: " .. v5018)
		end
	end

	return v5015
end
function t645.jsonEncode(p486) -- line: 31263
	local t647 = {}

	if p486.options ~= nil and #p486.options > 0 then
		local t648 = {}

		for _, v5029 in p486.options do
			table.insert(t648, v5029:jsonEncode())
		end

		t647.options = t648
	end

	return t647
end
function t645.jsonDecode(t649: {[any]: any}) -- line: 31277
	-- upvalues: t645 (copy), t1 (copy)
	local v5031 = t645.new()

	if t649.options ~= nil then
		local t650 = {}

		for _, v5034 in t649.options do
			table.insert(t650, t1.FocusNavActionsProp_ConditionalOption.jsonDecode(v5034))
		end

		v5031.options = t650
	end

	return v5031
end

t645.descriptor = {
	name = "FocusNavActionsProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FocusNavActionsProp_ConditionalOptions = t645
typeRegistry.default:register(t1.FocusNavActionsProp_ConditionalOptions)

local t651 = {}

t651.__index = t651

function t651.new(t652: {[any]: any}?) -- line: 31308
	-- upvalues: t651 (copy)
	return (setmetatable({
		keys = if t652 ~= nil and t652.keys ~= nil then t652.keys else {},
		events = if t652 ~= nil and t652.events ~= nil then t652.events else {}
	}, t651))
end
function t651.encode(p487) -- line: 31317
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n322 = 0

	if p487.keys ~= nil and next(p487.keys) ~= nil then
		for v5039, v5040 in p487.keys do
			local buf164 = buffer.create(0)
			local v5042, v5043 = proto.writeTag(buf164, 0, 1, proto.wireTypes.lengthDelimited)
			local v5044, v5045 = proto.writeString(v5042, v5043, v5039)
			local v5046 = v5040:encode()
			local v5047, v5048 = proto.writeTag(v5044, v5045, 2, proto.wireTypes.lengthDelimited)
			local v5049, v5050 = proto.writeBuffer(v5047, v5048, v5046, buffer.len(v5046))
			local v5051, v5052 = proto.writeTag(buf, n322, 3, proto.wireTypes.lengthDelimited)

			buf, n322 = proto.writeBuffer(v5051, v5052, v5049, v5050)
		end
	end

	if p487.events ~= nil and next(p487.events) ~= nil then
		for v5053, v5054 in p487.events do
			local buf165 = buffer.create(0)
			local v5056, v5057 = proto.writeTag(buf165, 0, 1, proto.wireTypes.lengthDelimited)
			local v5058, v5059 = proto.writeString(v5056, v5057, v5053)
			local v5060 = v5054:encode()
			local v5061, v5062 = proto.writeTag(v5058, v5059, 2, proto.wireTypes.lengthDelimited)
			local v5063, v5064 = proto.writeBuffer(v5061, v5062, v5060, buffer.len(v5060))
			local v5065, v5066 = proto.writeTag(buf, n322, 4, proto.wireTypes.lengthDelimited)

			buf, n322 = proto.writeBuffer(v5065, v5066, v5063, v5064)
		end
	end

	local buf166 = buffer.create(n322)

	buffer.copy(buf166, 0, buf, 0, n322)

	return buf166
end
function t651.decode(p488: buffer) -- line: 31354
	-- upvalues: t651 (copy), proto (copy), t1 (copy), prop_types_engine (copy)
	local v5069 = t651.new()
	local n323 = 0

	while n323 < buffer.len(p488) do
		local v5071, v5072

		v5071, v5072, n323 = proto.readTag(p488, n323)

		if v5072 == proto.wireTypes.varint then
			local v5073

			v5073, n323 = proto.readVarInt(p488, n323)
		elseif v5072 == proto.wireTypes.lengthDelimited then
			if v5071 == 3 then
				local v5074

				v5074, n323 = proto.readBuffer(p488, n323)

				local v5075 = t1.FocusNavActionsProp_FocusNavData_KeysEntry.decode(v5074)
				local v5076 = prop_types_engine.KeyCodeProp.new()

				v5069.keys[v5075.key or ""] = v5075.value or v5076
			elseif v5071 == 4 then
				local v5077

				v5077, n323 = proto.readBuffer(p488, n323)

				local v5078 = t1.FocusNavActionsProp_FocusNavData_EventsEntry.decode(v5077)
				local v5079 = t1.ActionProp.new()

				v5069.events[v5078.key or ""] = v5078.value or v5079
			else
				local v5080, v5081 = proto.readVarInt(p488, n323)

				n323 = v5081 + v5080
			end
		elseif v5072 == proto.wireTypes.i32 then
			local v5082

			v5082, n323 = proto.readFixed32(p488, n323)
		elseif v5072 == proto.wireTypes.i64 then
			local v5083

			v5083, n323 = proto.readFixed64(p488, n323)
		else
			error("Unsupported wire type: " .. v5072)
		end
	end

	return v5069
end
function t651.jsonEncode(p489) -- line: 31416
	local t653 = {}

	if p489.keys ~= nil and next(p489.keys) ~= nil then
		local t654 = {}

		for v5087, v5088 in p489.keys do
			t654[v5087] = v5088:jsonEncode()
		end

		t653.keys = t654
	end

	if p489.events ~= nil and next(p489.events) ~= nil then
		local t655 = {}

		for v5090, v5091 in p489.events do
			t655[v5090] = v5091:jsonEncode()
		end

		t653.events = t655
	end

	return t653
end
function t651.jsonDecode(t656: {[any]: any}) -- line: 31438
	-- upvalues: t651 (copy), prop_types_engine (copy), t1 (copy)
	local v5093 = t651.new()

	if t656.keys ~= nil then
		local t657 = {}

		for v5095, v5096 in t656.keys do
			t657[v5095] = prop_types_engine.KeyCodeProp.jsonDecode(v5096)
		end

		v5093.keys = t657
	end

	if t656.events ~= nil then
		local t658 = {}

		for v5098, v5099 in t656.events do
			t658[v5098] = t1.ActionProp.jsonDecode(v5099)
		end

		v5093.events = t658
	end

	return v5093
end

t651.descriptor = {
	name = "FocusNavActionsProp_FocusNavData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FocusNavData"
}
t1.FocusNavActionsProp_FocusNavData = t651
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData)

local t659 = {}

t659.__index = t659

function t659.new(t660: {[any]: any}?) -- line: 31478
	-- upvalues: t659 (copy)
	return (setmetatable({
		key = if t660 ~= nil and t660.key ~= nil then t660.key else "",
		value = if t660 ~= nil and t660.value ~= nil then t660.value else nil
	}, t659))
end
function t659.encode(p490) -- line: 31487
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n324 = 0

	if p490.key ~= nil and p490.key ~= "" then
		local v5104, v5105 = proto.writeTag(buf, n324, 1, proto.wireTypes.lengthDelimited)

		buf, n324 = proto.writeString(v5104, v5105, p490.key)
	end

	if p490.value ~= nil then
		local v5106 = p490.value:encode()
		local v5107, v5108 = proto.writeTag(buf, n324, 2, proto.wireTypes.lengthDelimited)

		buf, n324 = proto.writeBuffer(v5107, v5108, v5106, buffer.len(v5106))
	end

	local buf167 = buffer.create(n324)

	buffer.copy(buf167, 0, buf, 0, n324)

	return buf167
end
function t659.decode(p491: buffer) -- line: 31509
	-- upvalues: t659 (copy), proto (copy), prop_types_engine (copy)
	local v5111 = t659.new()
	local n325 = 0

	while n325 < buffer.len(p491) do
		local v5113, v5114

		v5113, v5114, n325 = proto.readTag(p491, n325)

		if v5114 == proto.wireTypes.varint then
			local v5115

			v5115, n325 = proto.readVarInt(p491, n325)
		elseif v5114 == proto.wireTypes.lengthDelimited then
			if v5113 == 1 then
				local v5116

				v5116, n325 = proto.readBuffer(p491, n325)
				v5111.key = buffer.tostring(v5116)
			elseif v5113 == 2 then
				local v5117

				v5117, n325 = proto.readBuffer(p491, n325)
				v5111.value = prop_types_engine.KeyCodeProp.decode(v5117)
			else
				local v5118, v5119 = proto.readVarInt(p491, n325)

				n325 = v5119 + v5118
			end
		elseif v5114 == proto.wireTypes.i32 then
			local v5120

			v5120, n325 = proto.readFixed32(p491, n325)
		elseif v5114 == proto.wireTypes.i64 then
			local v5121

			v5121, n325 = proto.readFixed64(p491, n325)
		else
			error("Unsupported wire type: " .. v5114)
		end
	end

	return v5111
end
function t659.jsonEncode(p492) -- line: 31559
	local t661 = {}

	if p492.key ~= nil and p492.key ~= "" then
		t661.key = p492.key
	end

	if p492.value ~= nil then
		t661.value = p492.value:jsonEncode()
	end

	return t661
end
function t659.jsonDecode(t662: {[any]: any}) -- line: 31575
	-- upvalues: t659 (copy), prop_types_engine (copy)
	local v5125 = t659.new()

	if t662.key ~= nil then
		v5125.key = t662.key
	end

	if t662.value ~= nil then
		v5125.value = prop_types_engine.KeyCodeProp.jsonDecode(t662.value)
	end

	return v5125
end

t659.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_KeysEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeysEntry"
}
t1.FocusNavActionsProp_FocusNavData_KeysEntry = t659
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_KeysEntry)

local t663 = {}

t663.__index = t663

function t663.new(t664: {[any]: any}?) -- line: 31605
	-- upvalues: t663 (copy)
	return (setmetatable({
		key = if t664 ~= nil and t664.key ~= nil then t664.key else "",
		value = if t664 ~= nil and t664.value ~= nil then t664.value else nil
	}, t663))
end
function t663.encode(p493) -- line: 31614
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n326 = 0

	if p493.key ~= nil and p493.key ~= "" then
		local v5130, v5131 = proto.writeTag(buf, n326, 1, proto.wireTypes.lengthDelimited)

		buf, n326 = proto.writeString(v5130, v5131, p493.key)
	end

	if p493.value ~= nil then
		local v5132 = p493.value:encode()
		local v5133, v5134 = proto.writeTag(buf, n326, 2, proto.wireTypes.lengthDelimited)

		buf, n326 = proto.writeBuffer(v5133, v5134, v5132, buffer.len(v5132))
	end

	local buf168 = buffer.create(n326)

	buffer.copy(buf168, 0, buf, 0, n326)

	return buf168
end
function t663.decode(p494: buffer) -- line: 31636
	-- upvalues: t663 (copy), proto (copy), t1 (copy)
	local v5137 = t663.new()
	local n327 = 0

	while n327 < buffer.len(p494) do
		local v5139, v5140

		v5139, v5140, n327 = proto.readTag(p494, n327)

		if v5140 == proto.wireTypes.varint then
			local v5141

			v5141, n327 = proto.readVarInt(p494, n327)
		elseif v5140 == proto.wireTypes.lengthDelimited then
			if v5139 == 1 then
				local v5142

				v5142, n327 = proto.readBuffer(p494, n327)
				v5137.key = buffer.tostring(v5142)
			elseif v5139 == 2 then
				local v5143

				v5143, n327 = proto.readBuffer(p494, n327)
				v5137.value = t1.ActionProp.decode(v5143)
			else
				local v5144, v5145 = proto.readVarInt(p494, n327)

				n327 = v5145 + v5144
			end
		elseif v5140 == proto.wireTypes.i32 then
			local v5146

			v5146, n327 = proto.readFixed32(p494, n327)
		elseif v5140 == proto.wireTypes.i64 then
			local v5147

			v5147, n327 = proto.readFixed64(p494, n327)
		else
			error("Unsupported wire type: " .. v5140)
		end
	end

	return v5137
end
function t663.jsonEncode(p495) -- line: 31686
	local t665 = {}

	if p495.key ~= nil and p495.key ~= "" then
		t665.key = p495.key
	end

	if p495.value ~= nil then
		t665.value = p495.value:jsonEncode()
	end

	return t665
end
function t663.jsonDecode(t666: {[any]: any}) -- line: 31702
	-- upvalues: t663 (copy), t1 (copy)
	local v5151 = t663.new()

	if t666.key ~= nil then
		v5151.key = t666.key
	end

	if t666.value ~= nil then
		v5151.value = t1.ActionProp.jsonDecode(t666.value)
	end

	return v5151
end

t663.descriptor = {
	name = "FocusNavActionsProp_FocusNavData_EventsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventsEntry"
}
t1.FocusNavActionsProp_FocusNavData_EventsEntry = t663
typeRegistry.default:register(t1.FocusNavActionsProp_FocusNavData_EventsEntry)
t1.ActionType = {
	fromNumber = function(n328: number) -- line: 31729
		if n328 == 0 then
			return "ACTION_TYPE_INVALID"
		end

		if n328 == 1 then
			return "ACTION_TYPE_DISMISS_DIALOG"
		end

		if n328 == 2 then
			return "ACTION_TYPE_LINK"
		end

		if n328 == 3 then
			return "ACTION_TYPE_OPEN_GAME_DETAILS"
		end

		if n328 == 4 then
			return "ACTION_TYPE_OPEN_JOIN_FRIENDS"
		end

		if n328 == 5 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON"
		end

		if n328 == 6 then
			return "ACTION_TYPE_OPEN_SEE_ALL"
		end

		if n328 == 7 then
			return "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP"
		end

		if n328 == 8 then
			return "ACTION_TYPE_PLAY_BUTTON_CLICK"
		end

		if n328 == 9 then
			return "ACTION_TYPE_UPDATE_USER_SETTINGS"
		end

		if n328 == 10 then
			return "ACTION_TYPE_OPEN_TOOLTIP"
		end

		if n328 == 11 then
			return "ACTION_TYPE_OPEN_BADGE_DETAILS"
		end

		if n328 == 12 then
			return "ACTION_TYPE_LOAD_MORE_FROM_API"
		end

		if n328 == 13 then
			return "ACTION_TYPE_SHARE"
		end

		if n328 == 14 then
			return "ACTION_TYPE_OPEN_ABUSE_REPORT"
		end

		if n328 == 15 then
			return "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY"
		end

		if n328 == 16 then
			return "ACTION_TYPE_OPEN_PROFILE"
		end

		if n328 == 17 then
			return "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION"
		end

		if n328 == 18 then
			return "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE"
		end

		if n328 == 19 then
			return "ACTION_TYPE_OPEN_MARKETPLACE"
		end

		if n328 == 20 then
			return "ACTION_TYPE_HIDE_PROFILE_COMPLETION"
		end

		if n328 == 21 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY"
		end

		if n328 == 22 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY"
		end

		if n328 == 23 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL"
		end

		if n328 == 24 then
			return "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP"
		end

		if n328 == 25 then
			return "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG"
		end

		if n328 == 26 then
			return "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS"
		end

		if n328 == 27 then
			return "ACTION_TYPE_OPEN_SOCIAL_LINK"
		end

		if n328 == 28 then
			return "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL"
		end

		if n328 == 29 then
			return "ACTION_TYPE_OPEN_SONG_DETAIL"
		end

		if n328 == 30 then
			return "ACTION_TYPE_REFRESH_FROM_API"
		end

		if n328 == 31 then
			return "ACTION_TYPE_RSVP_TO_EVENT"
		end

		if n328 == 32 then
			return "ACTION_TYPE_APPLY_CHARTS_FILTER"
		end

		if n328 == 33 then
			return "ACTION_TYPE_ANALYTICS_EVENT"
		end

		if n328 == 34 then
			return "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT"
		end

		if n328 == 35 then
			return "ACTION_TYPE_OPEN_GAME_INVITE"
		end

		if n328 == 36 then
			return "ACTION_TYPE_OPEN_EVENT_DETAILS"
		end

		if n328 == 37 then
			return "ACTION_TYPE_LAUNCH_EXPERIENCE"
		end

		if n328 == 38 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE"
		end

		if n328 == 39 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW"
		end

		if n328 == 40 then
			return "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE"
		end

		if n328 == 41 then
			return "ACTION_TYPE_OPEN_PURCHASE_PROMPT"
		end

		if n328 == 42 then
			return "ACTION_TYPE_OPEN_SDUI_OVERLAY"
		end

		if n328 == 43 then
			return "ACTION_TYPE_OPEN_BADGES_SEE_ALL"
		end

		if n328 == 44 then
			return "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL"
		end

		if n328 == 45 then
			return "ACTION_TYPE_DISMISS_GAME_FEEDBACK"
		end

		if n328 == 46 then
			return "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM"
		end

		if n328 == 47 then
			return "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS"
		end

		if n328 == 48 then
			return "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL"
		end

		if n328 == 49 then
			return "ACTION_TYPE_OPEN_AMP_WIZARD"
		end

		if n328 == 50 then
			return "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE"
		end

		if n328 == 51 then
			return "ACTION_TYPE_REFRESH_GAME_PASSES"
		end

		if n328 == 52 then
			return "ACTION_TYPE_REFRESH_PLAYABILITY"
		end

		if n328 == 53 then
			return "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET"
		end

		if n328 == 54 then
			return "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE"
		end

		if n328 == 55 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB"
		end

		if n328 == 56 then
			return "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL"
		end

		if n328 == 57 then
			return "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL"
		end

		if n328 == 58 then
			return "ACTION_TYPE_DISMISS_PROMPT"
		end

		if n328 == 59 then
			return "ACTION_TYPE_REQUEST_FRIENDSHIP"
		end

		if n328 == 60 then
			return "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS"
		end

		if n328 == 61 then
			return "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL"
		end

		if n328 == 62 then
			return "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM"
		end

		if n328 == 63 then
			return "ACTION_TYPE_AI_OVERVIEW_FEEDBACK"
		end

		if n328 == 64 then
			return "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL"
		end

		if n328 == 65 then
			return "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT"
		end

		if n328 == 66 then
			return "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY"
		end

		if n328 == 67 then
			return "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY"
		end

		if n328 == 68 then
			return "ACTION_TYPE_DOWNLOAD_APP"
		end

		if n328 == 69 then
			return "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL"
		end

		if n328 == 70 then
			return "ACTION_TYPE_JOIN_COMMUNITY"
		end

		if n328 == 71 then
			return "ACTION_TYPE_VIEW_COMMUNITY"
		end

		if n328 == 72 then
			return "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT"
		end

		return nil
	end,
	toNumber = function(p496) -- line: 31881
		if p496 == "ACTION_TYPE_INVALID" then
			return 0
		end

		if p496 == "ACTION_TYPE_DISMISS_DIALOG" then
			return 1
		end

		if p496 == "ACTION_TYPE_LINK" then
			return 2
		end

		if p496 == "ACTION_TYPE_OPEN_GAME_DETAILS" then
			return 3
		end

		if p496 == "ACTION_TYPE_OPEN_JOIN_FRIENDS" then
			return 4
		end

		if p496 == "ACTION_TYPE_OPEN_MARKETPLACE_TRY_ON" then
			return 5
		end

		if p496 == "ACTION_TYPE_OPEN_SEE_ALL" then
			return 6
		end

		if p496 == "ACTION_TYPE_OPEN_SPONSORED_TOOLTIP" then
			return 7
		end

		if p496 == "ACTION_TYPE_PLAY_BUTTON_CLICK" then
			return 8
		end

		if p496 == "ACTION_TYPE_UPDATE_USER_SETTINGS" then
			return 9
		end

		if p496 == "ACTION_TYPE_OPEN_TOOLTIP" then
			return 10
		end

		if p496 == "ACTION_TYPE_OPEN_BADGE_DETAILS" then
			return 11
		end

		if p496 == "ACTION_TYPE_LOAD_MORE_FROM_API" then
			return 12
		end

		if p496 == "ACTION_TYPE_SHARE" then
			return 13
		end

		if p496 == "ACTION_TYPE_OPEN_ABUSE_REPORT" then
			return 14
		end

		if p496 == "ACTION_TYPE_REMOVE_BADGE_FROM_INVENTORY" then
			return 15
		end

		if p496 == "ACTION_TYPE_OPEN_PROFILE" then
			return 16
		end

		if p496 == "ACTION_TYPE_OPEN_FACIAL_AGE_ESTIMATION" then
			return 17
		end

		if p496 == "ACTION_TYPE_OPEN_ADD_CONNECTIONS_PAGE" then
			return 18
		end

		if p496 == "ACTION_TYPE_OPEN_MARKETPLACE" then
			return 19
		end

		if p496 == "ACTION_TYPE_HIDE_PROFILE_COMPLETION" then
			return 20
		end

		if p496 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_CATEGORY" then
			return 21
		end

		if p496 == "ACTION_TYPE_SELECT_MARKETPLACE_CATALOG_SUBCATEGORY" then
			return 22
		end

		if p496 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_SEE_ALL" then
			return 23
		end

		if p496 == "ACTION_TYPE_CLOSE_MARKETPLACE_CATEGORY_TOOLTIP" then
			return 24
		end

		if p496 == "ACTION_TYPE_RESIZE_MARKETPLACE_CATALOG" then
			return 25
		end

		if p496 == "ACTION_TYPE_OPEN_MARKETPLACE_CATALOG_FILTERS" then
			return 26
		end

		if p496 == "ACTION_TYPE_OPEN_SOCIAL_LINK" then
			return 27
		end

		if p496 == "ACTION_TYPE_OPEN_CHARTS_SORT_DETAIL" then
			return 28
		end

		if p496 == "ACTION_TYPE_OPEN_SONG_DETAIL" then
			return 29
		end

		if p496 == "ACTION_TYPE_REFRESH_FROM_API" then
			return 30
		end

		if p496 == "ACTION_TYPE_RSVP_TO_EVENT" then
			return 31
		end

		if p496 == "ACTION_TYPE_APPLY_CHARTS_FILTER" then
			return 32
		end

		if p496 == "ACTION_TYPE_ANALYTICS_EVENT" then
			return 33
		end

		if p496 == "ACTION_TYPE_CUSTOM_ANALYTICS_EVENT" then
			return 34
		end

		if p496 == "ACTION_TYPE_OPEN_GAME_INVITE" then
			return 35
		end

		if p496 == "ACTION_TYPE_OPEN_EVENT_DETAILS" then
			return 36
		end

		if p496 == "ACTION_TYPE_LAUNCH_EXPERIENCE" then
			return 37
		end

		if p496 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FAVORITE" then
			return 38
		end

		if p496 == "ACTION_TYPE_TOGGLE_EXPERIENCE_FOLLOW" then
			return 39
		end

		if p496 == "ACTION_TYPE_TOGGLE_EXPERIENCE_VOTE" then
			return 40
		end

		if p496 == "ACTION_TYPE_OPEN_PURCHASE_PROMPT" then
			return 41
		end

		if p496 == "ACTION_TYPE_OPEN_SDUI_OVERLAY" then
			return 42
		end

		if p496 == "ACTION_TYPE_OPEN_BADGES_SEE_ALL" then
			return 43
		end

		if p496 == "ACTION_TYPE_OPEN_EXPERIENCE_STORE_SEE_ALL" then
			return 44
		end

		if p496 == "ACTION_TYPE_DISMISS_GAME_FEEDBACK" then
			return 45
		end

		if p496 == "ACTION_TYPE_OPEN_GAME_FEEDBACK_FORM" then
			return 46
		end

		if p496 == "ACTION_TYPE_ENABLE_EVENT_NOTIFICATIONS" then
			return 47
		end

		if p496 == "ACTION_TYPE_DISMISS_EVENT_NOTIFICATIONS_MODAL" then
			return 48
		end

		if p496 == "ACTION_TYPE_OPEN_AMP_WIZARD" then
			return 49
		end

		if p496 == "ACTION_TYPE_OPEN_SUBSCRIPTION_PURCHASE_PAGE" then
			return 50
		end

		if p496 == "ACTION_TYPE_REFRESH_GAME_PASSES" then
			return 51
		end

		if p496 == "ACTION_TYPE_REFRESH_PLAYABILITY" then
			return 52
		end

		if p496 == "ACTION_TYPE_OPEN_SOCIAL_PROOF_USER_LIST_SHEET" then
			return 53
		end

		if p496 == "ACTION_TYPE_REPORT_SURFACE_LOAD_TIME_MILESTONE" then
			return 54
		end

		if p496 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_TAB" then
			return 55
		end

		if p496 == "ACTION_TYPE_OPEN_PHONE_UPSELL_MODAL" then
			return 56
		end

		if p496 == "ACTION_TYPE_OPEN_EMAIL_UPSELL_MODAL" then
			return 57
		end

		if p496 == "ACTION_TYPE_DISMISS_PROMPT" then
			return 58
		end

		if p496 == "ACTION_TYPE_REQUEST_FRIENDSHIP" then
			return 59
		end

		if p496 == "ACTION_TYPE_REFRESH_DEVELOPER_PRODUCTS" then
			return 60
		end

		if p496 == "ACTION_TYPE_OPEN_FAE_TRIAL_UPSELL" then
			return 61
		end

		if p496 == "ACTION_TYPE_REFRESH_OMNI_RECOMMENDATION_FEED_ITEM" then
			return 62
		end

		if p496 == "ACTION_TYPE_AI_OVERVIEW_FEEDBACK" then
			return 63
		end

		if p496 == "ACTION_TYPE_OPEN_TRUSTED_FRIENDS_UPSELL_MODAL" then
			return 64
		end

		if p496 == "ACTION_TYPE_RECORD_PARTY_CHAT_CONVERSATION_UPSELL_ACKNOWLEDGEMENT" then
			return 65
		end

		if p496 == "ACTION_TYPE_OPEN_SEARCH_RESULTS_WITH_QUERY" then
			return 66
		end

		if p496 == "ACTION_TYPE_SELECT_MARKETPLACE_FAVORITES_CATEGORY" then
			return 67
		end

		if p496 == "ACTION_TYPE_DOWNLOAD_APP" then
			return 68
		end

		if p496 == "ACTION_TYPE_REFRESH_CHARTS_SORT_DETAIL" then
			return 69
		end

		if p496 == "ACTION_TYPE_JOIN_COMMUNITY" then
			return 70
		end

		if p496 == "ACTION_TYPE_VIEW_COMMUNITY" then
			return 71
		end

		if p496 == "ACTION_TYPE_PIN_EXPERIENCE_SHORTCUT" then
			return 72
		end

		return p496
	end,
	fromName = function(s1: string) -- line: 32033
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
