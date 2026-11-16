local mutedError = require("@luauforge/bundled/dRs").mutedError

local function wrapZeroArgAction(callback)
	if typeof(callback) == "function" then
		return function()
			callback(nil, nil, nil)
		end
	end

	if callback ~= nil then
		mutedError(`Expected function, got {typeof(callback)}`)
	end

	return nil
end

return wrapZeroArgAction
