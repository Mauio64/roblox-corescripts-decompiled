local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")
local GetMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore")

local context = React.createContext(nil)

return {
	MomentsSessionContext = context,
	useMomentsSession = function()
		local v5 = React.useContext(context)

		if v5 == nil then
			return GetMomentsStore()
		end

		return v5
	end
}
