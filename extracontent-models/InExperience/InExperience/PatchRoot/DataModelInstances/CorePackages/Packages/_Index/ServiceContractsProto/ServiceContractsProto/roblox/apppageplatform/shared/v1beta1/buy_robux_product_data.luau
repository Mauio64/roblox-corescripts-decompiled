local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		product_id = (data == nil or data.product_id == nil) and "" or data.product_id,
		provider_product_id = (data == nil or data.provider_product_id == nil) and "" or data.provider_product_id,
		robux_amount = (data == nil or data.robux_amount == nil) and 0 or data.robux_amount,
		non_promotional_platform_robux_amount = 0,
		display_price = 0,
		display_name = 0,
		inline_badge = 0,
		is_call_to_action = 0,
		bonus_robux = 0
	}
	local non_promotional_platform_robux_amount

	if not (data == nil or data.non_promotional_platform_robux_amount == nil) then
		non_promotional_platform_robux_amount = data.non_promotional_platform_robux_amount
	end

	v2.non_promotional_platform_robux_amount = non_promotional_platform_robux_amount

	v2.display_price = (data == nil or data.display_price == nil) and "" or data.display_price
	v2.display_name = (data == nil or data.display_name == nil) and "" or data.display_name
	local inline_badge

	if not (data == nil or data.inline_badge == nil) then
		inline_badge = data.inline_badge
	end

	v2.inline_badge = inline_badge
	v2.is_call_to_action = data ~= nil and data.is_call_to_action ~= nil and data.is_call_to_action
	local bonus_robux

	if not (data == nil or data.bonus_robux == nil) then
		bonus_robux = data.bonus_robux
	end

	v2.bonus_robux = bonus_robux
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.product_id ~= nil and self.product_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.product_id)
	end

	if self.provider_product_id ~= nil and self.provider_product_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.provider_product_id)
	end

	if self.robux_amount ~= nil and self.robux_amount ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.robux_amount)
	end

	if self.non_promotional_platform_robux_amount ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.non_promotional_platform_robux_amount)
	end

	if self.display_price ~= nil and self.display_price ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_price)
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.inline_badge ~= nil then
		local encoded = self.inline_badge:encode()
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.is_call_to_action then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_call_to_action and 1 or 0)
	end

	if self.bonus_robux ~= nil then
		local encoded = self.bonus_robux:encode()
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				local robux_amount
				robux_amount, v2 = proto.readVarIntI64(buf, v2)
				result.robux_amount = robux_amount
			elseif v3 == 4 then
				local non_promotional_platform_robux_amount
				non_promotional_platform_robux_amount, v2 = proto.readVarIntI64(buf, v2)
				result.non_promotional_platform_robux_amount = non_promotional_platform_robux_amount
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_call_to_action = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.product_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.provider_product_id = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_price = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.inline_badge = v.BuyRobuxInlineBadgeData.decode(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.bonus_robux = v.BuyRobuxBonusRobuxData.decode(v5)
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

	if self.product_id ~= nil and self.product_id ~= "" then
		v2.productId = self.product_id
	end

	if self.provider_product_id ~= nil and self.provider_product_id ~= "" then
		v2.providerProductId = self.provider_product_id
	end

	if self.robux_amount ~= nil and self.robux_amount ~= 0 then
		v2.robuxAmount = self.robux_amount
	end

	if self.non_promotional_platform_robux_amount ~= nil then
		v2.nonPromotionalPlatformRobuxAmount = self.non_promotional_platform_robux_amount
	end

	if self.display_price ~= nil and self.display_price ~= "" then
		v2.displayPrice = self.display_price
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.inline_badge ~= nil then
		v2.inlineBadge = self.inline_badge:jsonEncode()
	end

	if self.is_call_to_action then
		v2.isCallToAction = self.is_call_to_action
	end

	if self.bonus_robux ~= nil then
		v2.bonusRobux = self.bonus_robux:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.product_id ~= nil then
		v2.product_id = data.product_id
	end

	if data.productId ~= nil then
		v2.product_id = data.productId
	end

	if data.provider_product_id ~= nil then
		v2.provider_product_id = data.provider_product_id
	end

	if data.providerProductId ~= nil then
		v2.provider_product_id = data.providerProductId
	end

	if data.robux_amount ~= nil then
		v2.robux_amount = data.robux_amount
	end

	if data.robuxAmount ~= nil then
		v2.robux_amount = data.robuxAmount
	end

	if data.non_promotional_platform_robux_amount ~= nil then
		v2.non_promotional_platform_robux_amount = data.non_promotional_platform_robux_amount
	end

	if data.nonPromotionalPlatformRobuxAmount ~= nil then
		v2.non_promotional_platform_robux_amount = data.nonPromotionalPlatformRobuxAmount
	end

	if data.display_price ~= nil then
		v2.display_price = data.display_price
	end

	if data.displayPrice ~= nil then
		v2.display_price = data.displayPrice
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.inline_badge ~= nil then
		v2.inline_badge = v.BuyRobuxInlineBadgeData.jsonDecode(data.inline_badge)
	end

	if data.inlineBadge ~= nil then
		v2.inline_badge = v.BuyRobuxInlineBadgeData.jsonDecode(data.inlineBadge)
	end

	if data.is_call_to_action ~= nil then
		v2.is_call_to_action = data.is_call_to_action
	end

	if data.isCallToAction ~= nil then
		v2.is_call_to_action = data.isCallToAction
	end

	if data.bonus_robux ~= nil then
		v2.bonus_robux = v.BuyRobuxBonusRobuxData.jsonDecode(data.bonus_robux)
	end

	if data.bonusRobux ~= nil then
		v2.bonus_robux = v.BuyRobuxBonusRobuxData.jsonDecode(data.bonusRobux)
	end

	return v2
end

class.descriptor = {
	name = "BuyRobuxOneTimeProductData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxOneTimeProductData"
}

v.BuyRobuxOneTimeProductData = class

typeRegistry.default:register(v.BuyRobuxOneTimeProductData)

local class2 = {}
class2.__index = class2

function class2.new(p)
	return (setmetatable({
		name = (p == nil or p.name == nil) and "" or p.name,
		variant = (p == nil or p.variant == nil) and "" or p.variant
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.name ~= nil and self.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.variant ~= nil and self.variant ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.variant)
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
				result.name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.variant = buffer.tostring(v5)
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

	if self.name ~= nil and self.name ~= "" then
		v2.name = self.name
	end

	if self.variant ~= nil and self.variant ~= "" then
		v2.variant = self.variant
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.name ~= nil then
		v2.name = p.name
	end

	if p.variant ~= nil then
		v2.variant = p.variant
	end

	return v2
end

class2.descriptor = {
	name = "BuyRobuxIconData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxIconData"
}

v.BuyRobuxIconData = class2

typeRegistry.default:register(v.BuyRobuxIconData)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local icon

	if not (p == nil or p.icon == nil) then
		icon = p.icon
	end

	local v2 = {
		icon = icon,
		text = (p == nil or p.text == nil) and "" or p.text
	}
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.icon ~= nil then
		local encoded = self.icon:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.text ~= nil and self.text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
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
				result.icon = v.BuyRobuxIconData.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
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

function class3:jsonEncode()
	local v2 = {}

	if self.icon ~= nil then
		v2.icon = self.icon:jsonEncode()
	end

	if self.text ~= nil and self.text ~= "" then
		v2.text = self.text
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.icon ~= nil then
		v2.icon = v.BuyRobuxIconData.jsonDecode(p.icon)
	end

	if p.text ~= nil then
		v2.text = p.text
	end

	return v2
end

class3.descriptor = {
	name = "BuyRobuxInlineBadgeData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxInlineBadgeData"
}

v.BuyRobuxInlineBadgeData = class3

typeRegistry.default:register(v.BuyRobuxInlineBadgeData)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		amount = (data == nil or data.amount == nil) and 0 or data.amount,
		icon = 0,
		text = 0
	}
	local icon

	if not (data == nil or data.icon == nil) then
		icon = data.icon
	end

	v2.icon = icon
	v2.text = (data == nil or data.text == nil) and "" or data.text
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.amount ~= nil and self.amount ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.amount)
	end

	if self.icon ~= nil then
		local encoded = self.icon:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.text ~= nil and self.text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local amount
				amount, v2 = proto.readVarIntI64(buf, v2)
				result.amount = amount
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.icon = v.BuyRobuxIconData.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
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

function class4:jsonEncode()
	local v2 = {}

	if self.amount ~= nil and self.amount ~= 0 then
		v2.amount = self.amount
	end

	if self.icon ~= nil then
		v2.icon = self.icon:jsonEncode()
	end

	if self.text ~= nil and self.text ~= "" then
		v2.text = self.text
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.amount ~= nil then
		v2.amount = data.amount
	end

	if data.icon ~= nil then
		v2.icon = v.BuyRobuxIconData.jsonDecode(data.icon)
	end

	if data.text ~= nil then
		v2.text = data.text
	end

	return v2
end

class4.descriptor = {
	name = "BuyRobuxBonusRobuxData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxBonusRobuxData"
}

v.BuyRobuxBonusRobuxData = class4

typeRegistry.default:register(v.BuyRobuxBonusRobuxData)

local class5 = {}
class5.__index = class5

function class5.new(data)
	local v2 = {
		product_id = (data == nil or data.product_id == nil) and "" or data.product_id,
		is_free_trial = data ~= nil and data.is_free_trial ~= nil and data.is_free_trial,
		display_price = (data == nil or data.display_price == nil) and "" or data.display_price,
		benefits = (data == nil or data.benefits == nil) and {} or data.benefits,
		robux_amount = (data == nil or data.robux_amount == nil) and 0 or data.robux_amount,
		strikethrough_display_price = 0,
		is_redirect = 0,
		button_text = 0,
		title = 0
	}
	local strikethrough_display_price

	if not (data == nil or data.strikethrough_display_price == nil) then
		strikethrough_display_price = data.strikethrough_display_price
	end

	v2.strikethrough_display_price = strikethrough_display_price

	v2.is_redirect = data ~= nil and data.is_redirect ~= nil and data.is_redirect
	v2.button_text = (data == nil or data.button_text == nil) and "" or data.button_text
	v2.title = (data == nil or data.title == nil) and "" or data.title
	return (setmetatable(v2, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.product_id ~= nil and self.product_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.product_id)
	end

	if self.is_free_trial then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_free_trial and 1 or 0)
	end

	if self.display_price ~= nil and self.display_price ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_price)
	end

	if self.benefits ~= nil and #self.benefits > 0 then
		for _, benefit in self.benefits do
			local encoded = benefit:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.robux_amount ~= nil and self.robux_amount ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.robux_amount)
	end

	if self.strikethrough_display_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.strikethrough_display_price)
	end

	if self.is_redirect then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_redirect and 1 or 0)
	end

	if self.button_text ~= nil and self.button_text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.button_text)
	end

	if self.title ~= nil and self.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.title)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_free_trial = v5 ~= 0
			elseif v3 == 7 then
				local robux_amount
				robux_amount, v2 = proto.readVarIntI64(buf, v2)
				result.robux_amount = robux_amount
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_redirect = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.product_id = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_price = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.benefits, v.BuyRobuxSubscriptionBenefitData.decode(v5))
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.strikethrough_display_price = buffer.tostring(v5)
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.button_text = buffer.tostring(v5)
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
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

