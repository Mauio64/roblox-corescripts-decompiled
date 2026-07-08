local CentralOverlay = script:FindFirstAncestor("CentralOverlay")
local SetCentralOverlay = require(CentralOverlay.Actions.SetCentralOverlay)

return function() -- line: 4
	-- upvalues: SetCentralOverlay (copy)
	return function(p1) -- line: 5
		-- upvalues: SetCentralOverlay (copy)
		if p1:getState().CentralOverlay.Configs.DisableBackButtonClose then
			return
		end

		p1:dispatch(SetCentralOverlay())
	end
end
