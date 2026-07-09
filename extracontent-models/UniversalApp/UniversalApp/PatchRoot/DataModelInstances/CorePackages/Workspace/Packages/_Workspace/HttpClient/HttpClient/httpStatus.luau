return {
	isSuccess = function(n1: number) -- line: 4
		if n1 == 304 then
			return true
		end

		return n1 >= 200 and n1 < 300
	end
}
