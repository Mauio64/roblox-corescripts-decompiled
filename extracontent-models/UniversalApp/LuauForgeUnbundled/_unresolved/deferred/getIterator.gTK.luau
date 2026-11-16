local function getIterator(p2)
	local v5 = 1

	return {
		getNext = function()
			local nextNode = p2[v5]
			v5 += 1
			return nextNode
		end
	}
end

return getIterator
