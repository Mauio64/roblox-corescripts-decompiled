local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/getCloudClientService")

local function useServiceProperty(instance, propertyName)
	local useState = React.useState
	local v5 = if instance then instance[propertyName] else nil
	local state, setState = useState(v5)

	React.useEffect(function()
		if not instance then
			return nil
		end

		local connection = instance:GetPropertyChangedSignal(propertyName):Connect(function()
			setState(instance[propertyName])
		end)
		return function()
			connection:Disconnect()
		end
	end, { instance, propertyName })

	return state
end

return useServiceProperty
