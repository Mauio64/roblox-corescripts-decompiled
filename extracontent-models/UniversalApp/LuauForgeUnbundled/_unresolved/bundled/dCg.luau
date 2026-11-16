local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dCh")
local module2 = require("@luauforge/bundled/dCi")
local module3 = require("@luauforge/bundled/dCj")

local function messagesAreEqual(data, data2): boolean
	return data.toastMessage == data2.toastMessage
		and data.toastSubMessage == data2.toastSubMessage
		and data.toastType == data2.toastType
		and data.universeId == data2.universeId
		and data.isLocalized == data2.isLocalized
end

local function messageIsAlreadyPresent(p2, joined): boolean
	local currentToastMessage = p2.currentToastMessage
	local v5

	if
		currentToastMessage.toastMessage == joined.toastMessage
		and currentToastMessage.toastSubMessage == joined.toastSubMessage
		and currentToastMessage.toastType == joined.toastType
		and currentToastMessage.universeId == joined.universeId
	then
		v5 = currentToastMessage.isLocalized == joined.isLocalized
	else
		v5 = false
	end

	if v5 then
		return true
	end

	for i, enqueuedToastMessage in ipairs(p2.enqueuedToastMessages) do
		local v6

		if
			enqueuedToastMessage.toastMessage == joined.toastMessage
			and enqueuedToastMessage.toastSubMessage == joined.toastSubMessage
			and enqueuedToastMessage.toastType == joined.toastType
			and enqueuedToastMessage.universeId == joined.universeId
		then
			v6 = enqueuedToastMessage.isLocalized == joined.isLocalized
		else
			v6 = false
		end

		if v6 then
			return true
		end
	end

	return false
end

local count = 0
return Rodux.createReducer({ enqueuedToastMessages = {}, currentToastMessage = nil }, {
	[module.name] = function(p2, p3)
		local v6 = { enqueuedToastMessages = {} }

		local joined = Cryo.Dictionary.join(p3.toastMessage, { sequenceNumber = count })
		count += 1

		if not p2.currentToastMessage then
			v6.currentToastMessage = joined
			return v6
		end

		if messageIsAlreadyPresent(p2, joined) then
			return p2
		end

		v6.currentToastMessage = p2.currentToastMessage

		v6.enqueuedToastMessages = Cryo.List.join(p2.enqueuedToastMessages, { joined })

		return v6
	end,
	[module2.name] = function(p2, p3)
		local v6 = { enqueuedToastMessages = {} }

		if #p2.enqueuedToastMessages > 0 then
			v6.currentToastMessage = p2.enqueuedToastMessages[1]
			v6.enqueuedToastMessages = Cryo.List.removeIndex(p2.enqueuedToastMessages, 1)
		end

		return v6
	end,
	[module3.name] = function(p2, p3)
		return { enqueuedToastMessages = {} }
	end
})
