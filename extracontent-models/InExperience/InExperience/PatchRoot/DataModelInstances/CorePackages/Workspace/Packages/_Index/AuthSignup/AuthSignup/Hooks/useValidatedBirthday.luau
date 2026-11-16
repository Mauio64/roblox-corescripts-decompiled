local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local React = require(parent.React)
local buildValidatedBirthday = require(AuthSignup.Util.buildValidatedBirthday)

local function isSameDate(current, validatedBirthday): boolean -- 1 equivalent call inferred from this helper
	if current == nil or validatedBirthday == nil then
		return current == validatedBirthday
	end

	return current.Month == validatedBirthday.Month
		and current.Day == validatedBirthday.Day
		and current.Year == validatedBirthday.Year
end

local function useValidatedBirthday(p: number)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)

	return state, (React.useCallback(function(p2: number?, p3: number?, p4: number?)
		local validatedBirthday = buildValidatedBirthday(p2, p3, p4, p)

		if isSameDate(ref.current, validatedBirthday) then -- inferred equivalent call
			return
		end

		ref.current = validatedBirthday
		setState(validatedBirthday)
	end, { p }))
end

return useValidatedBirthday
