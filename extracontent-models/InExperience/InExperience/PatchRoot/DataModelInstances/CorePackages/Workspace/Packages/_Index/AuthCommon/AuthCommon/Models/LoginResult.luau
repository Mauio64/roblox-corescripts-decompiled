local Parent = script:FindFirstAncestor("AuthCommon").Parent
local ArgCheck = require(Parent.ArgCheck)
local t = require(Parent.t)
local FFlagEnableLuaAccountSwitch = require(Parent.SharedFlags).FFlagEnableLuaAccountSwitch
local t1 = {}
local t2 = {}

t1[t2] = true

local v7 = t.interface({
	user = t.interface({
		id = t.number,
		name = t.string
	}),
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

function t1.new(p1) -- line: 51
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), t1 (copy)
	local t3 = {
		user = {
			id = "0",
			name = ""
		}
	}

	if p1 and type(p1) == "table" then
		if p1.user then
			t3.user.id = tostring(p1.user.id) or t3.user.id
			t3.user.name = p1.user.name or t3.user.name
		end

		if p1.twoStepVerificationData then
			t3.twoStepVerificationData = {}
			t3.twoStepVerificationData.mediaType = p1.twoStepVerificationData.mediaType or ""
			t3.twoStepVerificationData.ticket = p1.twoStepVerificationData.ticket or ""
		end

		if FFlagEnableLuaAccountSwitch and p1.accountBlob then
			t3.accountBlob = p1.accountBlob
		end
	end

	setmetatable(t3, t1)

	return t3
end
function t1.mock() -- line: 79
	-- upvalues: t1 (copy)
	local v10 = t1.new()

	v10.user = {
		id = "1",
		name = "ROBLOX"
	}
	v10.twoStepVerificationData = {
		mediaType = "Email",
		ticket = "00000000-0000-0000-0000-000000000000"
	}

	return v10
end
function t1.fromJsonData(p2) -- line: 95
	-- upvalues: t1 (copy), v7 (copy), FFlagEnableLuaAccountSwitch (copy), ArgCheck (copy)
	local v12 = t1.new()
	local v13, v14 = v7(p2)

	if v13 then
		v12.user = {
			id = tostring(p2.user.id),
			name = p2.user.name
		}

		if p2.twoStepVerificationData then
			v12.twoStepVerificationData = {
				mediaType = p2.twoStepVerificationData.mediaType,
				ticket = p2.twoStepVerificationData.ticket
			}
		end

		if FFlagEnableLuaAccountSwitch and p2.accountBlob then
			v12.accountBlob = p2.accountBlob

			return v12
		end
	else
		ArgCheck.assert(false, v14)
	end

	return v12
end
function t1.is(p3) -- line: 126
	-- upvalues: t2 (copy)
	if type(p3) ~= "table" then
		return false
	end

	return p3[t2] == true
end
function t1.hasTwoStepData(p4) -- line: 134
	-- upvalues: t1 (copy)
	return t1.is(p4) and type(p4.twoStepVerificationData) == "table"
end

t1.__index = t1

return t1
