local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GuiObjectUtils/React")

local function getRefValue(p2)
	if typeof(p2) == "table" then
		return p2.current
	end

	return p2
end

local function useProperty(p2, propertyName)
	local v5 = if typeof(p2) == "table" then p2.current else p2

	local state, setState = React.useState(function()
		if v5 then
			return v5[propertyName]
		end

		return nil
	end)

	local v6 = React.useCallback(function()
		local v7 = p2

		if typeof(v7) == "table" then
			v7 = v7.current
		end

		if v7 then
			setState(v7[propertyName])
		end
	end, { p2, propertyName })

	React.useEffect(function()
		local connection = nil
		local v7 = p2

		if typeof(v7) == "table" then
			v7 = v7.current
		end

		if v7 then
			connection = v7:GetPropertyChangedSignal(propertyName):Connect(v6)

			v6()
		end

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v5, propertyName, v6 })

	return state
end

return useProperty
