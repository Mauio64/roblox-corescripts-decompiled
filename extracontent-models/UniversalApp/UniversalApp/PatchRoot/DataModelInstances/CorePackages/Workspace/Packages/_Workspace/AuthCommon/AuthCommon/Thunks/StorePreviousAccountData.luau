local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local User = require(AuthCommon.Thunks.User)

return function() -- line: 5
	-- upvalues: User (copy), AppStorageUtilities (copy)
	local v4 = User.fromLocalStorage()

	if v4 == nil or v4.userId == -1 then
		return
	end

	if v4.username == nil or v4.username == "" then
		return
	end

	local v5 = AppStorageUtilities.getPreviousAccountsList()

	v5[tostring(v4.userId)] = {
		username = v4.username,
		displayName = (not v4.displayName or v4.displayName == "nil") and "" or v4.displayName,
		timestamp = os.time()
	}
	AppStorageUtilities.setPreviousAccountsList(v5)
	AppStorageUtilities.flush()
end
