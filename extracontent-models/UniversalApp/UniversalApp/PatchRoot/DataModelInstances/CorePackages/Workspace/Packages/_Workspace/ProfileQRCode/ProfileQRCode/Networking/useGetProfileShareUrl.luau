local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local createOrGetProfileShareUrl = require(ProfileQRCode.Networking.createOrGetProfileShareUrl)
local useDispatch = require(ProfileQRCodeParent.RoactUtils).Hooks.RoactRodux.useDispatch

return function() -- line: 7
	-- upvalues: useDispatch (copy), createOrGetProfileShareUrl (copy)
	local v5 = useDispatch()

	return function() -- line: 10
		-- upvalues: v5 (copy), createOrGetProfileShareUrl (copy)
		return v5(createOrGetProfileShareUrl.API()):catch(function() -- line: 11
		end)
	end
end
