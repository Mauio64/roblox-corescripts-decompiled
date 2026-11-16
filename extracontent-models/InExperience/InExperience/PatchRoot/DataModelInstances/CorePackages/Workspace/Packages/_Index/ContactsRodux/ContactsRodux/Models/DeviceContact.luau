local parent = script.Parent.Parent.Parent
local getMockName = require(script.Parent.getMockName)
require(script.Parent.Parent.Types.ContactTypes)
local Dash = require(parent.Dash)

local DeviceContact = {}

function DeviceContact.new(data)
	DeviceContact.__index = DeviceContact

	local v = { id = data.id, phoneNumbers = data.phoneNumbers, contactName = data.contactName }

	setmetatable(v, DeviceContact)

	return v
end

function DeviceContact.mock(p)
	local mockName = getMockName()
	local joined = Dash.join({
		id = mockName,
		contactName = mockName,
		phoneNumbers = { "123456" }
	}, p)

	return DeviceContact.new(joined)
end

function DeviceContact.formatFromDevice(data)
	local firstname = data.firstname or ""
	local lastname = data.lastname or ""
	return DeviceContact.new({
		id = DeviceContact.generateId(data),
		contactName = firstname .. " " .. lastname,
		phoneNumbers = data.phonenumber
	})
end

function DeviceContact.generateId(data)
	return (data.firstname or "") .. (data.lastname or "") .. tostring(data.phonenumber[1])
end

return DeviceContact
