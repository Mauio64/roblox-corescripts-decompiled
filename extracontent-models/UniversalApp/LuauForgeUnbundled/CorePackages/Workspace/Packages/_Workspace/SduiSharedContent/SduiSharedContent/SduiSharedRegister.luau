local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local registerSharedActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/registerSharedActions")
local registerSharedUiComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/registerSharedUiComponents")

local function SduiSharedRegister(): nil
	React.useEffect(function()
		registerSharedActions()
		registerSharedUiComponents()
	end, {})
	return nil
end

return React.memo(SduiSharedRegister)
