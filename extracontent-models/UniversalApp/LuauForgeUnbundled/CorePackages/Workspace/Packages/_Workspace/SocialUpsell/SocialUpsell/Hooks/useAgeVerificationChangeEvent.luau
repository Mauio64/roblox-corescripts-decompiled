local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")

local GetAgeVerifiedChangedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Signals/GetAgeVerifiedChangedSignal")

return function(p2): nil
	React.useEffect(function()
		local v5 = GetAgeVerifiedChangedSignal()

		if p2 then
			v5:connect(p2)
		end

		return function() end
	end, { p2 })
	return nil
end
