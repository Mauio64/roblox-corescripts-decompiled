local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local useSelector = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useSelector
local createOrGetProfileShareUrl = require(ProfileQRCode.Networking.createOrGetProfileShareUrl)

return function() -- line: 7
	-- upvalues: useSelector (copy), createOrGetProfileShareUrl (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: createOrGetProfileShareUrl (copy)
		return createOrGetProfileShareUrl.getStatus(p1)
	end)
end
