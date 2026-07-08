local ParentParent = script.Parent.Parent.Parent
local getMockName = require(script.Parent.getMockName)

require(script.Parent.Parent.Types.ContactTypes)

local Dash = require(ParentParent.Dash)
local t1 = {}

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	t1.__index = t1

	local t2 = {
		id = p1.id,
		phoneNumbers = p1.phoneNumbers,
		contactName = p1.contactName
	}

	setmetatable(t2, t1)

	return t2
end
function t1.mock(t3: {[any]: any}?) -- line: 23
	-- upvalues: getMockName (copy), Dash (copy), t1 (copy)
	local v8 = getMockName()
	local t4 = {
		id = v8,
		contactName = v8,
		phoneNumbers = { "123456" }
	}
	local v10 = Dash.join(t4, t3)

	return t1.new(v10)
end
function t1.formatFromDevice(t5: {[any]: any}) -- line: 39
	-- upvalues: t1 (copy)
	local v12 = t5.firstname or ""
	local v13 = t5.lastname or ""

	return t1.new({
		id = t1.generateId(t5),
		contactName = v12 .. " " .. v13,
		phoneNumbers = t5.phonenumber
	})
end
function t1.generateId(t6: {[any]: any}) -- line: 49
	return (t6.firstname or "") .. (t6.lastname or "") .. tostring(t6.phonenumber[1])
end

return t1
