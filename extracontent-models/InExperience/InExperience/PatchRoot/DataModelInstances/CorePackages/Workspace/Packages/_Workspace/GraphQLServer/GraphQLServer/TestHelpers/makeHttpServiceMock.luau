local function makeHttpServiceMock(p, p2)
	return {
		RequestInternal = function(_)
			return {
				Start = function(_, callback)
					callback(p, p2)
				end
			}
		end
	}
end

return makeHttpServiceMock
