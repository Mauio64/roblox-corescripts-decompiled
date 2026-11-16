local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local prop_types = require(script.Parent.prop_types)
local prop_types_engine = require(script.Parent.prop_types_engine)

local class = {}
class.__index = class

function class.new(p)
	local prop_builder

	if not (p == nil or p.prop_builder == nil) then
		prop_builder = p.prop_builder
	end

	local oneof_prop

	if not (p == nil or p.oneof_prop == nil) then
		oneof_prop = p.oneof_prop
	end

	return (setmetatable({ prop_builder = prop_builder, oneof_prop = oneof_prop }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.prop_builder ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1000, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.prop_builder)
	end

	if self.oneof_prop ~= nil then
		if self.oneof_prop.type == "string_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "int32_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "int64_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "float_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "double_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "bool_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "struct_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "array_of_struct_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "string_array_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "image_string_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "image_set_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "icon_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "icon_size_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "foundation_icon_config_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "color_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "color_style_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "gradient_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "typography_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 18, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "typography_font_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 19, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "udim_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 20, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "udim2_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 21, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "vector2_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 22, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "ui_scaled_float_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 23, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "ui_scaled_udim_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 24, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "ui_scaled_udim2_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 25, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "fill_behavior_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 26, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "input_size_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 27, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "automatic_size_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 28, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "text_truncate_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 29, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "text_x_alignment_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 30, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "text_y_alignment_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 31, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "ui_flex_mode_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 32, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "scale_type_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 33, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "resampler_mode_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 34, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "size_constraint_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 35, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "selection_behavior_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 36, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "key_code_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 37, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local result = class.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "string_prop",
					value = prop_types.StringProp.decode(v5)
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "int32_prop",
					value = prop_types.Int32Prop.decode(v5)
				}
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "int64_prop",
					value = prop_types.Int64Prop.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "float_prop",
					value = prop_types.FloatProp.decode(v5)
				}
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "double_prop",
					value = prop_types.DoubleProp.decode(v5)
				}
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = { type = "bool_prop", value = prop_types.BoolProp.decode(v5) }
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "struct_prop",
					value = prop_types.StructProp.decode(v5)
				}
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "array_of_struct_prop",
					value = prop_types.ArrayOfStructProp.decode(v5)
				}
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "string_array_prop",
					value = prop_types.StringArrayProp.decode(v5)
				}
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "image_string_prop",
					value = prop_types.ImageStringProp.decode(v5)
				}
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "image_set_prop",
					value = prop_types.ImageSetProp.decode(v5)
				}
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = { type = "icon_prop", value = prop_types.IconProp.decode(v5) }
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "icon_size_prop",
					value = prop_types.IconSizeProp.decode(v5)
				}
			elseif v3 == 14 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "foundation_icon_config_prop",
					value = prop_types.FoundationIconConfigProp.decode(v5)
				}
			elseif v3 == 15 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "color_prop",
					value = prop_types.ColorProp.decode(v5)
				}
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "color_style_prop",
					value = prop_types.ColorStyleProp.decode(v5)
				}
			elseif v3 == 17 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "gradient_prop",
					value = prop_types.GradientProp.decode(v5)
				}
			elseif v3 == 18 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "typography_prop",
					value = prop_types.TypographyProp.decode(v5)
				}
			elseif v3 == 19 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "typography_font_prop",
					value = prop_types.TypographyFontProp.decode(v5)
				}
			elseif v3 == 20 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = { type = "udim_prop", value = prop_types.UDimProp.decode(v5) }
			elseif v3 == 21 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "udim2_prop",
					value = prop_types.UDim2Prop.decode(v5)
				}
			elseif v3 == 22 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "vector2_prop",
					value = prop_types.Vector2Prop.decode(v5)
				}
			elseif v3 == 23 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "ui_scaled_float_prop",
					value = prop_types.UiScaledFloatProp.decode(v5)
				}
			elseif v3 == 24 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "ui_scaled_udim_prop",
					value = prop_types.UiScaledUDimProp.decode(v5)
				}
			elseif v3 == 25 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "ui_scaled_udim2_prop",
					value = prop_types.UiScaledUDim2Prop.decode(v5)
				}
			elseif v3 == 26 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "fill_behavior_prop",
					value = prop_types.FillBehaviorProp.decode(v5)
				}
			elseif v3 == 27 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "input_size_prop",
					value = prop_types.InputSizeProp.decode(v5)
				}
			elseif v3 == 28 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "automatic_size_prop",
					value = prop_types_engine.AutomaticSizeProp.decode(v5)
				}
			elseif v3 == 29 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "text_truncate_prop",
					value = prop_types_engine.TextTruncateProp.decode(v5)
				}
			elseif v3 == 30 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "text_x_alignment_prop",
					value = prop_types_engine.TextXAlignmentProp.decode(v5)
				}
			elseif v3 == 31 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "text_y_alignment_prop",
					value = prop_types_engine.TextYAlignmentProp.decode(v5)
				}
			elseif v3 == 32 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "ui_flex_mode_prop",
					value = prop_types_engine.UIFlexModeProp.decode(v5)
				}
			elseif v3 == 33 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "scale_type_prop",
					value = prop_types_engine.ScaleTypeProp.decode(v5)
				}
			elseif v3 == 34 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "resampler_mode_prop",
					value = prop_types_engine.ResamplerModeProp.decode(v5)
				}
			elseif v3 == 35 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "size_constraint_prop",
					value = prop_types_engine.SizeConstraintProp.decode(v5)
				}
			elseif v3 == 36 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "selection_behavior_prop",
					value = prop_types_engine.SelectionBehaviorProp.decode(v5)
				}
			elseif v3 == 37 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "key_code_prop",
					value = prop_types_engine.KeyCodeProp.decode(v5)
				}
			elseif v3 == 1000 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.prop_builder = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class:jsonEncode()
	local v2 = {}

	if self.prop_builder ~= nil then
		v2.propBuilder = self.prop_builder
	end

	if self.oneof_prop == nil then
		return v2
	end

	if self.oneof_prop.type == "string_prop" then
		v2.stringProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "int32_prop" then
		v2.int32Prop = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "int64_prop" then
		v2.int64Prop = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "float_prop" then
		v2.floatProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "double_prop" then
		v2.doubleProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "bool_prop" then
		v2.boolProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "struct_prop" then
		v2.structProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "array_of_struct_prop" then
		v2.arrayOfStructProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "string_array_prop" then
		v2.stringArrayProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "image_string_prop" then
		v2.imageStringProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "image_set_prop" then
		v2.imageSetProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "icon_prop" then
		v2.iconProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "icon_size_prop" then
		v2.iconSizeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "foundation_icon_config_prop" then
		v2.foundationIconConfigProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "color_prop" then
		v2.colorProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "color_style_prop" then
		v2.colorStyleProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "gradient_prop" then
		v2.gradientProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "typography_prop" then
		v2.typographyProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "typography_font_prop" then
		v2.typographyFontProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "udim_prop" then
		v2.udimProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "udim2_prop" then
		v2.udim2Prop = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "vector2_prop" then
		v2.vector2Prop = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "ui_scaled_float_prop" then
		v2.uiScaledFloatProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "ui_scaled_udim_prop" then
		v2.uiScaledUdimProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "ui_scaled_udim2_prop" then
		v2.uiScaledUdim2Prop = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "fill_behavior_prop" then
		v2.fillBehaviorProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "input_size_prop" then
		v2.inputSizeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "automatic_size_prop" then
		v2.automaticSizeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "text_truncate_prop" then
		v2.textTruncateProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "text_x_alignment_prop" then
		v2.textXAlignmentProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "text_y_alignment_prop" then
		v2.textYAlignmentProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "ui_flex_mode_prop" then
		v2.uiFlexModeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "scale_type_prop" then
		v2.scaleTypeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "resampler_mode_prop" then
		v2.resamplerModeProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "size_constraint_prop" then
		v2.sizeConstraintProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "selection_behavior_prop" then
		v2.selectionBehaviorProp = self.oneof_prop.value:jsonEncode()
		return v2
	elseif self.oneof_prop.type == "key_code_prop" then
		v2.keyCodeProp = self.oneof_prop.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.prop_builder ~= nil then
		v2.prop_builder = data.prop_builder
	end

	if data.propBuilder ~= nil then
		v2.prop_builder = data.propBuilder
	end

	if data.string_prop ~= nil then
		v2.oneof_prop = {
			type = "string_prop",
			value = prop_types.StringProp.jsonDecode(data.string_prop)
		}
	end

	if data.stringProp ~= nil then
		v2.oneof_prop = {
			type = "string_prop",
			value = prop_types.StringProp.jsonDecode(data.stringProp)
		}
	end

	if data.int32_prop ~= nil then
		v2.oneof_prop = {
			type = "int32_prop",
			value = prop_types.Int32Prop.jsonDecode(data.int32_prop)
		}
	end

	if data.int32Prop ~= nil then
		v2.oneof_prop = {
			type = "int32_prop",
			value = prop_types.Int32Prop.jsonDecode(data.int32Prop)
		}
	end

	if data.int64_prop ~= nil then
		v2.oneof_prop = {
			type = "int64_prop",
			value = prop_types.Int64Prop.jsonDecode(data.int64_prop)
		}
	end

	if data.int64Prop ~= nil then
		v2.oneof_prop = {
			type = "int64_prop",
			value = prop_types.Int64Prop.jsonDecode(data.int64Prop)
		}
	end

	if data.float_prop ~= nil then
		v2.oneof_prop = {
			type = "float_prop",
			value = prop_types.FloatProp.jsonDecode(data.float_prop)
		}
	end

	if data.floatProp ~= nil then
		v2.oneof_prop = {
			type = "float_prop",
			value = prop_types.FloatProp.jsonDecode(data.floatProp)
		}
	end

	if data.double_prop ~= nil then
		v2.oneof_prop = {
			type = "double_prop",
			value = prop_types.DoubleProp.jsonDecode(data.double_prop)
		}
	end

	if data.doubleProp ~= nil then
		v2.oneof_prop = {
			type = "double_prop",
			value = prop_types.DoubleProp.jsonDecode(data.doubleProp)
		}
	end

	if data.bool_prop ~= nil then
		v2.oneof_prop = {
			type = "bool_prop",
			value = prop_types.BoolProp.jsonDecode(data.bool_prop)
		}
	end

	if data.boolProp ~= nil then
		v2.oneof_prop = {
			type = "bool_prop",
			value = prop_types.BoolProp.jsonDecode(data.boolProp)
		}
	end

	if data.struct_prop ~= nil then
		v2.oneof_prop = {
			type = "struct_prop",
			value = prop_types.StructProp.jsonDecode(data.struct_prop)
		}
	end

	if data.structProp ~= nil then
		v2.oneof_prop = {
			type = "struct_prop",
			value = prop_types.StructProp.jsonDecode(data.structProp)
		}
	end

	if data.array_of_struct_prop ~= nil then
		v2.oneof_prop = {
			type = "array_of_struct_prop",
			value = prop_types.ArrayOfStructProp.jsonDecode(data.array_of_struct_prop)
		}
	end

	if data.arrayOfStructProp ~= nil then
		v2.oneof_prop = {
			type = "array_of_struct_prop",
			value = prop_types.ArrayOfStructProp.jsonDecode(data.arrayOfStructProp)
		}
	end

	if data.string_array_prop ~= nil then
		v2.oneof_prop = {
			type = "string_array_prop",
			value = prop_types.StringArrayProp.jsonDecode(data.string_array_prop)
		}
	end

	if data.stringArrayProp ~= nil then
		v2.oneof_prop = {
			type = "string_array_prop",
			value = prop_types.StringArrayProp.jsonDecode(data.stringArrayProp)
		}
	end

	if data.image_string_prop ~= nil then
		v2.oneof_prop = {
			type = "image_string_prop",
			value = prop_types.ImageStringProp.jsonDecode(data.image_string_prop)
		}
	end

	if data.imageStringProp ~= nil then
		v2.oneof_prop = {
			type = "image_string_prop",
			value = prop_types.ImageStringProp.jsonDecode(data.imageStringProp)
		}
	end

	if data.image_set_prop ~= nil then
		v2.oneof_prop = {
			type = "image_set_prop",
			value = prop_types.ImageSetProp.jsonDecode(data.image_set_prop)
		}
	end

	if data.imageSetProp ~= nil then
		v2.oneof_prop = {
			type = "image_set_prop",
			value = prop_types.ImageSetProp.jsonDecode(data.imageSetProp)
		}
	end

	if data.icon_prop ~= nil then
		v2.oneof_prop = {
			type = "icon_prop",
			value = prop_types.IconProp.jsonDecode(data.icon_prop)
		}
	end

	if data.iconProp ~= nil then
		v2.oneof_prop = {
			type = "icon_prop",
			value = prop_types.IconProp.jsonDecode(data.iconProp)
		}
	end

	if data.icon_size_prop ~= nil then
		v2.oneof_prop = {
			type = "icon_size_prop",
			value = prop_types.IconSizeProp.jsonDecode(data.icon_size_prop)
		}
	end

	if data.iconSizeProp ~= nil then
		v2.oneof_prop = {
			type = "icon_size_prop",
			value = prop_types.IconSizeProp.jsonDecode(data.iconSizeProp)
		}
	end

	if data.foundation_icon_config_prop ~= nil then
		v2.oneof_prop = {
			type = "foundation_icon_config_prop",
			value = prop_types.FoundationIconConfigProp.jsonDecode(data.foundation_icon_config_prop)
		}
	end

	if data.foundationIconConfigProp ~= nil then
		v2.oneof_prop = {
			type = "foundation_icon_config_prop",
			value = prop_types.FoundationIconConfigProp.jsonDecode(data.foundationIconConfigProp)
		}
	end

	if data.color_prop ~= nil then
		v2.oneof_prop = {
			type = "color_prop",
			value = prop_types.ColorProp.jsonDecode(data.color_prop)
		}
	end

	if data.colorProp ~= nil then
		v2.oneof_prop = {
			type = "color_prop",
			value = prop_types.ColorProp.jsonDecode(data.colorProp)
		}
	end

	if data.color_style_prop ~= nil then
		v2.oneof_prop = {
			type = "color_style_prop",
			value = prop_types.ColorStyleProp.jsonDecode(data.color_style_prop)
		}
	end

	if data.colorStyleProp ~= nil then
		v2.oneof_prop = {
			type = "color_style_prop",
			value = prop_types.ColorStyleProp.jsonDecode(data.colorStyleProp)
		}
	end

	if data.gradient_prop ~= nil then
		v2.oneof_prop = {
			type = "gradient_prop",
			value = prop_types.GradientProp.jsonDecode(data.gradient_prop)
		}
	end

	if data.gradientProp ~= nil then
		v2.oneof_prop = {
			type = "gradient_prop",
			value = prop_types.GradientProp.jsonDecode(data.gradientProp)
		}
	end

	if data.typography_prop ~= nil then
		v2.oneof_prop = {
			type = "typography_prop",
			value = prop_types.TypographyProp.jsonDecode(data.typography_prop)
		}
	end

	if data.typographyProp ~= nil then
		v2.oneof_prop = {
			type = "typography_prop",
			value = prop_types.TypographyProp.jsonDecode(data.typographyProp)
		}
	end

	if data.typography_font_prop ~= nil then
		v2.oneof_prop = {
			type = "typography_font_prop",
			value = prop_types.TypographyFontProp.jsonDecode(data.typography_font_prop)
		}
	end

	if data.typographyFontProp ~= nil then
		v2.oneof_prop = {
			type = "typography_font_prop",
			value = prop_types.TypographyFontProp.jsonDecode(data.typographyFontProp)
		}
	end

	if data.udim_prop ~= nil then
		v2.oneof_prop = {
			type = "udim_prop",
			value = prop_types.UDimProp.jsonDecode(data.udim_prop)
		}
	end

	if data.udimProp ~= nil then
		v2.oneof_prop = {
			type = "udim_prop",
			value = prop_types.UDimProp.jsonDecode(data.udimProp)
		}
	end

	if data.udim2_prop ~= nil then
		v2.oneof_prop = {
			type = "udim2_prop",
			value = prop_types.UDim2Prop.jsonDecode(data.udim2_prop)
		}
	end

	if data.udim2Prop ~= nil then
		v2.oneof_prop = {
			type = "udim2_prop",
			value = prop_types.UDim2Prop.jsonDecode(data.udim2Prop)
		}
	end

	if data.vector2_prop ~= nil then
		v2.oneof_prop = {
			type = "vector2_prop",
			value = prop_types.Vector2Prop.jsonDecode(data.vector2_prop)
		}
	end

	if data.vector2Prop ~= nil then
		v2.oneof_prop = {
			type = "vector2_prop",
			value = prop_types.Vector2Prop.jsonDecode(data.vector2Prop)
		}
	end

	if data.ui_scaled_float_prop ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_float_prop",
			value = prop_types.UiScaledFloatProp.jsonDecode(data.ui_scaled_float_prop)
		}
	end

	if data.uiScaledFloatProp ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_float_prop",
			value = prop_types.UiScaledFloatProp.jsonDecode(data.uiScaledFloatProp)
		}
	end

	if data.ui_scaled_udim_prop ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_udim_prop",
			value = prop_types.UiScaledUDimProp.jsonDecode(data.ui_scaled_udim_prop)
		}
	end

	if data.uiScaledUdimProp ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_udim_prop",
			value = prop_types.UiScaledUDimProp.jsonDecode(data.uiScaledUdimProp)
		}
	end

	if data.ui_scaled_udim2_prop ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_udim2_prop",
			value = prop_types.UiScaledUDim2Prop.jsonDecode(data.ui_scaled_udim2_prop)
		}
	end

	if data.uiScaledUdim2Prop ~= nil then
		v2.oneof_prop = {
			type = "ui_scaled_udim2_prop",
			value = prop_types.UiScaledUDim2Prop.jsonDecode(data.uiScaledUdim2Prop)
		}
	end

	if data.fill_behavior_prop ~= nil then
		v2.oneof_prop = {
			type = "fill_behavior_prop",
			value = prop_types.FillBehaviorProp.jsonDecode(data.fill_behavior_prop)
		}
	end

	if data.fillBehaviorProp ~= nil then
		v2.oneof_prop = {
			type = "fill_behavior_prop",
			value = prop_types.FillBehaviorProp.jsonDecode(data.fillBehaviorProp)
		}
	end

	if data.input_size_prop ~= nil then
		v2.oneof_prop = {
			type = "input_size_prop",
			value = prop_types.InputSizeProp.jsonDecode(data.input_size_prop)
		}
	end

	if data.inputSizeProp ~= nil then
		v2.oneof_prop = {
			type = "input_size_prop",
			value = prop_types.InputSizeProp.jsonDecode(data.inputSizeProp)
		}
	end

	if data.automatic_size_prop ~= nil then
		v2.oneof_prop = {
			type = "automatic_size_prop",
			value = prop_types_engine.AutomaticSizeProp.jsonDecode(data.automatic_size_prop)
		}
	end

	if data.automaticSizeProp ~= nil then
		v2.oneof_prop = {
			type = "automatic_size_prop",
			value = prop_types_engine.AutomaticSizeProp.jsonDecode(data.automaticSizeProp)
		}
	end

	if data.text_truncate_prop ~= nil then
		v2.oneof_prop = {
			type = "text_truncate_prop",
			value = prop_types_engine.TextTruncateProp.jsonDecode(data.text_truncate_prop)
		}
	end

	if data.textTruncateProp ~= nil then
		v2.oneof_prop = {
			type = "text_truncate_prop",
			value = prop_types_engine.TextTruncateProp.jsonDecode(data.textTruncateProp)
		}
	end

	if data.text_x_alignment_prop ~= nil then
		v2.oneof_prop = {
			type = "text_x_alignment_prop",
			value = prop_types_engine.TextXAlignmentProp.jsonDecode(data.text_x_alignment_prop)
		}
	end

	if data.textXAlignmentProp ~= nil then
		v2.oneof_prop = {
			type = "text_x_alignment_prop",
			value = prop_types_engine.TextXAlignmentProp.jsonDecode(data.textXAlignmentProp)
		}
	end

	if data.text_y_alignment_prop ~= nil then
		v2.oneof_prop = {
			type = "text_y_alignment_prop",
			value = prop_types_engine.TextYAlignmentProp.jsonDecode(data.text_y_alignment_prop)
		}
	end

	if data.textYAlignmentProp ~= nil then
		v2.oneof_prop = {
			type = "text_y_alignment_prop",
			value = prop_types_engine.TextYAlignmentProp.jsonDecode(data.textYAlignmentProp)
		}
	end

	if data.ui_flex_mode_prop ~= nil then
		v2.oneof_prop = {
			type = "ui_flex_mode_prop",
			value = prop_types_engine.UIFlexModeProp.jsonDecode(data.ui_flex_mode_prop)
		}
	end

	if data.uiFlexModeProp ~= nil then
		v2.oneof_prop = {
			type = "ui_flex_mode_prop",
			value = prop_types_engine.UIFlexModeProp.jsonDecode(data.uiFlexModeProp)
		}
	end

	if data.scale_type_prop ~= nil then
		v2.oneof_prop = {
			type = "scale_type_prop",
			value = prop_types_engine.ScaleTypeProp.jsonDecode(data.scale_type_prop)
		}
	end

	if data.scaleTypeProp ~= nil then
		v2.oneof_prop = {
			type = "scale_type_prop",
			value = prop_types_engine.ScaleTypeProp.jsonDecode(data.scaleTypeProp)
		}
	end

	if data.resampler_mode_prop ~= nil then
		v2.oneof_prop = {
			type = "resampler_mode_prop",
			value = prop_types_engine.ResamplerModeProp.jsonDecode(data.resampler_mode_prop)
		}
	end

	if data.resamplerModeProp ~= nil then
		v2.oneof_prop = {
			type = "resampler_mode_prop",
			value = prop_types_engine.ResamplerModeProp.jsonDecode(data.resamplerModeProp)
		}
	end

	if data.size_constraint_prop ~= nil then
		v2.oneof_prop = {
			type = "size_constraint_prop",
			value = prop_types_engine.SizeConstraintProp.jsonDecode(data.size_constraint_prop)
		}
	end

	if data.sizeConstraintProp ~= nil then
		v2.oneof_prop = {
			type = "size_constraint_prop",
			value = prop_types_engine.SizeConstraintProp.jsonDecode(data.sizeConstraintProp)
		}
	end

	if data.selection_behavior_prop ~= nil then
		v2.oneof_prop = {
			type = "selection_behavior_prop",
			value = prop_types_engine.SelectionBehaviorProp.jsonDecode(data.selection_behavior_prop)
		}
	end

	if data.selectionBehaviorProp ~= nil then
		v2.oneof_prop = {
			type = "selection_behavior_prop",
			value = prop_types_engine.SelectionBehaviorProp.jsonDecode(data.selectionBehaviorProp)
		}
	end

	if data.key_code_prop ~= nil then
		v2.oneof_prop = {
			type = "key_code_prop",
			value = prop_types_engine.KeyCodeProp.jsonDecode(data.key_code_prop)
		}
	end

	if data.keyCodeProp ~= nil then
		v2.oneof_prop = {
			type = "key_code_prop",
			value = prop_types_engine.KeyCodeProp.jsonDecode(data.keyCodeProp)
		}
	end

	return v2
end

class.descriptor = {
	name = "ExperimentalProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperimentalProp"
}

v.ExperimentalProp = class

typeRegistry.default:register(v.ExperimentalProp)

return { ExperimentalProp = v.ExperimentalProp }
