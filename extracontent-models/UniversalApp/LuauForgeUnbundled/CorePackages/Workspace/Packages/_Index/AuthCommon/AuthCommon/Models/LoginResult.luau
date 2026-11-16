local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/t")

local fFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLuaAccountSwitch

local class = {}
local v5 = {}
class[v5] = true

local interface = t.interface({
	user = t.interface({ id = t.number, name = t.string }),
	twoStepVerificationData = t.optional(t.interface({
		mediaType = t.string,
		ticket = t.string
	})),
	twoStepVerificationDataV2 = t.optional(t.interface({
		mediaType = t.string,
		ticket = t.string
	})),
	accountBlob = t.optional(t.string)
})

function class.new(data)
	local v6 = {
		user = { id = "0", name = "" }
	}

	if data and type(data) == "table" then
		if data.user then
			v6.user.id = tostring(data.user.id) or v6.user.id
			v6.user.name = data.user.name or v6.user.name
		end

		if data.twoStepVerificationData then
			v6.twoStepVerificationData = {}
			v6.twoStepVerificationData.mediaType = data.twoStepVerificationData.mediaType or ""
			v6.twoStepVerificationData.ticket = data.twoStepVerificationData.ticket or ""
		end

		if fFlagEnableLuaAccountSwitch and data.accountBlob then
			v6.accountBlob = data.accountBlob
		end
	end

	setmetatable(v6, class)
	return v6
end

function class.mock()
	local v6 = class.new()

	v6.user = { id = "1", name = "ROBLOX" }

	v6.twoStepVerificationData = {
		mediaType = "Email",
		ticket = "00000000-0000-0000-0000-000000000000"
	}

	return v6
end

function class.fromJsonData(data)
	local v6 = class.new()

	local v7, v8 = interface(data)

	if v7 then
		v6.user = { id = tostring(data.user.id), name = data.user.name }

		if data.twoStepVerificationData then
			v6.twoStepVerificationData = {
				mediaType = data.twoStepVerificationData.mediaType,
				ticket = data.twoStepVerificationData.ticket
			}
		end

		if fFlagEnableLuaAccountSwitch and data.accountBlob then
			v6.accountBlob = data.accountBlob
			return v6
		end
	else
		ArgCheck.assert(false, v8)
	end

	return v6
end

function class.is(p2): boolean
	if type(p2) == "table" then
		return p2[v5] == true
	end

	return false
end

function class.hasTwoStepData(p2)
	return class.is(p2) and type(p2.twoStepVerificationData) == "table"
end

class.__index = class

return class
