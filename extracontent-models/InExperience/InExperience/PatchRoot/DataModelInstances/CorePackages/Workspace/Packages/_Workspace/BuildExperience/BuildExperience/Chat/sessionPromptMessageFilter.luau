local v = { "<system_reminder>.-</system_reminder>" }

return {
	shouldOptimisticallyDisplay = function(value: string): boolean
		for _, v2 in v do
			if string.find(value, v2) ~= nil then
				return false
			end
		end

		return true
	end
}
