local v5 = { "<system_reminder>.-</system_reminder>" }

return {
	shouldOptimisticallyDisplay = function(value): boolean
		for k, v6 in v5 do
			if string.find(value, v6) ~= nil then
				return false
			end
		end

		return true
	end
}
