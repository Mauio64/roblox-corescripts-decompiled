local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local RemoveCurrentToastMessage = require(Modules.LuaApp.Actions.RemoveCurrentToastMessage)
local RemoveAllToastMessages = require(Modules.LuaApp.Actions.RemoveAllToastMessages)
local t1 = {
	currentToastMessage = nil,
	enqueuedToastMessages = {}
}

local function messagesAreEqual(p1, p2) -- line: 24
	return p1.toastMessage == p2.toastMessage and (p1.toastSubMessage == p2.toastSubMessage and (p1.toastType == p2.toastType and (p1.universeId == p2.universeId and p1.isLocalized == p2.isLocalized)))
end
local function messageIsAlreadyPresent(p3, p4) -- line: 35
	local currentToastMessage = p3.currentToastMessage

	if currentToastMessage.toastMessage == p4.toastMessage and (currentToastMessage.toastSubMessage == p4.toastSubMessage and (currentToastMessage.toastType == p4.toastType and (currentToastMessage.universeId == p4.universeId and currentToastMessage.isLocalized == p4.isLocalized))) then
		return true
	end

	for _, v in ipairs(p3.enqueuedToastMessages) do
		if v.toastMessage == p4.toastMessage and (v.toastSubMessage == p4.toastSubMessage and (v.toastType == p4.toastType and (v.universeId == p4.universeId and v.isLocalized == p4.isLocalized))) then
			return true
		end
	end

	return false
end

local n1 = 0

return Rodux.createReducer(t1, {
	[SetCurrentToastMessage.name] = function(p5, p6) -- line: 58
		-- upvalues: Cryo (copy), n1 (ref), messageIsAlreadyPresent (copy)
		local t2 = {
			enqueuedToastMessages = {}
		}
		local v22 = Cryo.Dictionary.join(p6.toastMessage, {
			sequenceNumber = n1
		})

		n1 += 1

		if not p5.currentToastMessage then
			t2.currentToastMessage = v22

			return t2
		end

		if messageIsAlreadyPresent(p5, v22) then
			return p5
		end

		t2.currentToastMessage = p5.currentToastMessage
		t2.enqueuedToastMessages = Cryo.List.join(p5.enqueuedToastMessages, { v22 })

		return t2
	end,
	[RemoveCurrentToastMessage.name] = function(p7, _) -- line: 87
		-- upvalues: Cryo (copy)
		local t3 = {
			enqueuedToastMessages = {}
		}

		if #p7.enqueuedToastMessages > 0 then
			t3.currentToastMessage = p7.enqueuedToastMessages[1]
			t3.enqueuedToastMessages = Cryo.List.removeIndex(p7.enqueuedToastMessages, 1)
		end

		return t3
	end,
	[RemoveAllToastMessages.name] = function(_, _) -- line: 101
		return {
			enqueuedToastMessages = {}
		}
	end
})
