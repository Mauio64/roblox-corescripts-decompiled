local SetCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/CentralOverlay/CentralOverlay/Actions/SetCentralOverlay")

return function()
	return function(object)
		if object:getState().CentralOverlay.Configs.DisableBackButtonClose then
			return
		end

		object:dispatch(SetCentralOverlay())
	end
end
