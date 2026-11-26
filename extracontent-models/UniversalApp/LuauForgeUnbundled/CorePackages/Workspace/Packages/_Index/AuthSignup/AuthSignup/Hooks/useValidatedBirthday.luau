local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local buildValidatedBirthday = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Util/buildValidatedBirthday")

local function isSameDate(data, data2): boolean
	if data == nil or data2 == nil then
		return data == data2
	end

	return data.Month == data2.Month and data.Day == data2.Day and data.Year == data2.Year
end

local function useValidatedBirthday(p2)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)

	return state, (React.useCallback(function(p3, p4, p5)
		local v5 = buildValidatedBirthday(p3, p4, p5, p2)
		local current = ref.current
		local v6

		if current == nil or v5 == nil then
			v6 = current == v5
		else
			v6 = current.Month == v5.Month and current.Day == v5.Day and current.Year == v5.Year
		end

		if v6 then
			return
		end

		ref.current = v5
		setState(v5)
	end, { p2 }))
end

return useValidatedBirthday
