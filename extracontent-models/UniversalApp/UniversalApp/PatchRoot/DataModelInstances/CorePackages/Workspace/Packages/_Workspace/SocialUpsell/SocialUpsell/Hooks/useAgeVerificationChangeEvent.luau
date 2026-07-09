local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local React = require(SocialUpsellParent.React)
local GetAgeVerifiedChangedSignal = require(SocialUpsell.Signals.GetAgeVerifiedChangedSignal)

return function(p1: ((...any) -> ...any)?) -- line: 8
	-- upvalues: React (copy), GetAgeVerifiedChangedSignal (copy)
	React.useEffect(function() -- line: 9
		-- upvalues: GetAgeVerifiedChangedSignal (copy), p1 (copy)
		local v6 = GetAgeVerifiedChangedSignal()

		if p1 then
			v6:connect(p1)
		end

		return function() -- line: 15
		end
	end, { p1 })

	return nil
end
