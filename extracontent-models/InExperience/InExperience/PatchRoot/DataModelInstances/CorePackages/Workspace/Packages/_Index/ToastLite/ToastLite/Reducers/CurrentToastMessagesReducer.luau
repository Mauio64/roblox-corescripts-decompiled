local parent = script:FindFirstAncestor("ToastLite").Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local ToastRodux = require(parent.ToastRodux)

local function messagesAreEqual(data, data2): boolean -- 1 equivalent call inferred from this helper
	return data.toastTitle == data2.toastTitle
		and data.toastSubtitle == data2.toastSubtitle
		and data.toastType == data2.toastType
end

local function messageIsAlreadyPresent(list, joined): boolean -- 1 equivalent call inferred from this helper
	for _, item in ipairs(list) do
		if messagesAreEqual(item, joined) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local count = 0

return Rodux.createReducer({}, {
	[ToastRodux.Actions.SetCurrentToastMessage.name] = function(list, p)
		local joined = Cryo.Dictionary.join(p.toastMessage, { sequenceNumber = count })
		count += 1

		if messageIsAlreadyPresent(list, joined) then -- inferred equivalent call
			return list
		end

		return Cryo.List.join(list, { joined })
	end,
	[ToastRodux.Actions.RemoveCurrentToastMessage.name] = function(list, _)
		if #list == 0 then
			return list
		end

		return Cryo.List.removeIndex(list, 1)
	end,
	[ToastRodux.Actions.RemoveAllToastMessages.name] = function(_, _)
		return {}
	end
})
