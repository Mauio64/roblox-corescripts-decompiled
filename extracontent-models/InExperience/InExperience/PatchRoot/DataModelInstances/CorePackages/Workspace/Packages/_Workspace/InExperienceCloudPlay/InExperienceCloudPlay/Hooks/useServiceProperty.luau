local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local React = require(parent.React)
require(InExperienceCloudPlay.getCloudClientService)

local function useServiceProperty(instance, propertyName: string)
	local useState = React.useState
	local v

	if instance then
		v = instance[propertyName]
	end

	local state, setState = useState(v)

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
