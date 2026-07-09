local function getIterator(t1: {[any]: any}) -- line: 5
	local n1 = 1

	return {
		getNext = function() -- line: 8
			-- upvalues: t1 (copy), n1 (ref)
			local v4 = t1[n1]

			n1 += 1

			return v4
		end
	}
end

return getIterator
