local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
require(ProfileQRCode.Analytics.useAnalytics)

return function(p, flag: boolean)
	useEffectOnce(function()
		p.fireEvent(EventNames.QRPageLoadFailed)
	end, flag)
end