function class5:jsonEncode()
	local v2 = {}

	if self.product_id ~= nil and self.product_id ~= "" then
		v2.productId = self.product_id
	end

	if self.is_free_trial then
		v2.isFreeTrial = self.is_free_trial
	end

	if self.display_price ~= nil and self.display_price ~= "" then
		v2.displayPrice = self.display_price
	end

	if self.benefits ~= nil and #self.benefits > 0 then
		local benefits = {}

		for _, benefit in self.benefits do
			table.insert(benefits, benefit:jsonEncode())
		end

		v2.benefits = benefits
	end

	if self.robux_amount ~= nil and self.robux_amount ~= 0 then
		v2.robuxAmount = self.robux_amount
	end

	if self.strikethrough_display_price ~= nil then
		v2.strikethroughDisplayPrice = self.strikethrough_display_price
	end

	if self.is_redirect then
		v2.isRedirect = self.is_redirect
	end

	if self.button_text ~= nil and self.button_text ~= "" then
		v2.buttonText = self.button_text
	end

	if self.title ~= nil and self.title ~= "" then
		v2.title = self.title
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.product_id ~= nil then
		v2.product_id = data.product_id
	end

	if data.productId ~= nil then
		v2.product_id = data.productId
	end

	if data.is_free_trial ~= nil then
		v2.is_free_trial = data.is_free_trial
	end

	if data.isFreeTrial ~= nil then
		v2.is_free_trial = data.isFreeTrial
	end

	if data.display_price ~= nil then
		v2.display_price = data.display_price
	end

	if data.displayPrice ~= nil then
		v2.display_price = data.displayPrice
	end

	if data.benefits ~= nil then
		local benefits = {}

		for _, benefit in data.benefits do
			table.insert(benefits, v.BuyRobuxSubscriptionBenefitData.jsonDecode(benefit))
		end

		v2.benefits = benefits
	end

	if data.robux_amount ~= nil then
		v2.robux_amount = data.robux_amount
	end

	if data.robuxAmount ~= nil then
		v2.robux_amount = data.robuxAmount
	end

	if data.strikethrough_display_price ~= nil then
		v2.strikethrough_display_price = data.strikethrough_display_price
	end

	if data.strikethroughDisplayPrice ~= nil then
		v2.strikethrough_display_price = data.strikethroughDisplayPrice
	end

	if data.is_redirect ~= nil then
		v2.is_redirect = data.is_redirect
	end

	if data.isRedirect ~= nil then
		v2.is_redirect = data.isRedirect
	end

	if data.button_text ~= nil then
		v2.button_text = data.button_text
	end

	if data.buttonText ~= nil then
		v2.button_text = data.buttonText
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	return v2
end

