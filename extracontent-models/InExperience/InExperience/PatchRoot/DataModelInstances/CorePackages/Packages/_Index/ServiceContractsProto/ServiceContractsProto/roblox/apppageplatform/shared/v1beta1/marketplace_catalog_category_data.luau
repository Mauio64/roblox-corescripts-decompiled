local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 77
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		title = if t3 ~= nil and t3.title ~= nil then t3.title else "",
		name = if t3 ~= nil and t3.name ~= nil then t3.name else "",
		taxonomy_id = if t3 ~= nil and t3.taxonomy_id ~= nil then t3.taxonomy_id else "",
		buttons_enabled = if t3 ~= nil and t3.buttons_enabled ~= nil then t3.buttons_enabled else {},
		subcategories = if t3 ~= nil and t3.subcategories ~= nil then t3.subcategories else {},
		default_subcategory_id = if t3 ~= nil and t3.default_subcategory_id ~= nil then t3.default_subcategory_id else "",
		asset_types = if t3 ~= nil and t3.asset_types ~= nil then t3.asset_types else {},
		bundle_types = if t3 ~= nil and t3.bundle_types ~= nil then t3.bundle_types else {},
		can_animate_camera_based_mood = t3 ~= nil and (t3.can_animate_camera_based_mood ~= nil and t3.can_animate_camera_based_mood),
		camera_focus = if t3 ~= nil and t3.camera_focus ~= nil then t3.camera_focus else "",
		camera_zoom_radius = if t3 ~= nil and t3.camera_zoom_radius ~= nil then t3.camera_zoom_radius else 0,
		tile_type = if t3 ~= nil and t3.tile_type ~= nil then t3.tile_type else "",
		looks_widget_context_for_organic_content = if t3 ~= nil and t3.looks_widget_context_for_organic_content ~= nil then t3.looks_widget_context_for_organic_content else "",
		time_to_refresh = if t3 ~= nil and t3.time_to_refresh ~= nil then t3.time_to_refresh else 0,
		category_id = if t3 ~= nil and t3.category_id ~= nil then t3.category_id else 0,
		subcategory_id = if t3 ~= nil and t3.subcategory_id ~= nil then t3.subcategory_id else 0
	}, t2))
