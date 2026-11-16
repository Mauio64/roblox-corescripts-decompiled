local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useShareLinkId = require(ProfileQRCode.Rodux.useShareLinkId)
require(ProfileQRCode.Analytics.useAnalytics)

return function(p, flag: boolean)
	local shareLinkId = useShareLinkId()
	useEffectOnce(function()
		p.fireEvent(EventNames.QRPageLoad, { shareLinkId = shareLinkId })
	end, flag)
end
