local function signalWith(data, p2, p3)
	data.defer(function()
		if not data.isEnabled() then
			return
		end

		local success, result = pcall(data.getService)

		if not success or result == nil then
			return
		end

		local enumItem = data.resolveEnumItem("PageType", p2)
		local enumItem2 = data.resolveEnumItem("PageMilestoneType", p3)

		if enumItem == nil or enumItem2 == nil then
			data.warn(`PageGate.signal: no enum for page "{p2}" / milestone "{p3}"`)
		else
			result:TriggerOnPageMilestone(enumItem, enumItem2)
		end
	end)
end

return signalWith
