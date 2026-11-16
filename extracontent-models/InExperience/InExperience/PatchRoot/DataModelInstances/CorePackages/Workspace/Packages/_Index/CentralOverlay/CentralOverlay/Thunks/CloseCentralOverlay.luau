local CentralOverlay = script:FindFirstAncestor("CentralOverlay")
local SetCentralOverlay = require(CentralOverlay.Actions.SetCentralOverlay)

return function()
	return function(object)
		if object:getState().CentralOverlay.Configs.DisableBackButtonClose then
			return
		end

		object:dispatch(SetCentralOverlay())
	end
end
