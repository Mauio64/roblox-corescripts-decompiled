local parent = script:FindFirstAncestor("GuiObjectUtils").Parent

local React = require(parent.React)

local function getRefValue(p) -- 3 equivalent calls inferred from this helper
	return if typeof(p) == "table" then p.current else p
end

local function useProperty(p, propertyName: string)
	local refValue = getRefValue(p) -- inferred equivalent call
	local state, setState = React.useState(function()
		if refValue then
			return refValue[propertyName]
		end

		return nil
	end)

	local v = React.useCallback(function()
		local refValue2 = getRefValue(p) -- inferred equivalent call

		if refValue2 then
			setState(refValue2[propertyName])
		end
	end, { p, propertyName })

	React.useEffect(function()
		local connection = nil
		local refValue2 = getRefValue(p) -- inferred equivalent call

		if refValue2 then
			connection = refValue2:GetPropertyChangedSignal(propertyName):Connect(v)

			v()
		end

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { refValue, propertyName, v })

	return state
end

return useProperty