end
function t2.encode(p1) -- line: 108
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	if p1.title ~= nil and p1.title ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.title)
	end

	if p1.name ~= nil and p1.name ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.name)
	end

	if p1.taxonomy_id ~= nil and p1.taxonomy_id ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.taxonomy_id)
	end

	if p1.buttons_enabled ~= nil and #p1.buttons_enabled > 0 then
		for _, v18 in p1.buttons_enabled do
			local v19, v20 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v19, v20, v18)
		end
	end

	if p1.subcategories ~= nil and #p1.subcategories > 0 then
		for _, v22 in p1.subcategories do
			local v23, v24 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v23, v24, v22)
		end
	end

	if p1.default_subcategory_id ~= nil and p1.default_subcategory_id ~= "" then
		local v25, v26 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v25, v26, p1.default_subcategory_id)
	end

	if p1.asset_types ~= nil and #p1.asset_types > 0 then
		for _, v28 in p1.asset_types do
			local v29, v30 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v29, v30, v28)
		end
	end

	if p1.bundle_types ~= nil and #p1.bundle_types > 0 then
		for _, v32 in p1.bundle_types do
			local v33, v34 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v33, v34, v32)
		end
	end

	if p1.can_animate_camera_based_mood then
		local v35, v36 = proto.writeTag(buf, n1, 10, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v35, v36, not p1.can_animate_camera_based_mood and 0 or 1)
	end

	if p1.camera_focus ~= nil and p1.camera_focus ~= "" then
		local v37, v38 = proto.writeTag(buf, n1, 11, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v37, v38, p1.camera_focus)
	end

	if p1.camera_zoom_radius ~= nil and p1.camera_zoom_radius ~= 0 then
		local v39, v40 = proto.writeTag(buf, n1, 12, proto.wireTypes.i32)

		buf, n1 = proto.writeFloat(v39, v40, p1.camera_zoom_radius)
	end

	if p1.tile_type ~= nil and p1.tile_type ~= "" then
		local v41, v42 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v41, v42, p1.tile_type)
	end

	if p1.looks_widget_context_for_organic_content ~= nil and p1.looks_widget_context_for_organic_content ~= "" then
		local v43, v44 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v43, v44, p1.looks_widget_context_for_organic_content)
	end

	if p1.time_to_refresh ~= nil and p1.time_to_refresh ~= 0 then
		local v45, v46 = proto.writeTag(buf, n1, 15, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v45, v46, p1.time_to_refresh)
	end

	if p1.category_id ~= nil and p1.category_id ~= 0 then
		local v47, v48 = proto.writeTag(buf, n1, 16, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v47, v48, p1.category_id)
	end

	if p1.subcategory_id ~= nil and p1.subcategory_id ~= 0 then
		local v49, v50 = proto.writeTag(buf, n1, 17, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v49, v50, p1.subcategory_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 213
	-- upvalues: t2 (copy), proto (copy)
	local v53 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v55, v56

		v55, v56, n2 = proto.readTag(p2, n2)

		if v56 == proto.wireTypes.varint then
			if v55 == 10 then
				local v57

				v57, n2 = proto.readVarInt(p2, n2)
				v53.can_animate_camera_based_mood = v57 ~= 0
			elseif v55 == 15 then
				local v58

				v58, n2 = proto.readVarIntI64(p2, n2)
				v53.time_to_refresh = v58
			elseif v55 == 16 then
				local v59

				v59, n2 = proto.readVarIntI64(p2, n2)
				v53.category_id = v59
			elseif v55 == 17 then
				local v60

				v60, n2 = proto.readVarIntI64(p2, n2)
				v53.subcategory_id = v60
			else
				local v61

				v61, n2 = proto.readVarInt(p2, n2)
			end
		elseif v56 == proto.wireTypes.lengthDelimited then
			if v55 == 1 then
				local v62

				v62, n2 = proto.readBuffer(p2, n2)
				v53.id = buffer.tostring(v62)
			elseif v55 == 2 then
				local v63

				v63, n2 = proto.readBuffer(p2, n2)
				v53.title = buffer.tostring(v63)
			elseif v55 == 3 then
				local v64

				v64, n2 = proto.readBuffer(p2, n2)
				v53.name = buffer.tostring(v64)
			elseif v55 == 4 then
				local v65

				v65, n2 = proto.readBuffer(p2, n2)
				v53.taxonomy_id = buffer.tostring(v65)
			elseif v55 == 5 then
				local v66

				v66, n2 = proto.readBuffer(p2, n2)
				table.insert(v53.buttons_enabled, buffer.tostring(v66))
			elseif v55 == 6 then
				local v67

				v67, n2 = proto.readBuffer(p2, n2)
				table.insert(v53.subcategories, buffer.tostring(v67))
			elseif v55 == 7 then
				local v68

				v68, n2 = proto.readBuffer(p2, n2)
				v53.default_subcategory_id = buffer.tostring(v68)
			elseif v55 == 8 then
				local v69

				v69, n2 = proto.readBuffer(p2, n2)
				table.insert(v53.asset_types, buffer.tostring(v69))
			elseif v55 == 9 then
				local v70

				v70, n2 = proto.readBuffer(p2, n2)
				table.insert(v53.bundle_types, buffer.tostring(v70))
			elseif v55 == 11 then
				local v71

				v71, n2 = proto.readBuffer(p2, n2)
				v53.camera_focus = buffer.tostring(v71)
			elseif v55 == 13 then
				local v72

				v72, n2 = proto.readBuffer(p2, n2)
				v53.tile_type = buffer.tostring(v72)
			elseif v55 == 14 then
				local v73

				v73, n2 = proto.readBuffer(p2, n2)
				v53.looks_widget_context_for_organic_content = buffer.tostring(v73)
			else
				local v74, v75 = proto.readVarInt(p2, n2)

				n2 = v75 + v74
			end
		elseif v56 == proto.wireTypes.i32 then
			if v55 == 12 then
				local v76

				v76, n2 = proto.readFloat(p2, n2)
				v53.camera_zoom_radius = v76
			else
				local v77

				v77, n2 = proto.readFixed32(p2, n2)
			end
		elseif v56 == proto.wireTypes.i64 then
			local v78

			v78, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v56)
		end
	end

	return v53
