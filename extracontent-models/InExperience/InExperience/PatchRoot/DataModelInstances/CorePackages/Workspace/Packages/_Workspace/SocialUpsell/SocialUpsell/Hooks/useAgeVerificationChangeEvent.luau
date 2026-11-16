local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local React = require(parent.React)

local GetAgeVerifiedChangedSignal = require(SocialUpsell.Signals.GetAgeVerifiedChangedSignal)

return function(callback): nil
	React.useEffect(function()
		local ageVerifiedChangedSignal = GetAgeVerifiedChangedSignal()

		if callback then
			ageVerifiedChangedSignal:connect(callback)
		end

		return function() end
	end, { callback })
	return nil
end
