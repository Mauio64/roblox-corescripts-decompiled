local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/AppCommonLib").Signal

local function useCollectionImpressionsSignal(object)
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = signal.new()
	end

	local current = ref.current

	React.useEffect(function()
		current:fire()
		local connection

		if object then
			connection = object:connect(function()
				current:fire()
			end)
		else
			connection = nil
		end

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { object, current })

	return current, (React.useCallback(function()
		current:fire()
	end, { current }))
end

return useCollectionImpressionsSignal
