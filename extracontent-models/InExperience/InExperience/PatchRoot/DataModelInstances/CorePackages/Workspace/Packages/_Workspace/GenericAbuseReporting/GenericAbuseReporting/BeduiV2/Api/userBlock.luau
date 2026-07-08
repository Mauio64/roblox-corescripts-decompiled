local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Url = require(Parent.Http).Url

return {
	blockUser = function(p1, s1: string) -- line: 8
		-- upvalues: Url (copy)
		return p1(`{ Url.APIS_URL }user-blocking-api/v1/users/{ s1 }/block-user`, "POST")
	end,
	unblockUser = function(p2, s2: string) -- line: 13
		-- upvalues: Url (copy)
		return p2(`{ Url.APIS_URL }user-blocking-api/v1/users/{ s2 }/unblock-user`, "POST")
	end,
	isBlockedUser = function(p3, s3: string) -- line: 18
		-- upvalues: Url (copy)
		return p3(`{ Url.APIS_URL }user-blocking-api/v1/users/{ s3 }/is-blocked`, "GET")
	end
}