end
function t2.jsonEncode(p3) -- line: 336
	-- upvalues: proto (copy)
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.title ~= nil and p3.title ~= "" then
		t4.title = p3.title
	end

	if p3.name ~= nil and p3.name ~= "" then
		t4.name = p3.name
	end

	if p3.taxonomy_id ~= nil and p3.taxonomy_id ~= "" then
		t4.taxonomyId = p3.taxonomy_id
	end

	if p3.buttons_enabled ~= nil and #p3.buttons_enabled > 0 then
		local t5 = {}

		for _, v83 in p3.buttons_enabled do
			table.insert(t5, v83)
		end

		t4.buttonsEnabled = t5
	end

	if p3.subcategories ~= nil and #p3.subcategories > 0 then
		local t6 = {}

		for _, v86 in p3.subcategories do
			table.insert(t6, v86)
		end

		t4.subcategories = t6
	end

	if p3.default_subcategory_id ~= nil and p3.default_subcategory_id ~= "" then
		t4.defaultSubcategoryId = p3.default_subcategory_id
	end

	if p3.asset_types ~= nil and #p3.asset_types > 0 then
		local t7 = {}

		for _, v89 in p3.asset_types do
			table.insert(t7, v89)
		end

		t4.assetTypes = t7
	end

	if p3.bundle_types ~= nil and #p3.bundle_types > 0 then
		local t8 = {}

		for _, v92 in p3.bundle_types do
			table.insert(t8, v92)
		end

		t4.bundleTypes = t8
	end

	if p3.can_animate_camera_based_mood then
		t4.canAnimateCameraBasedMood = p3.can_animate_camera_based_mood
	end

	if p3.camera_focus ~= nil and p3.camera_focus ~= "" then
		t4.cameraFocus = p3.camera_focus
	end

	if p3.camera_zoom_radius ~= nil and p3.camera_zoom_radius ~= 0 then
		t4.cameraZoomRadius = proto.json.serializeNumber(p3.camera_zoom_radius)
	end

	if p3.tile_type ~= nil and p3.tile_type ~= "" then
		t4.tileType = p3.tile_type
	end

	if p3.looks_widget_context_for_organic_content ~= nil and p3.looks_widget_context_for_organic_content ~= "" then
		t4.looksWidgetContextForOrganicContent = p3.looks_widget_context_for_organic_content
	end

	if p3.time_to_refresh ~= nil and p3.time_to_refresh ~= 0 then
		t4.timeToRefresh = p3.time_to_refresh
	end

	if p3.category_id ~= nil and p3.category_id ~= 0 then
		t4.categoryId = p3.category_id
	end

	if p3.subcategory_id ~= nil and p3.subcategory_id ~= 0 then
		t4.subcategoryId = p3.subcategory_id
	end

	return t4
