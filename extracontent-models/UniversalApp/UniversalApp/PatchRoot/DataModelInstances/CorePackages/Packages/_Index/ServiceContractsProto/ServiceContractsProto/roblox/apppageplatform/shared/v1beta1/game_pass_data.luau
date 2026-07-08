local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 81
	-- upvalues: t2 (copy)
	return (setmetatable({
		type = if t3 ~= nil and t3.type ~= nil then t3.type else "",
		amount_in_robux = if t3 ~= nil and t3.amount_in_robux ~= nil then t3.amount_in_robux else 0,
		percent = if t3 ~= nil and t3.percent ~= nil then t3.percent else 0
	}, t2))
end
function t2.encode(p1) -- line: 89
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.type ~= nil and p1.type ~= "" then
		local v10, v11 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v10, v11, p1.type)
	end

	if p1.amount_in_robux ~= nil and p1.amount_in_robux ~= 0 then
		local v12, v13 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v12, v13, p1.amount_in_robux)
	end

	if p1.percent ~= nil and p1.percent ~= 0 then
		local v14, v15 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v14, v15, p1.percent)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 113
	-- upvalues: t2 (copy), proto (copy)
	local v18 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v20, v21

		v20, v21, n2 = proto.readTag(p2, n2)

		if v21 == proto.wireTypes.varint then
			if v20 == 2 then
				local v22

				v22, n2 = proto.readVarIntI64(p2, n2)
				v18.amount_in_robux = v22
			elseif v20 == 3 then
				local v23

				v23, n2 = proto.readVarIntI64(p2, n2)
				v18.percent = v23
			else
				local v24

				v24, n2 = proto.readVarInt(p2, n2)
			end
		elseif v21 == proto.wireTypes.lengthDelimited then
			if v20 == 1 then
				local v25

				v25, n2 = proto.readBuffer(p2, n2)
				v18.type = buffer.tostring(v25)
			else
				local v26, v27 = proto.readVarInt(p2, n2)

				n2 = v27 + v26
			end
		elseif v21 == proto.wireTypes.i32 then
			local v28

			v28, n2 = proto.readFixed32(p2, n2)
		elseif v21 == proto.wireTypes.i64 then
			local v29

			v29, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v21)
		end
	end

	return v18
end
function t2.jsonEncode(p3) -- line: 166
	local t4 = {}

	if p3.type ~= nil and p3.type ~= "" then
		t4.type = p3.type
	end

	if p3.amount_in_robux ~= nil and p3.amount_in_robux ~= 0 then
		t4.amountInRobux = p3.amount_in_robux
	end

	if p3.percent ~= nil and p3.percent ~= 0 then
		t4.percent = p3.percent
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 184
	-- upvalues: t2 (copy)
	local v33 = t2.new()

	if t5.type ~= nil then
		v33.type = t5.type
	end

	if t5.amount_in_robux ~= nil then
		v33.amount_in_robux = t5.amount_in_robux
	end

	if t5.amountInRobux ~= nil then
		v33.amount_in_robux = t5.amountInRobux
	end

	if t5.percent ~= nil then
		v33.percent = t5.percent
	end

	return v33
end

t2.descriptor = {
	name = "PriceDiscountDetail",
	fullName = "roblox.apppageplatform.shared.v1beta1.PriceDiscountDetail"
}
t1.PriceDiscountDetail = t2
typeRegistry.default:register(t1.PriceDiscountDetail)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 220
	-- upvalues: t6 (copy)
	return (setmetatable({
		id = if t7 ~= nil and t7.id ~= nil then t7.id else "",
		display_name = if t7 ~= nil and t7.display_name ~= nil then t7.display_name else "",
		price = if t7 ~= nil and t7.price ~= nil then t7.price else 0,
		product_id = if t7 ~= nil and t7.product_id ~= nil then t7.product_id else 0,
		is_owned = t7 ~= nil and (t7.is_owned ~= nil and t7.is_owned),
		display_icon_image_asset_id = if t7 ~= nil and t7.display_icon_image_asset_id ~= nil then t7.display_icon_image_asset_id else 0,
		display_description = if t7 ~= nil and t7.display_description ~= nil then t7.display_description else "",
		price_discount_details = if t7 ~= nil and t7.price_discount_details ~= nil then t7.price_discount_details else {},
		user_base_price_in_robux = if t7 ~= nil and t7.user_base_price_in_robux ~= nil then t7.user_base_price_in_robux else 0
	}, t6))
