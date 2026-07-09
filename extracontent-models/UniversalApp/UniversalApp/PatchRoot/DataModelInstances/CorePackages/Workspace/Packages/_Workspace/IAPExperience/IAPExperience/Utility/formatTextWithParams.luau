local function formatTextWithParams(s1: string, t1: {[any]: any}) -- line: 1
	if t1 ~= nil then
		for k, v in pairs(t1) do
			local v6 = ("{%s}"):format(k)

			s1 = string.gsub(s1, v6, function() -- line: 5
				-- upvalues: v (copy)
				return v
			end)
		end
	end

	return s1
end

return formatTextWithParams
