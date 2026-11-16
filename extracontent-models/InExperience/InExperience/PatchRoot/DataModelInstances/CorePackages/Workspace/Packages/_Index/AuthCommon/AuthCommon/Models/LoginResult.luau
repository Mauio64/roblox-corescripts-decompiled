local parent = script:FindFirstAncestor("AuthCommon").Parent

local ArgCheck = require(parent.ArgCheck)
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch

local LoginResult = {}
local v = {}
LoginResult[v] = true

local interface = t.interface({
	user = t.interface({ id = t.number, name = t.string }),
	twoStepVerificationData = t.optional(t.interface({ mediaType = t.string, ticket = t.string })),
	twoStepVerificationDataV2 = t.optional(t.interface({ mediaType = t.string, ticket = t.string })),
	accountBlob = t.optional(t.string)
})

function LoginResult.new(data)
	local v2 = {
		user = { id = "0", name = "" }
	}

	if data and type(data) == "table" then
		if data.user then
			v2.user.id = tostring(data.user.id) or v2.user.id
			v2.user.name = data.user.name or v2.user.name
		end

		if data.twoStepVerificationData then
			v2.twoStepVerificationData = {}
			v2.twoStepVerificationData.mediaType = data.twoStepVerificationData.mediaType or ""
			v2.twoStepVerificationData.ticket = data.twoStepVerificationData.ticket or ""
		end

		if FFlagEnableLuaAccountSwitch and data.accountBlob then
			v2.accountBlob = data.accountBlob
		end
	end

	setmetatable(v2, LoginResult)
	return v2
end

function LoginResult.mock()
	local v2 = LoginResult.new()

	v2.user = { id = "1", name = "ROBLOX" }

	v2.twoStepVerificationData = {
		mediaType = "Email",
		ticket = "00000000-0000-0000-0000-000000000000"
	}

	return v2
end

function LoginResult.fromJsonData(data)
	local v2 = LoginResult.new()

	local v3, v4 = interface(data)

	if v3 then
		v2.user = { id = tostring(data.user.id), name = data.user.name }

		if data.twoStepVerificationData then
			v2.twoStepVerificationData = {
				mediaType = data.twoStepVerificationData.mediaType,
				ticket = data.twoStepVerificationData.ticket
			}
		end

		if FFlagEnableLuaAccountSwitch and data.accountBlob then
			v2.accountBlob = data.accountBlob
			return v2
		end
	else
		ArgCheck.assert(false, v4)
	end

	return v2
end

function LoginResult.is(p): boolean
	return type(p) == "table" and p[v] == true
end

function LoginResult.hasTwoStepData(p)
	return LoginResult.is(p) and type(p.twoStepVerificationData) == "table"
end

LoginResult.__index = LoginResult

return LoginResult