end
function t6.encode(p4) -- line: 242
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.id ~= nil and p4.id ~= "" then
		local v38, v39 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v38, v39, p4.id)
	end

	if p4.display_name ~= nil and p4.display_name ~= "" then
		local v40, v41 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v40, v41, p4.display_name)
	end

	if p4.price ~= nil and p4.price ~= 0 then
		local v42, v43 = proto.writeTag(buf, n3, 3, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v42, v43, p4.price)
	end

	if p4.product_id ~= nil and p4.product_id ~= 0 then
		local v44, v45 = proto.writeTag(buf, n3, 4, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v44, v45, p4.product_id)
	end

	if p4.is_owned then
		local v46, v47 = proto.writeTag(buf, n3, 5, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v46, v47, not p4.is_owned and 0 or 1)
	end

	if p4.display_icon_image_asset_id ~= nil and p4.display_icon_image_asset_id ~= 0 then
		local v48, v49 = proto.writeTag(buf, n3, 6, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v48, v49, p4.display_icon_image_asset_id)
	end

	if p4.display_description ~= nil and p4.display_description ~= "" then
		local v50, v51 = proto.writeTag(buf, n3, 7, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v50, v51, p4.display_description)
	end

	if p4.price_discount_details ~= nil and #p4.price_discount_details > 0 then
		for _, v53 in p4.price_discount_details do
			local v54 = v53:encode()
			local v55, v56 = proto.writeTag(buf, n3, 8, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v55, v56, v54, buffer.len(v54))
		end
	end

	if p4.user_base_price_in_robux ~= nil and p4.user_base_price_in_robux ~= 0 then
		local v57, v58 = proto.writeTag(buf, n3, 9, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v57, v58, p4.user_base_price_in_robux)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 299
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v61 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v63, v64

		v63, v64, n4 = proto.readTag(p5, n4)

		if v64 == proto.wireTypes.varint then
			if v63 == 3 then
				local v65

				v65, n4 = proto.readVarIntI64(p5, n4)
				v61.price = v65
			elseif v63 == 4 then
				local v66

				v66, n4 = proto.readVarIntI64(p5, n4)
				v61.product_id = v66
			elseif v63 == 5 then
				local v67

				v67, n4 = proto.readVarInt(p5, n4)
				v61.is_owned = v67 ~= 0
			elseif v63 == 6 then
				local v68

				v68, n4 = proto.readVarIntI64(p5, n4)
				v61.display_icon_image_asset_id = v68
			elseif v63 == 9 then
				local v69

				v69, n4 = proto.readVarIntI64(p5, n4)
				v61.user_base_price_in_robux = v69
			else
				local v70

				v70, n4 = proto.readVarInt(p5, n4)
			end
		elseif v64 == proto.wireTypes.lengthDelimited then
			if v63 == 1 then
				local v71

				v71, n4 = proto.readBuffer(p5, n4)
				v61.id = buffer.tostring(v71)
			elseif v63 == 2 then
				local v72

				v72, n4 = proto.readBuffer(p5, n4)
				v61.display_name = buffer.tostring(v72)
			elseif v63 == 7 then
				local v73

				v73, n4 = proto.readBuffer(p5, n4)
				v61.display_description = buffer.tostring(v73)
			elseif v63 == 8 then
				local v74

				v74, n4 = proto.readBuffer(p5, n4)
				table.insert(v61.price_discount_details, t1.PriceDiscountDetail.decode(v74))
			else
				local v75, v76 = proto.readVarInt(p5, n4)

				n4 = v76 + v75
			end
		elseif v64 == proto.wireTypes.i32 then
			local v77

			v77, n4 = proto.readFixed32(p5, n4)
		elseif v64 == proto.wireTypes.i64 then
			local v78

			v78, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v64)
		end
	end

	return v61
