local getMockName = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Models/getMockName")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ContactTypes")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")

local class = {}

function class.new(data)
	class.__index = class

	local v5 = {
		id = data.id,
		phoneNumbers = data.phoneNumbers,
		contactName = data.contactName
	}

	setmetatable(v5, class)

	return v5
end

function class.mock(p2)
	local v5 = getMockName()
	local joined = Dash.join({
		id = v5,
		contactName = v5,
		phoneNumbers = { "123456" }
	}, p2)

	return class.new(joined)
end

function class.formatFromDevice(data)
	local firstname = data.firstname or ""
	local lastname = data.lastname or ""
	return class.new({
		id = class.generateId(data),
		contactName = firstname .. " " .. lastname,
		phoneNumbers = data.phonenumber
	})
end

function class.generateId(data)
	return (data.firstname or "") .. (data.lastname or "") .. tostring(data.phonenumber[1])
end

return class
