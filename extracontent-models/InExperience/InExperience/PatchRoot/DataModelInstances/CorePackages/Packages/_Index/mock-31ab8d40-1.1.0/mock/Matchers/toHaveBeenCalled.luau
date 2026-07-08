local ParentParent = script.Parent.Parent
local MagicMock = require(ParentParent.MagicMock)
local Spy = require(ParentParent.Spy)
local getCalls = require(ParentParent.getCalls)

return function(p1, p2) -- line: 6
	-- upvalues: MagicMock (copy), Spy (copy), getCalls (copy)
	if not MagicMock.is(p1) and not Spy.is(p1) then
		return {
			pass = false,
			message = string.format("expect(mock) must be a MagicMock or Spy when .toHaveBeenCalled is used. Given %s instead", (tostring(p1)))
		}
	end

	local v7 = #getCalls(p1)
	local v8, v9

	if p2 then
		if not (type(p2) == "number" and (p2 > 0 and p2 % 1 == 0)) then
			return {
				pass = false,
				message = string.format("expectedTimesCalled must be a positive integer. Given %s instead.", (tostring(p2)))
			}
		end

		v8 = p2 == v7
		v9 = v8 and string.format("Expected %s to not have been called exactly %d times.", tostring(p1), p2) or string.format("Expected %s to have been called %d times. Was called %d times instead.", tostring(p1), p2, v7)
	else
		v8 = v7 > 0
		v9 = v8 and string.format("Expected %s to never have been called. Was called %d times instead.", tostring(p1), v7) or string.format("Expected %s to have been called at least once.", (tostring(p1)))
	end

	return {
		pass = v8,
		message = v9
	}
end