end
function t6.jsonEncode(p6) -- line: 382
	local t8 = {}

	if p6.id ~= nil and p6.id ~= "" then
		t8.id = p6.id
	end

	if p6.display_name ~= nil and p6.display_name ~= "" then
		t8.displayName = p6.display_name
	end

	if p6.price ~= nil and p6.price ~= 0 then
		t8.price = p6.price
	end

	if p6.product_id ~= nil and p6.product_id ~= 0 then
		t8.productId = p6.product_id
	end

	if p6.is_owned then
		t8.isOwned = p6.is_owned
	end

	if p6.display_icon_image_asset_id ~= nil and p6.display_icon_image_asset_id ~= 0 then
		t8.displayIconImageAssetId = p6.display_icon_image_asset_id
	end

	if p6.display_description ~= nil and p6.display_description ~= "" then
		t8.displayDescription = p6.display_description
	end

	if p6.price_discount_details ~= nil and #p6.price_discount_details > 0 then
		local t9 = {}

		for _, v83 in p6.price_discount_details do
			table.insert(t9, v83:jsonEncode())
		end

		t8.priceDiscountDetails = t9
	end

	if p6.user_base_price_in_robux ~= nil and p6.user_base_price_in_robux ~= 0 then
		t8.userBasePriceInRobux = p6.user_base_price_in_robux
	end

	return t8
end
function t6.jsonDecode(t10: {[any]: any}) -- line: 428
	-- upvalues: t6 (copy), t1 (copy)
	local v85 = t6.new()

	if t10.id ~= nil then
		v85.id = t10.id
	end

	if t10.display_name ~= nil then
		v85.display_name = t10.display_name
	end

	if t10.displayName ~= nil then
		v85.display_name = t10.displayName
	end

	if t10.price ~= nil then
		v85.price = t10.price
	end

	if t10.product_id ~= nil then
		v85.product_id = t10.product_id
	end

	if t10.productId ~= nil then
		v85.product_id = t10.productId
	end

	if t10.is_owned ~= nil then
		v85.is_owned = t10.is_owned
	end

	if t10.isOwned ~= nil then
		v85.is_owned = t10.isOwned
	end

	if t10.display_icon_image_asset_id ~= nil then
		v85.display_icon_image_asset_id = t10.display_icon_image_asset_id
	end

	if t10.displayIconImageAssetId ~= nil then
		v85.display_icon_image_asset_id = t10.displayIconImageAssetId
	end

	if t10.display_description ~= nil then
		v85.display_description = t10.display_description
	end

	if t10.displayDescription ~= nil then
		v85.display_description = t10.displayDescription
	end

	if t10.price_discount_details ~= nil then
		local t11 = {}

		for _, v88 in t10.price_discount_details do
			table.insert(t11, t1.PriceDiscountDetail.jsonDecode(v88))
		end

		v85.price_discount_details = t11
	end

	if t10.priceDiscountDetails ~= nil then
		local t12 = {}

		for _, v91 in t10.priceDiscountDetails do
			table.insert(t12, t1.PriceDiscountDetail.jsonDecode(v91))
		end

		v85.price_discount_details = t12
	end

	if t10.user_base_price_in_robux ~= nil then
		v85.user_base_price_in_robux = t10.user_base_price_in_robux
	end

	if t10.userBasePriceInRobux ~= nil then
		v85.user_base_price_in_robux = t10.userBasePriceInRobux
	end

	return v85
end

t6.descriptor = {
	name = "GamePassData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassData"
}
t1.GamePassData = t6
typeRegistry.default:register(t1.GamePassData)

return {
	PriceDiscountDetail = t1.PriceDiscountDetail,
	GamePassData = t1.GamePassData
}
