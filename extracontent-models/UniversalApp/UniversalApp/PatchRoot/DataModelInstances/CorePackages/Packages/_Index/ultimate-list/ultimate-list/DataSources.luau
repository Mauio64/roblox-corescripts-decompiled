local t3 = {
	array = function(t1: {[any]: any}) -- line: 40
		return {
			type = "array",
			array = t1
		}
	end,
	mutableSource = function(t2: {[any]: any}) -- line: 47
		return {
			type = "mutableSource",
			methods = t2
		}
	end,
	utilities = {}
}

function t3.utilities.createGetSimpleCursor(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 58
	return function(n1: number) -- line: 63
		-- upvalues: p2 (copy), p1 (copy)
		local v7 = p2()

		local function getWithCursor(n2: number) -- line: 66
			-- upvalues: v7 (copy), getWithCursor (copy), p1 (copy)
			if n2 < 1 or n2 > v7 then
				return nil
			end

			return {
				before = function() -- line: 72
					-- upvalues: getWithCursor (copy), n2 (copy)
					return getWithCursor(n2 - 1)
				end,
				value = p1(n2),
				after = function() -- line: 78
					-- upvalues: getWithCursor (copy), n2 (copy)
					return getWithCursor(n2 + 1)
				end
			}
		end

		return (getWithCursor(n1))
	end
end

return t3
