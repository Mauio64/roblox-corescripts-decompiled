local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")

local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities").getSduiClientPageScope

local containerWidth = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageScopeFields").ContainerWidth

local function usePublishContainerWidth(p2, callback)
	local ref = React.useRef(nil)
	return React.useCallback(function(instance)
		if callback then
			callback(instance)
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end

		if instance then
			local sduiClientPageScope = getSduiClientPageScope(p2)

			local v5 = nil
			local function publishAbsoluteSize()
				local x = instance.AbsoluteSize.X

				if x ~= v5 then
					v5 = x
					sduiClientPageScope.set(containerWidth, x)
				end
			end

			local x = instance.AbsoluteSize.X

			if x ~= v5 then
				v5 = x
				sduiClientPageScope.set(containerWidth, x)
			end

			ref.current = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(publishAbsoluteSize)
		end
	end, { p2, callback })
end

return usePublishContainerWidth
