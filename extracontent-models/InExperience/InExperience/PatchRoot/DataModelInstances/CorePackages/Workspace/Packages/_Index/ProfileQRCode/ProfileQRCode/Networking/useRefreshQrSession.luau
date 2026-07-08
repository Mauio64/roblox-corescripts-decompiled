local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local useDispatch = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useDispatch
local refreshQrSession = require(ProfileQRCode.Networking.refreshQrSession)

return function() -- line: 8
	-- upvalues: useDispatch (copy), refreshQrSession (copy)
	local v5 = useDispatch()

	return function() -- line: 11
		-- upvalues: v5 (copy), refreshQrSession (copy)
		return v5(refreshQrSession.API()):catch(function() -- line: 12
		end)
	end
end
