local Parent = script:FindFirstAncestor("ToastLite").Parent
local Cryo = require(Parent.Cryo)
local Rodux = require(Parent.Rodux)
local ToastRodux = require(Parent.ToastRodux)

local function messagesAreEqual(p1, p2) -- line: 8
	return p1.toastTitle == p2.toastTitle and (p1.toastSubtitle == p2.toastSubtitle and p1.toastType == p2.toastType)
end
local function messageIsAlreadyPresent(p3, p4) -- line: 14
	for _, v in ipairs(p3) do
		if v.toastTitle == p4.toastTitle and (v.toastSubtitle == p4.toastSubtitle and v.toastType == p4.toastType) then
			return true
		end
	end

	return false
end

local n1 = 0

return Rodux.createReducer({}, {
	[ToastRodux.Actions.SetCurrentToastMessage.name] = function(p5, p6) -- line: 26
		-- upvalues: Cryo (copy), n1 (ref)
		local v16 = Cryo.Dictionary.join(p6.toastMessage, {
			sequenceNumber = n1
		})

		n1 += 1

		local g20 = nil
		local v19 = nil

		for _, v in ipairs(p5) do
			if v.toastTitle == v16.toastTitle and (v.toastSubtitle == v16.toastSubtitle and v.toastType == v16.toastType) then
				v19 = true
				g20 = true
			end

			if g20 then
				break
			end
		end

		if not g20 then
			v19 = false
		end

		g20 = false

		if v19 then
			return p5
		end

		return Cryo.List.join(p5, { v16 })
	end,
	[ToastRodux.Actions.RemoveCurrentToastMessage.name] = function(p7, _) -- line: 39
		-- upvalues: Cryo (copy)
		if #p7 == 0 then
			return p7
		end

		return Cryo.List.removeIndex(p7, 1)
	end,
	[ToastRodux.Actions.RemoveAllToastMessages.name] = function(_, _) -- line: 46
		return {}
	end
})
