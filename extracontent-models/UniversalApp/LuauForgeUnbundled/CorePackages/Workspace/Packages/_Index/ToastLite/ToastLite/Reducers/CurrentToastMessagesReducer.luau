local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/Rodux")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/ToastLite/ToastRodux")

local function messagesAreEqual(data, data2): boolean
	return data.toastTitle == data2.toastTitle
		and data.toastSubtitle == data2.toastSubtitle
		and data.toastType == data2.toastType
end

local function messageIsAlreadyPresent(list, data): boolean
	for i, item in ipairs(list) do
		local v5

		if item.toastTitle == data.toastTitle and item.toastSubtitle == data.toastSubtitle then
			v5 = item.toastType == data.toastType
		else
			v5 = false
		end

		if v5 then
			return true
		end
	end

	return false
end

local count = 0

return Rodux.createReducer({}, {
	[ToastRodux.Actions.SetCurrentToastMessage.name] = function(list, p2)
		local joined = Cryo.Dictionary.join(p2.toastMessage, {
			sequenceNumber = count
		})
		count += 1
		local flag = true
		local flag2

		for i, item in ipairs(list) do
			local v6

			if item.toastTitle == joined.toastTitle and item.toastSubtitle == joined.toastSubtitle then
				v6 = item.toastType == joined.toastType
			else
				v6 = false
			end

			if v6 then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			return list
		end

		return Cryo.List.join(list, { joined })
	end,
	[ToastRodux.Actions.RemoveCurrentToastMessage.name] = function(list, p2)
		if #list == 0 then
			return list
		end

		return Cryo.List.removeIndex(list, 1)
	end,
	[ToastRodux.Actions.RemoveAllToastMessages.name] = function(p2, p3)
		return {}
	end
})
