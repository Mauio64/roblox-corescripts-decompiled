local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local taxonomy_id

	if not (p == nil or p.taxonomy_id == nil) then
		taxonomy_id = p.taxonomy_id
	end

	local v2 = {
		taxonomy_id = taxonomy_id,
		taxonomy_name = (p == nil or p.taxonomy_name == nil) and "" or p.taxonomy_name
	}
	return (setmetatable(v2, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.taxonomy_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.taxonomy_id)
	end

	if p.taxonomy_name ~= nil and p.taxonomy_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.taxonomy_name)
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
				result.taxonomy_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.taxonomy_name = buffer.tostring(v5)
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

function class.jsonEncode(p)
	local v2 = {}

	if p.taxonomy_id ~= nil then
		v2.taxonomyId = p.taxonomy_id
	end

	if p.taxonomy_name ~= nil and p.taxonomy_name ~= "" then
		v2.taxonomyName = p.taxonomy_name
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.taxonomy_id ~= nil then
		v2.taxonomy_id = data.taxonomy_id
	end

	if data.taxonomyId ~= nil then
		v2.taxonomy_id = data.taxonomyId
	end

	if data.taxonomy_name ~= nil then
		v2.taxonomy_name = data.taxonomy_name
	end

	if data.taxonomyName ~= nil then
		v2.taxonomy_name = data.taxonomyName
	end

	return v2
end

class.descriptor = {
	name = "MarketplaceCatalogTaxonomyNode",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogTaxonomyNode"
}

v.MarketplaceCatalogTaxonomyNode = class

typeRegistry.default:register(v.MarketplaceCatalogTaxonomyNode)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		days = (data == nil or data.days == nil) and 0 or data.days,
		price = (data == nil or data.price == nil) and 0 or data.price,
		selected = 0
	}
	local selected

	if not (data == nil or data.selected == nil) then
		selected = data.selected
	end

	v2.selected = selected
	return (setmetatable(v2, class2))
end

function class2.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.days ~= nil and data.days ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.days)
	end

	if data.price ~= nil and data.price ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.price)
	end

	if data.selected ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.selected and 1 or 0)
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
			if v3 == 1 then
				local days
				days, v2 = proto.readVarIntI32(buf, v2)
				result.days = days
			elseif v3 == 2 then
				local price
				price, v2 = proto.readVarIntI64(buf, v2)
				result.price = price
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.selected = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

function class2.jsonEncode(data)
	local v2 = {}

	if data.days ~= nil and data.days ~= 0 then
		v2.days = data.days
	end

	if data.price ~= nil and data.price ~= 0 then
		v2.price = data.price
	end

	if data.selected ~= nil then
		v2.selected = data.selected
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.days ~= nil then
		v2.days = data.days
	end

	if data.price ~= nil then
		v2.price = data.price
	end

	if data.selected ~= nil then
		v2.selected = data.selected
	end

	return v2
end

class2.descriptor = {
	name = "MarketplaceCatalogTimedOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogTimedOption"
}

v.MarketplaceCatalogTimedOption = class2

typeRegistry.default:register(v.MarketplaceCatalogTimedOption)

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({
		name = (p == nil or p.name == nil) and "" or p.name,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class3))
end

function class3.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.name ~= nil and p.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.name)
	end

	if p.value ~= nil and p.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.value)
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
				result.name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buffer.tostring(v5)
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

function class3.jsonEncode(p)
	local v2 = {}

	if p.name ~= nil and p.name ~= "" then
		v2.name = p.name
	end

	if p.value ~= nil and p.value ~= "" then
		v2.value = p.value
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.name ~= nil then
		v2.name = p.name
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class3.descriptor = {
	name = "MarketplaceCatalogVariantAttribute",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogVariantAttribute"
}

v.MarketplaceCatalogVariantAttribute = class3

