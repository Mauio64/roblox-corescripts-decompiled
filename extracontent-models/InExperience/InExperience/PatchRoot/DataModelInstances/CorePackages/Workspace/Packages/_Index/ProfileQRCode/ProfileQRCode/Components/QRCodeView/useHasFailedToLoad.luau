local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local useEffectOnce = require(ProfileQRCodeParent.RoactUtils).Hooks.useEffectOnce

require(ProfileQRCode.Analytics.useAnalytics)

return function(p1, b1: boolean) -- line: 9
	-- upvalues: useEffectOnce (copy), EventNames (copy)
	useEffectOnce(function() -- line: 10
		-- upvalues: p1 (copy), EventNames (copy)
		p1.fireEvent(EventNames.QRPageLoadFailed)
	end, b1)
end
