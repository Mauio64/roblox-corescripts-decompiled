local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		transfer_request_id = (data == nil or data.transfer_request_id == nil) and "" or data.transfer_request_id,
		net_transfer_robux_amount = (data == nil or data.net_transfer_robux_amount == nil) and 0 or data.net_transfer_robux_amount,
		created_timestamp_ms = (data == nil or data.created_timestamp_ms == nil) and 0 or data.created_timestamp_ms,
		sender = 0
	}
	local sender

	if not (data == nil or data.sender == nil) then
		sender = data.sender
	end

	v2.sender = sender
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.transfer_request_id ~= nil and self.transfer_request_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.transfer_request_id)
	end

	if self.net_transfer_robux_amount ~= nil and self.net_transfer_robux_amount ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.net_transfer_robux_amount)
	end

	if self.created_timestamp_ms ~= nil and self.created_timestamp_ms ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.created_timestamp_ms)
	end

	if self.sender ~= nil then
		local encoded = self.sender:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			if v3 == 2 then
				local net_transfer_robux_amount
				net_transfer_robux_amount, v2 = proto.readVarIntI64(buf, v2)
				result.net_transfer_robux_amount = net_transfer_robux_amount
			elseif v3 == 3 then
				local created_timestamp_ms
				created_timestamp_ms, v2 = proto.readVarIntI64(buf, v2)
				result.created_timestamp_ms = created_timestamp_ms
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.transfer_request_id = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.sender = v.BuyRobuxTransferSenderData.decode(v5)
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

	if self.transfer_request_id ~= nil and self.transfer_request_id ~= "" then
		v2.transferRequestId = self.transfer_request_id
	end

	if self.net_transfer_robux_amount ~= nil and self.net_transfer_robux_amount ~= 0 then
		v2.netTransferRobuxAmount = self.net_transfer_robux_amount
	end

	if self.created_timestamp_ms ~= nil and self.created_timestamp_ms ~= 0 then
		v2.createdTimestampMs = self.created_timestamp_ms
	end

	if self.sender ~= nil then
		v2.sender = self.sender:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.transfer_request_id ~= nil then
		v2.transfer_request_id = data.transfer_request_id
	end

	if data.transferRequestId ~= nil then
		v2.transfer_request_id = data.transferRequestId
	end

	if data.net_transfer_robux_amount ~= nil then
		v2.net_transfer_robux_amount = data.net_transfer_robux_amount
	end

	if data.netTransferRobuxAmount ~= nil then
		v2.net_transfer_robux_amount = data.netTransferRobuxAmount
	end

	if data.created_timestamp_ms ~= nil then
		v2.created_timestamp_ms = data.created_timestamp_ms
	end

	if data.createdTimestampMs ~= nil then
		v2.created_timestamp_ms = data.createdTimestampMs
	end

	if data.sender ~= nil then
		v2.sender = v.BuyRobuxTransferSenderData.jsonDecode(data.sender)
	end

	return v2
end

class.descriptor = {
	name = "BuyRobuxPendingTransferData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxPendingTransferData"
}

v.BuyRobuxPendingTransferData = class

typeRegistry.default:register(v.BuyRobuxPendingTransferData)

local class2 = {}
class2.__index = class2

function class2.new(data)
	return (setmetatable({
		user_id = (data == nil or data.user_id == nil) and "" or data.user_id,
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		thumbnail_url = (data == nil or data.thumbnail_url == nil) and "" or data.thumbnail_url
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.user_id ~= nil and self.user_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.user_id)
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.thumbnail_url ~= nil and self.thumbnail_url ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.thumbnail_url)
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
				result.user_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.thumbnail_url = buffer.tostring(v5)
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

	if self.user_id ~= nil and self.user_id ~= "" then
		v2.userId = self.user_id
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.thumbnail_url ~= nil and self.thumbnail_url ~= "" then
		v2.thumbnailUrl = self.thumbnail_url
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.user_id ~= nil then
		v2.user_id = data.user_id
	end

	if data.userId ~= nil then
		v2.user_id = data.userId
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.thumbnail_url ~= nil then
		v2.thumbnail_url = data.thumbnail_url
	end

	if data.thumbnailUrl ~= nil then
		v2.thumbnail_url = data.thumbnailUrl
	end

	return v2
end

class2.descriptor = {
	name = "BuyRobuxTransferSenderData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxTransferSenderData"
}

v.BuyRobuxTransferSenderData = class2

typeRegistry.default:register(v.BuyRobuxTransferSenderData)

return {
	BuyRobuxPendingTransferData = v.BuyRobuxPendingTransferData,
	BuyRobuxTransferSenderData = v.BuyRobuxTransferSenderData
}
