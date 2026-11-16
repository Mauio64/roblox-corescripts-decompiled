local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		title = (data == nil or data.title == nil) and "" or data.title,
		name = (data == nil or data.name == nil) and "" or data.name,
		taxonomy_id = (data == nil or data.taxonomy_id == nil) and "" or data.taxonomy_id,
		buttons_enabled = (data == nil or data.buttons_enabled == nil) and {} or data.buttons_enabled,
		subcategories = (data == nil or data.subcategories == nil) and {} or data.subcategories,
		default_subcategory_id = (data == nil or data.default_subcategory_id == nil) and "" or data.default_subcategory_id,
		asset_types = (data == nil or data.asset_types == nil) and {} or data.asset_types,
		bundle_types = (data == nil or data.bundle_types == nil) and {} or data.bundle_types,
		can_animate_camera_based_mood = data ~= nil and data.can_animate_camera_based_mood ~= nil and data.can_animate_camera_based_mood,
		camera_focus = (data == nil or data.camera_focus == nil) and "" or data.camera_focus,
		camera_zoom_radius = (data == nil or data.camera_zoom_radius == nil) and 0 or data.camera_zoom_radius,
		tile_type = (data == nil or data.tile_type == nil) and "" or data.tile_type,
		looks_widget_context_for_organic_content = (data == nil or data.looks_widget_context_for_organic_content == nil) and "" or data.looks_widget_context_for_organic_content,
		time_to_refresh = (data == nil or data.time_to_refresh == nil) and 0 or data.time_to_refresh,
		category_id = (data == nil or data.category_id == nil) and 0 or data.category_id,
		subcategory_id = (data == nil or data.subcategory_id == nil) and 0 or data.subcategory_id
	}
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.title ~= nil and data.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.title)
	end

	if data.name ~= nil and data.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.name)
	end

	if data.taxonomy_id ~= nil and data.taxonomy_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.taxonomy_id)
	end

	if data.buttons_enabled ~= nil and #data.buttons_enabled > 0 then
		for _, v4 in data.buttons_enabled do
			local v5, v6 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v5, v6, v4)
		end
	end

	if data.subcategories ~= nil and #data.subcategories > 0 then
		for _, subcategory in data.subcategories do
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, subcategory)
		end
	end

	if data.default_subcategory_id ~= nil and data.default_subcategory_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.default_subcategory_id)
	end

	if data.asset_types ~= nil and #data.asset_types > 0 then
		for _, asset_type in data.asset_types do
			local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, asset_type)
		end
	end

	if data.bundle_types ~= nil and #data.bundle_types > 0 then
		for _, bundle_type in data.bundle_types do
			local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, bundle_type)
		end
	end

	if data.can_animate_camera_based_mood then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.can_animate_camera_based_mood and 1 or 0)
	end

	if data.camera_focus ~= nil and data.camera_focus ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.camera_focus)
	end

	if data.camera_zoom_radius ~= nil and data.camera_zoom_radius ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, data.camera_zoom_radius)
	end

	if data.tile_type ~= nil and data.tile_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.tile_type)
	end

	if data.looks_widget_context_for_organic_content ~= nil and data.looks_widget_context_for_organic_content ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.looks_widget_context_for_organic_content)
	end

	if data.time_to_refresh ~= nil and data.time_to_refresh ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.time_to_refresh)
	end

	if data.category_id ~= nil and data.category_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.category_id)
	end

	if data.subcategory_id ~= nil and data.subcategory_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.subcategory_id)
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
			if v3 == 10 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_animate_camera_based_mood = v5 ~= 0
			elseif v3 == 15 then
				local time_to_refresh
				time_to_refresh, v2 = proto.readVarIntI64(buf, v2)
				result.time_to_refresh = time_to_refresh
			elseif v3 == 16 then
				local category_id
				category_id, v2 = proto.readVarIntI64(buf, v2)
				result.category_id = category_id
			elseif v3 == 17 then
				local subcategory_id
				subcategory_id, v2 = proto.readVarIntI64(buf, v2)
				result.subcategory_id = subcategory_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.taxonomy_id = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.buttons_enabled, buffer.tostring(v5))
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.subcategories, buffer.tostring(v5))
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.default_subcategory_id = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.asset_types, buffer.tostring(v5))
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.bundle_types, buffer.tostring(v5))
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.camera_focus = buffer.tostring(v5)
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.tile_type = buffer.tostring(v5)
			elseif v3 == 14 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.looks_widget_context_for_organic_content = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 12 then
				local camera_zoom_radius
				camera_zoom_radius, v2 = proto.readFloat(buf, v2)
				result.camera_zoom_radius = camera_zoom_radius
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class.jsonEncode(data)
	local v2 = {}

	if data.id ~= nil and data.id ~= "" then
		v2.id = data.id
	end

	if data.title ~= nil and data.title ~= "" then
		v2.title = data.title
	end

	if data.name ~= nil and data.name ~= "" then
		v2.name = data.name
	end

	if data.taxonomy_id ~= nil and data.taxonomy_id ~= "" then
		v2.taxonomyId = data.taxonomy_id
	end

	if data.buttons_enabled ~= nil and #data.buttons_enabled > 0 then
		local buttonsEnabled = {}

		for _, v3 in data.buttons_enabled do
			table.insert(buttonsEnabled, v3)
		end

		v2.buttonsEnabled = buttonsEnabled
	end

	if data.subcategories ~= nil and #data.subcategories > 0 then
		local subcategories = {}

		for _, subcategory in data.subcategories do
			table.insert(subcategories, subcategory)
		end

		v2.subcategories = subcategories
	end

	if data.default_subcategory_id ~= nil and data.default_subcategory_id ~= "" then
		v2.defaultSubcategoryId = data.default_subcategory_id
	end

	if data.asset_types ~= nil and #data.asset_types > 0 then
		local asset_types = {}

		for _, asset_type in data.asset_types do
			table.insert(asset_types, asset_type)
		end

		v2.assetTypes = asset_types
	end

	if data.bundle_types ~= nil and #data.bundle_types > 0 then
		local bundle_types = {}

		for _, bundle_type in data.bundle_types do
			table.insert(bundle_types, bundle_type)
		end

		v2.bundleTypes = bundle_types
	end

	if data.can_animate_camera_based_mood then
		v2.canAnimateCameraBasedMood = data.can_animate_camera_based_mood
	end

	if data.camera_focus ~= nil and data.camera_focus ~= "" then
		v2.cameraFocus = data.camera_focus
	end

	if data.camera_zoom_radius ~= nil and data.camera_zoom_radius ~= 0 then
		v2.cameraZoomRadius = proto.json.serializeNumber(data.camera_zoom_radius)
	end

	if data.tile_type ~= nil and data.tile_type ~= "" then
		v2.tileType = data.tile_type
	end

	if data.looks_widget_context_for_organic_content ~= nil and data.looks_widget_context_for_organic_content ~= "" then
		v2.looksWidgetContextForOrganicContent = data.looks_widget_context_for_organic_content
	end

	if data.time_to_refresh ~= nil and data.time_to_refresh ~= 0 then
		v2.timeToRefresh = data.time_to_refresh
	end

	if data.category_id ~= nil and data.category_id ~= 0 then
		v2.categoryId = data.category_id
	end

	if data.subcategory_id ~= nil and data.subcategory_id ~= 0 then
		v2.subcategoryId = data.subcategory_id
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.taxonomy_id ~= nil then
		v2.taxonomy_id = data.taxonomy_id
	end

	if data.taxonomyId ~= nil then
		v2.taxonomy_id = data.taxonomyId
	end

	if data.buttons_enabled ~= nil then
		local buttons_enabled = {}

		for _, v3 in data.buttons_enabled do
			table.insert(buttons_enabled, v3)
		end

		v2.buttons_enabled = buttons_enabled
	end

	if data.buttonsEnabled ~= nil then
		local buttons_enabled = {}

		for _, v3 in data.buttonsEnabled do
			table.insert(buttons_enabled, v3)
		end

		v2.buttons_enabled = buttons_enabled
	end

	if data.subcategories ~= nil then
		local subcategories = {}

		for _, subcategory in data.subcategories do
			table.insert(subcategories, subcategory)
		end

		v2.subcategories = subcategories
	end

	if data.default_subcategory_id ~= nil then
		v2.default_subcategory_id = data.default_subcategory_id
	end

	if data.defaultSubcategoryId ~= nil then
		v2.default_subcategory_id = data.defaultSubcategoryId
	end

	if data.asset_types ~= nil then
		local asset_types = {}

		for _, asset_type in data.asset_types do
			table.insert(asset_types, asset_type)
		end

		v2.asset_types = asset_types
	end

	if data.assetTypes ~= nil then
		local assetTypes = {}

		for _, assetType in data.assetTypes do
			table.insert(assetTypes, assetType)
		end

		v2.asset_types = assetTypes
	end

	if data.bundle_types ~= nil then
		local bundle_types = {}

		for _, bundle_type in data.bundle_types do
			table.insert(bundle_types, bundle_type)
		end

		v2.bundle_types = bundle_types
	end

	if data.bundleTypes ~= nil then
		local bundleTypes = {}

		for _, bundleType in data.bundleTypes do
			table.insert(bundleTypes, bundleType)
		end

		v2.bundle_types = bundleTypes
	end

	if data.can_animate_camera_based_mood ~= nil then
		v2.can_animate_camera_based_mood = data.can_animate_camera_based_mood
	end

	if data.canAnimateCameraBasedMood ~= nil then
		v2.can_animate_camera_based_mood = data.canAnimateCameraBasedMood
	end

	if data.camera_focus ~= nil then
		v2.camera_focus = data.camera_focus
	end

	if data.cameraFocus ~= nil then
		v2.camera_focus = data.cameraFocus
	end

	if data.camera_zoom_radius ~= nil then
		v2.camera_zoom_radius = proto.json.deserializeNumber(data.camera_zoom_radius)
	end

	if data.cameraZoomRadius ~= nil then
		v2.camera_zoom_radius = proto.json.deserializeNumber(data.cameraZoomRadius)
	end

	if data.tile_type ~= nil then
		v2.tile_type = data.tile_type
	end

	if data.tileType ~= nil then
		v2.tile_type = data.tileType
	end

	if data.looks_widget_context_for_organic_content ~= nil then
		v2.looks_widget_context_for_organic_content = data.looks_widget_context_for_organic_content
	end

	if data.looksWidgetContextForOrganicContent ~= nil then
		v2.looks_widget_context_for_organic_content = data.looksWidgetContextForOrganicContent
	end

	if data.time_to_refresh ~= nil then
		v2.time_to_refresh = data.time_to_refresh
	end

	if data.timeToRefresh ~= nil then
		v2.time_to_refresh = data.timeToRefresh
	end

	if data.category_id ~= nil then
		v2.category_id = data.category_id
	end

	if data.categoryId ~= nil then
		v2.category_id = data.categoryId
	end

	if data.subcategory_id ~= nil then
		v2.subcategory_id = data.subcategory_id
	end

	if data.subcategoryId ~= nil then
		v2.subcategory_id = data.subcategoryId
	end

	return v2
end

class.descriptor = {
	name = "MarketplaceCatalogCategoryData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryData"
}

v.MarketplaceCatalogCategoryData = class

typeRegistry.default:register(v.MarketplaceCatalogCategoryData)

return { MarketplaceCatalogCategoryData = v.MarketplaceCatalogCategoryData }
