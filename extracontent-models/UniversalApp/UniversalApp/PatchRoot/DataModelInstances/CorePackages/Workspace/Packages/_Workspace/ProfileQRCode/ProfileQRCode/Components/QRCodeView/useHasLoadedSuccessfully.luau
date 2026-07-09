local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local useEffectOnce = require(ProfileQRCodeParent.RoactUtils).Hooks.useEffectOnce
local useShareLinkId = require(ProfileQRCode.Rodux.useShareLinkId)

require(ProfileQRCode.Analytics.useAnalytics)

return function(p1, b1: boolean) -- line: 9
	-- upvalues: useShareLinkId (copy), EventNames (copy), useEffectOnce (copy)
	local v8 = useShareLinkId()

	useEffectOnce(function() -- line: 11
		-- upvalues: p1 (copy), EventNames (copy), v8 (copy)
		p1.fireEvent(EventNames.QRPageLoad, {
			shareLinkId = v8
		})
	end, b1)
end
