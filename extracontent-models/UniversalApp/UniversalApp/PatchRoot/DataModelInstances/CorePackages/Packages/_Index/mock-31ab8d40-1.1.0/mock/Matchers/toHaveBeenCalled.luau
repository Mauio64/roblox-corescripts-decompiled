local parent = script.Parent.Parent
local MagicMock = require(parent.MagicMock)
local Spy = require(parent.Spy)
local getCalls = require(parent.getCalls)

return function(p, value)
	if not (MagicMock.is(p) or Spy.is(p)) then
		return {
			pass = false,
			message = string.format(
				"expect(mock) must be a MagicMock or Spy when .toHaveBeenCalled is used. Given %s instead",
				(tostring(p))
			)
		}
	end

	local count = #getCalls(p)
	local pass, message

	if value then
		local v

		if type(value) == "number" and value > 0 then
			v = value % 1 == 0
		else
			v = false
		end

		if not v then
			return {
				pass = false,
				message = string.format(
					"expectedTimesCalled must be a positive integer. Given %s instead.",
					(tostring(value))
				)
			}
		end

		pass = value == count
		message = pass and string.format("Expected %s to not have been called exactly %d times.", tostring(p), value)
			or string.format(
				"Expected %s to have been called %d times. Was called %d times instead.",
				tostring(p),
				value,
				count
			)

		return { pass = pass, message = message }
	end

	pass = count > 0
	message = pass
		and string.format("Expected %s to never have been called. Was called %d times instead.", tostring(p), count)
		or string.format("Expected %s to have been called at least once.", (tostring(p)))

	return { pass = pass, message = message }
end