typeRegistry.default:register(v.MarketplaceCatalogVariantAttribute)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		asset_type = 0,
		type = 0
	}
	local asset_type

	if not (data == nil or data.asset_type == nil) then
		asset_type = data.asset_type
	end

	v2.asset_type = asset_type
	v2.type = (data == nil or data.type == nil) and "" or data.type
	return (setmetatable(v2, class4))
end

function class4.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.asset_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.asset_type)
	end

	if data.type ~= nil and data.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.type)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.asset_type = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
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

function class4.jsonEncode(data)
	local v2 = {}

	if data.id ~= nil and data.id ~= "" then
		v2.id = data.id
	end

	if data.asset_type ~= nil then
		v2.assetType = data.asset_type
	end

	if data.type ~= nil and data.type ~= "" then
		v2.type = data.type
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.asset_type ~= nil then
		v2.asset_type = data.asset_type
	end

	if data.assetType ~= nil then
		v2.asset_type = data.assetType
	end

	if data.type ~= nil then
		v2.type = data.type
	end

	return v2
end

class4.descriptor = {
	name = "MarketplaceCatalogBundledItem",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogBundledItem"
}

v.MarketplaceCatalogBundledItem = class4

typeRegistry.default:register(v.MarketplaceCatalogBundledItem)

local class5 = {}
class5.__index = class5

function class5.new(data)
	local id

	if not (data == nil or data.id == nil) then
		id = data.id
	end

	local v2 = {
		id = id,
		license_type = (data == nil or data.license_type == nil) and "" or data.license_type,
		badge_asset_id = 0,
		name = 0,
		license_display_name = 0
	}
	local badge_asset_id

	if not (data == nil or data.badge_asset_id == nil) then
		badge_asset_id = data.badge_asset_id
	end

	v2.badge_asset_id = badge_asset_id
	local name

	if not (data == nil or data.name == nil) then
		name = data.name
	end

	v2.name = name
	local license_display_name

	if not (data == nil or data.license_display_name == nil) then
		license_display_name = data.license_display_name
	end

	v2.license_display_name = license_display_name
	return (setmetatable(v2, class5))
end

function class5.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.license_type ~= nil and data.license_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.license_type)
	end

	if data.badge_asset_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.badge_asset_id)
	end

	if data.name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.name)
	end

	if data.license_display_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.license_display_name)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.license_type = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.badge_asset_id = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.license_display_name = buffer.tostring(v5)
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

function class5.jsonEncode(data)
	local v2 = {}

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.license_type ~= nil and data.license_type ~= "" then
		v2.licenseType = data.license_type
	end

	if data.badge_asset_id ~= nil then
		v2.badgeAssetId = data.badge_asset_id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.license_display_name ~= nil then
		v2.licenseDisplayName = data.license_display_name
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.license_type ~= nil then
		v2.license_type = data.license_type
	end

	if data.licenseType ~= nil then
		v2.license_type = data.licenseType
	end

	if data.badge_asset_id ~= nil then
		v2.badge_asset_id = data.badge_asset_id
	end

	if data.badgeAssetId ~= nil then
		v2.badge_asset_id = data.badgeAssetId
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.license_display_name ~= nil then
		v2.license_display_name = data.license_display_name
	end

	if data.licenseDisplayName ~= nil then
		v2.license_display_name = data.licenseDisplayName
	end

	return v2
end

class5.descriptor = {
	name = "MarketplaceCatalogItemLicensing",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogItemLicensing"
}

v.MarketplaceCatalogItemLicensing = class5

typeRegistry.default:register(v.MarketplaceCatalogItemLicensing)

return {
	MarketplaceCatalogTaxonomyNode = v.MarketplaceCatalogTaxonomyNode,
	MarketplaceCatalogTimedOption = v.MarketplaceCatalogTimedOption,
	MarketplaceCatalogVariantAttribute = v.MarketplaceCatalogVariantAttribute,
	MarketplaceCatalogBundledItem = v.MarketplaceCatalogBundledItem,
	MarketplaceCatalogItemLicensing = v.MarketplaceCatalogItemLicensing
}