end
function t2.jsonDecode(t9: {[any]: any}) -- line: 429
	-- upvalues: t2 (copy), proto (copy)
	local v94 = t2.new()

	if t9.id ~= nil then
		v94.id = t9.id
	end

	if t9.title ~= nil then
		v94.title = t9.title
	end

	if t9.name ~= nil then
		v94.name = t9.name
	end

	if t9.taxonomy_id ~= nil then
		v94.taxonomy_id = t9.taxonomy_id
	end

	if t9.taxonomyId ~= nil then
		v94.taxonomy_id = t9.taxonomyId
	end

	if t9.buttons_enabled ~= nil then
		local t10 = {}

		for _, v97 in t9.buttons_enabled do
			table.insert(t10, v97)
		end

		v94.buttons_enabled = t10
	end

	if t9.buttonsEnabled ~= nil then
		local t11 = {}

		for _, v100 in t9.buttonsEnabled do
			table.insert(t11, v100)
		end

		v94.buttons_enabled = t11
	end

	if t9.subcategories ~= nil then
		local t12 = {}

		for _, v103 in t9.subcategories do
			table.insert(t12, v103)
		end

		v94.subcategories = t12
	end

	if t9.default_subcategory_id ~= nil then
		v94.default_subcategory_id = t9.default_subcategory_id
	end

	if t9.defaultSubcategoryId ~= nil then
		v94.default_subcategory_id = t9.defaultSubcategoryId
	end

	if t9.asset_types ~= nil then
		local t13 = {}

		for _, v106 in t9.asset_types do
			table.insert(t13, v106)
		end

		v94.asset_types = t13
	end

	if t9.assetTypes ~= nil then
		local t14 = {}

		for _, v109 in t9.assetTypes do
			table.insert(t14, v109)
		end

		v94.asset_types = t14
	end

	if t9.bundle_types ~= nil then
		local t15 = {}

		for _, v112 in t9.bundle_types do
			table.insert(t15, v112)
		end

		v94.bundle_types = t15
	end

	if t9.bundleTypes ~= nil then
		local t16 = {}

		for _, v115 in t9.bundleTypes do
			table.insert(t16, v115)
		end

		v94.bundle_types = t16
	end

	if t9.can_animate_camera_based_mood ~= nil then
		v94.can_animate_camera_based_mood = t9.can_animate_camera_based_mood
	end

	if t9.canAnimateCameraBasedMood ~= nil then
		v94.can_animate_camera_based_mood = t9.canAnimateCameraBasedMood
	end

	if t9.camera_focus ~= nil then
		v94.camera_focus = t9.camera_focus
	end

	if t9.cameraFocus ~= nil then
		v94.camera_focus = t9.cameraFocus
	end

	if t9.camera_zoom_radius ~= nil then
		v94.camera_zoom_radius = proto.json.deserializeNumber(t9.camera_zoom_radius)
	end

	if t9.cameraZoomRadius ~= nil then
		v94.camera_zoom_radius = proto.json.deserializeNumber(t9.cameraZoomRadius)
	end

	if t9.tile_type ~= nil then
		v94.tile_type = t9.tile_type
	end

	if t9.tileType ~= nil then
		v94.tile_type = t9.tileType
	end

	if t9.looks_widget_context_for_organic_content ~= nil then
		v94.looks_widget_context_for_organic_content = t9.looks_widget_context_for_organic_content
	end

	if t9.looksWidgetContextForOrganicContent ~= nil then
		v94.looks_widget_context_for_organic_content = t9.looksWidgetContextForOrganicContent
	end

	if t9.time_to_refresh ~= nil then
		v94.time_to_refresh = t9.time_to_refresh
	end

	if t9.timeToRefresh ~= nil then
		v94.time_to_refresh = t9.timeToRefresh
	end

	if t9.category_id ~= nil then
		v94.category_id = t9.category_id
	end

	if t9.categoryId ~= nil then
		v94.category_id = t9.categoryId
	end

	if t9.subcategory_id ~= nil then
		v94.subcategory_id = t9.subcategory_id
	end

	if t9.subcategoryId ~= nil then
		v94.subcategory_id = t9.subcategoryId
	end

	return v94
end

t2.descriptor = {
	name = "MarketplaceCatalogCategoryData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryData"
}
t1.MarketplaceCatalogCategoryData = t2
typeRegistry.default:register(t1.MarketplaceCatalogCategoryData)

return {
	MarketplaceCatalogCategoryData = t1.MarketplaceCatalogCategoryData
}
