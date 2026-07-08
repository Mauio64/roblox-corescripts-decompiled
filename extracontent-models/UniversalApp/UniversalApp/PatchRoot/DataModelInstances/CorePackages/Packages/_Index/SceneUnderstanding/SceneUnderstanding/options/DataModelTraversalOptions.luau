local t1 = {
	instanceProcessingLimit = 1000
}

return {
	new = function(t2: {[any]: any}?) -- line: 24
		-- upvalues: t1 (copy)
		local v3 = table.clone(t1)

		if t2 then
			for v4, v5 in t2 do
				v3[v4] = v5
			end
		end

		return v3
	end
}
