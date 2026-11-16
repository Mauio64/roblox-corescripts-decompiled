local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope

local ExperienceDetailsPageScopeFields = require(script.Parent.ExperienceDetailsPageScopeFields)
local ContainerWidth = ExperienceDetailsPageScopeFields.ContainerWidth

local function usePublishContainerWidth(p: string, callback)
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
			local sduiClientPageScope = getSduiClientPageScope(p)

			local v = nil
			local function publishAbsoluteSize() -- 1 equivalent call inferred from this helper
				local x = instance.AbsoluteSize.X

				if x ~= v then
					v = x
					sduiClientPageScope.set(ContainerWidth, x)
				end
			end

			publishAbsoluteSize() -- inferred equivalent call
			ref.current = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(publishAbsoluteSize)
		end
	end, { p, callback })
end

return usePublishContainerWidth
