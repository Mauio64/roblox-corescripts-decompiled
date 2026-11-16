local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local function useAutoFocusTextBoxOnMount(callback, value)
	local ref = React.useRef(false)

	return React.useCallback(function(object)
		if callback then
			callback(object)
		end

		if object and not ref.current then
			ref.current = true
			task.spawn(function()
				task.wait(value or 0.05)

				if object and object.Parent then
					object:CaptureFocus()
				end
			end)
		end
	end, { callback, value })
end

return useAutoFocusTextBoxOnMount
