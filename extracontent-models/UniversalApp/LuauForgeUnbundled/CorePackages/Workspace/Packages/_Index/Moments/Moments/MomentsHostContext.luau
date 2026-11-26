local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local context = React.createContext(nil)

return {
	MomentsHostContext = context,
	useMomentsHost = function()
		local v5 = React.useContext(context)

		if v5 == nil then
			return {}
		end

		return v5
	end
}