class5.descriptor = {
	name = "BuyRobuxSubscriptionProductData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxSubscriptionProductData"
}

v.BuyRobuxSubscriptionProductData = class5

typeRegistry.default:register(v.BuyRobuxSubscriptionProductData)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local icon

	if not (p == nil or p.icon == nil) then
		icon = p.icon
	end

	local v2 = {
		icon = icon,
		text = (p == nil or p.text == nil) and "" or p.text
	}
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.icon ~= nil then
		local encoded = self.icon:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.text ~= nil and self.text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
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
				result.icon = v.BuyRobuxIconData.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
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

function class6:jsonEncode()
	local v2 = {}

	if self.icon ~= nil then
		v2.icon = self.icon:jsonEncode()
	end

	if self.text ~= nil and self.text ~= "" then
		v2.text = self.text
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.icon ~= nil then
		v2.icon = v.BuyRobuxIconData.jsonDecode(p.icon)
	end

	if p.text ~= nil then
		v2.text = p.text
	end

	return v2
end

class6.descriptor = {
	name = "BuyRobuxSubscriptionBenefitData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxSubscriptionBenefitData"
}

v.BuyRobuxSubscriptionBenefitData = class6

typeRegistry.default:register(v.BuyRobuxSubscriptionBenefitData)

return {
	BuyRobuxOneTimeProductData = v.BuyRobuxOneTimeProductData,
	BuyRobuxIconData = v.BuyRobuxIconData,
	BuyRobuxInlineBadgeData = v.BuyRobuxInlineBadgeData,
	BuyRobuxBonusRobuxData = v.BuyRobuxBonusRobuxData,
	BuyRobuxSubscriptionProductData = v.BuyRobuxSubscriptionProductData,
	BuyRobuxSubscriptionBenefitData = v.BuyRobuxSubscriptionBenefitData
}
