local DataSources = {
	array = function(array)
		return { type = "array", array = array }
	end,
	mutableSource = function(methods)
		return { type = "mutableSource", methods = methods }
	end,
	utilities = {}
}

function DataSources.utilities.createGetSimpleCursor(callback, callback2)
	return function(p: number)
		local v = callback2()
		local function getWithCursor(p2: number)
			if p2 < 1 or v < p2 then
				return nil
			end

			return {
				before = function()
					return getWithCursor(p2 - 1)
				end,
				value = callback(p2),
				after = function()
					return getWithCursor(p2 + 1)
				end
			}
		end

		return (getWithCursor(p))
	end
end

return DataSources
