local function signalWith(data, p: string, p2: string)
	data.defer(function()
		if not data.isEnabled() then
			return
		end

		local success, result = pcall(data.getService)

		if not success or result == nil then
			return
		end

		local enumItem = data.resolveEnumItem("PageType", p)
		local enumItem2 = data.resolveEnumItem("PageMilestoneType", p2)

		if enumItem == nil or enumItem2 == nil then
			data.warn(`PageGate.signal: no enum for page "{p}" / milestone "{p2}"`)
		else
			result:TriggerOnPageMilestone(enumItem, enumItem2)
		end
	end)
end

return signalWith
