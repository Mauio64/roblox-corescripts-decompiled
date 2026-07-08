local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 54
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		name = if t3 ~= nil and t3.name ~= nil then t3.name else "",
		description = if t3 ~= nil and t3.description ~= nil then t3.description else "",
		image_asset_id = if t3 ~= nil and t3.image_asset_id ~= nil then t3.image_asset_id else 0,
		price_in_robux = if t3 ~= nil and t3.price_in_robux ~= nil then t3.price_in_robux else 0,
		pending_receipt_count = if t3 ~= nil and t3.pending_receipt_count ~= nil then t3.pending_receipt_count else 0,
		status_tooltip = if t3 ~= nil and t3.status_tooltip ~= nil then t3.status_tooltip else ""
	}, t2))
end
function t2.encode(p1) -- line: 68
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	if p1.name ~= nil and p1.name ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.name)
	end

	if p1.description ~= nil and p1.description ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.description)
	end

	if p1.image_asset_id ~= nil and p1.image_asset_id ~= 0 then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, p1.image_asset_id)
	end

	if p1.price_in_robux ~= nil and p1.price_in_robux ~= 0 then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v17, v18, p1.price_in_robux)
	end

	if p1.pending_receipt_count ~= nil and p1.pending_receipt_count ~= 0 then
		local v19, v20 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, p1.pending_receipt_count)
	end

	if p1.status_tooltip ~= nil and p1.status_tooltip ~= "" then
		local v21, v22 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v21, v22, p1.status_tooltip)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 112
	-- upvalues: t2 (copy), proto (copy)
	local v25 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v27, v28

		v27, v28, n2 = proto.readTag(p2, n2)

		if v28 == proto.wireTypes.varint then
			if v27 == 4 then
				local v29

				v29, n2 = proto.readVarIntI64(p2, n2)
				v25.image_asset_id = v29
			elseif v27 == 5 then
				local v30

				v30, n2 = proto.readVarIntI64(p2, n2)
				v25.price_in_robux = v30
			elseif v27 == 6 then
				local v31

				v31, n2 = proto.readVarIntI32(p2, n2)
				v25.pending_receipt_count = v31
			else
				local v32

				v32, n2 = proto.readVarInt(p2, n2)
			end
		elseif v28 == proto.wireTypes.lengthDelimited then
			if v27 == 1 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)
				v25.id = buffer.tostring(v33)
			elseif v27 == 2 then
				local v34

				v34, n2 = proto.readBuffer(p2, n2)
				v25.name = buffer.tostring(v34)
			elseif v27 == 3 then
				local v35

				v35, n2 = proto.readBuffer(p2, n2)
				v25.description = buffer.tostring(v35)
			elseif v27 == 7 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				v25.status_tooltip = buffer.tostring(v36)
			else
				local v37, v38 = proto.readVarInt(p2, n2)

				n2 = v38 + v37
			end
		elseif v28 == proto.wireTypes.i32 then
			local v39

			v39, n2 = proto.readFixed32(p2, n2)
		elseif v28 == proto.wireTypes.i64 then
			local v40

			v40, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v28)
		end
	end

	return v25
end
function t2.jsonEncode(p3) -- line: 185
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.name ~= nil and p3.name ~= "" then
		t4.name = p3.name
	end

	if p3.description ~= nil and p3.description ~= "" then
		t4.description = p3.description
	end

	if p3.image_asset_id ~= nil and p3.image_asset_id ~= 0 then
		t4.imageAssetId = p3.image_asset_id
	end

	if p3.price_in_robux ~= nil and p3.price_in_robux ~= 0 then
		t4.priceInRobux = p3.price_in_robux
	end

	if p3.pending_receipt_count ~= nil and p3.pending_receipt_count ~= 0 then
		t4.pendingReceiptCount = p3.pending_receipt_count
	end

	if p3.status_tooltip ~= nil and p3.status_tooltip ~= "" then
		t4.statusTooltip = p3.status_tooltip
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 219
	-- upvalues: t2 (copy)
	local v44 = t2.new()

	if t5.id ~= nil then
		v44.id = t5.id
	end

	if t5.name ~= nil then
		v44.name = t5.name
	end

	if t5.description ~= nil then
		v44.description = t5.description
	end

	if t5.image_asset_id ~= nil then
		v44.image_asset_id = t5.image_asset_id
	end

	if t5.imageAssetId ~= nil then
		v44.image_asset_id = t5.imageAssetId
	end

	if t5.price_in_robux ~= nil then
		v44.price_in_robux = t5.price_in_robux
	end

	if t5.priceInRobux ~= nil then
		v44.price_in_robux = t5.priceInRobux
	end

	if t5.pending_receipt_count ~= nil then
		v44.pending_receipt_count = t5.pending_receipt_count
	end

	if t5.pendingReceiptCount ~= nil then
		v44.pending_receipt_count = t5.pendingReceiptCount
	end

	if t5.status_tooltip ~= nil then
		v44.status_tooltip = t5.status_tooltip
	end

	if t5.statusTooltip ~= nil then
		v44.status_tooltip = t5.statusTooltip
	end

	return v44
end

t2.descriptor = {
	name = "GameDeveloperProductData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameDeveloperProductData"
}
t1.GameDeveloperProductData = t2
typeRegistry.default:register(t1.GameDeveloperProductData)

return {
	GameDeveloperProductData = t1.GameDeveloperProductData
}
