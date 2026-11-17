local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

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
			local function publishWidth() -- 1 equivalent call inferred from this helper
				local x = instance.AbsoluteSize.X

				if x ~= v then
					v = x
					sduiClientPageScope.set("containerWidth", x)
				end
			end

			publishWidth() -- inferred equivalent call
			ref.current = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(publishWidth)
		end
	end, { p, callback })
end

return usePublishContainerWidth
