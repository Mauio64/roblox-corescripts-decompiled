local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 52
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		name = if t3 ~= nil and t3.name ~= nil then t3.name else "",
		creator_name = if t3 ~= nil and t3.creator_name ~= nil then t3.creator_name else "",
		creator_has_verified_badge = t3 ~= nil and (t3.creator_has_verified_badge ~= nil and t3.creator_has_verified_badge),
		asset_type = if t3 ~= nil and t3.asset_type ~= nil then t3.asset_type else "",
		price = if t3 ~= nil and t3.price ~= nil then t3.price else 0
	}, t2))
end
function t2.encode(p1) -- line: 65
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

	if p1.creator_name ~= nil and p1.creator_name ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.creator_name)
	end

	if p1.creator_has_verified_badge then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, not p1.creator_has_verified_badge and 0 or 1)
	end

	if p1.asset_type ~= nil and p1.asset_type ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.asset_type)
	end

	if p1.price ~= nil and p1.price ~= 0 then
		local v19, v20 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, p1.price)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 104
	-- upvalues: t2 (copy), proto (copy)
	local v23 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v25, v26

		v25, v26, n2 = proto.readTag(p2, n2)

		if v26 == proto.wireTypes.varint then
			if v25 == 4 then
				local v27

				v27, n2 = proto.readVarInt(p2, n2)
				v23.creator_has_verified_badge = v27 ~= 0
			elseif v25 == 6 then
				local v28

				v28, n2 = proto.readVarIntI64(p2, n2)
				v23.price = v28
			else
				local v29

				v29, n2 = proto.readVarInt(p2, n2)
			end
		elseif v26 == proto.wireTypes.lengthDelimited then
			if v25 == 1 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v23.id = buffer.tostring(v30)
			elseif v25 == 2 then
				local v31

				v31, n2 = proto.readBuffer(p2, n2)
				v23.name = buffer.tostring(v31)
			elseif v25 == 3 then
				local v32

				v32, n2 = proto.readBuffer(p2, n2)
				v23.creator_name = buffer.tostring(v32)
			elseif v25 == 5 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)
				v23.asset_type = buffer.tostring(v33)
			else
				local v34, v35 = proto.readVarInt(p2, n2)

				n2 = v35 + v34
			end
		elseif v26 == proto.wireTypes.i32 then
			local v36

			v36, n2 = proto.readFixed32(p2, n2)
		elseif v26 == proto.wireTypes.i64 then
			local v37

			v37, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v26)
		end
	end

	return v23
end
function t2.jsonEncode(p3) -- line: 172
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.name ~= nil and p3.name ~= "" then
		t4.name = p3.name
	end

	if p3.creator_name ~= nil and p3.creator_name ~= "" then
		t4.creatorName = p3.creator_name
	end

	if p3.creator_has_verified_badge then
		t4.creatorHasVerifiedBadge = p3.creator_has_verified_badge
	end

	if p3.asset_type ~= nil and p3.asset_type ~= "" then
		t4.assetType = p3.asset_type
	end

	if p3.price ~= nil and p3.price ~= 0 then
		t4.price = p3.price
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 202
	-- upvalues: t2 (copy)
	local v41 = t2.new()

	if t5.id ~= nil then
		v41.id = t5.id
	end

	if t5.name ~= nil then
		v41.name = t5.name
	end

	if t5.creator_name ~= nil then
		v41.creator_name = t5.creator_name
	end

	if t5.creatorName ~= nil then
		v41.creator_name = t5.creatorName
	end

	if t5.creator_has_verified_badge ~= nil then
		v41.creator_has_verified_badge = t5.creator_has_verified_badge
	end

	if t5.creatorHasVerifiedBadge ~= nil then
		v41.creator_has_verified_badge = t5.creatorHasVerifiedBadge
	end

	if t5.asset_type ~= nil then
		v41.asset_type = t5.asset_type
	end

	if t5.assetType ~= nil then
		v41.asset_type = t5.assetType
	end

	if t5.price ~= nil then
		v41.price = t5.price
	end

	return v41
end

t2.descriptor = {
	name = "MarketplaceAssetData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceAssetData"
}
t1.MarketplaceAssetData = t2
typeRegistry.default:register(t1.MarketplaceAssetData)

return {
	MarketplaceAssetData = t1.MarketplaceAssetData
}
