local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		name = (data == nil or data.name == nil) and "" or data.name,
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		contains = data ~= nil and data.contains ~= nil and data.contains
	}
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.name ~= nil and self.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.contains then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.contains and 1 or 0)
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
			if v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.contains = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
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

	if self.name ~= nil and self.name ~= "" then
		v2.name = self.name
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.contains then
		v2.contains = self.contains
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.contains ~= nil then
		v2.contains = data.contains
	end

	return v2
end

class.descriptor = {
	name = "AgeRecommendationDescriptor",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeRecommendationDescriptor"
}

v.AgeRecommendationDescriptor = class

typeRegistry.default:register(v.AgeRecommendationDescriptor)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		display_name_with_header_short = (data == nil or data.display_name_with_header_short == nil) and "" or data.display_name_with_header_short,
		igrs_rating = (data == nil or data.igrs_rating == nil) and "" or data.igrs_rating,
		igrs_rating_display_message = (data == nil or data.igrs_rating_display_message == nil) and "" or data.igrs_rating_display_message,
		descriptors = (data == nil or data.descriptors == nil) and {} or data.descriptors,
		minimum_age_display = 0
	}
	local minimum_age_display

	if not (data == nil or data.minimum_age_display == nil) then
		minimum_age_display = data.minimum_age_display
	end

	v2.minimum_age_display = minimum_age_display
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.display_name_with_header_short ~= nil and self.display_name_with_header_short ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name_with_header_short)
	end

	if self.igrs_rating ~= nil and self.igrs_rating ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.igrs_rating)
	end

	if self.igrs_rating_display_message ~= nil and self.igrs_rating_display_message ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.igrs_rating_display_message)
	end

	if self.descriptors ~= nil and #self.descriptors > 0 then
		for _, descriptor in self.descriptors do
			local encoded = descriptor:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.minimum_age_display ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.minimum_age_display)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
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
				result.display_name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name_with_header_short = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.igrs_rating = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.igrs_rating_display_message = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.descriptors, v.AgeRecommendationDescriptor.decode(v5))
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.minimum_age_display = buffer.tostring(v5)
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

function class2:jsonEncode()
	local v2 = {}

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.display_name_with_header_short ~= nil and self.display_name_with_header_short ~= "" then
		v2.displayNameWithHeaderShort = self.display_name_with_header_short
	end

	if self.igrs_rating ~= nil and self.igrs_rating ~= "" then
		v2.igrsRating = self.igrs_rating
	end

	if self.igrs_rating_display_message ~= nil and self.igrs_rating_display_message ~= "" then
		v2.igrsRatingDisplayMessage = self.igrs_rating_display_message
	end

	if self.descriptors ~= nil and #self.descriptors > 0 then
		local descriptors = {}

		for _, descriptor in self.descriptors do
			table.insert(descriptors, descriptor:jsonEncode())
		end

		v2.descriptors = descriptors
	end

	if self.minimum_age_display ~= nil then
		v2.minimumAgeDisplay = self.minimum_age_display
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.display_name_with_header_short ~= nil then
		v2.display_name_with_header_short = data.display_name_with_header_short
	end

	if data.displayNameWithHeaderShort ~= nil then
		v2.display_name_with_header_short = data.displayNameWithHeaderShort
	end

	if data.igrs_rating ~= nil then
		v2.igrs_rating = data.igrs_rating
	end

	if data.igrsRating ~= nil then
		v2.igrs_rating = data.igrsRating
	end

	if data.igrs_rating_display_message ~= nil then
		v2.igrs_rating_display_message = data.igrs_rating_display_message
	end

	if data.igrsRatingDisplayMessage ~= nil then
		v2.igrs_rating_display_message = data.igrsRatingDisplayMessage
	end

	if data.descriptors ~= nil then
		local descriptors = {}

		for _, descriptor in data.descriptors do
			table.insert(descriptors, v.AgeRecommendationDescriptor.jsonDecode(descriptor))
		end

		v2.descriptors = descriptors
	end

	if data.minimum_age_display ~= nil then
		v2.minimum_age_display = data.minimum_age_display
	end

	if data.minimumAgeDisplay ~= nil then
		v2.minimum_age_display = data.minimumAgeDisplay
	end

	return v2
end

class2.descriptor = {
	name = "AgeRecommendationData",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeRecommendationData"
}

v.AgeRecommendationData = class2

typeRegistry.default:register(v.AgeRecommendationData)

return {
	AgeRecommendationDescriptor = v.AgeRecommendationDescriptor,
	AgeRecommendationData = v.AgeRecommendationData
}
