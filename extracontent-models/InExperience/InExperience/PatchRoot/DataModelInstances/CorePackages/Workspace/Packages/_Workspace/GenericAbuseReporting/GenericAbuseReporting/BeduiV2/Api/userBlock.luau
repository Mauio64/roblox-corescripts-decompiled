local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UserBlock = {}

function UserBlock.blockUser(callback, p: string)
	return callback(`{Url.APIS_URL}user-blocking-api/v1/users/{p}/block-user`, "POST")
end

function UserBlock.unblockUser(callback, p: string)
	return callback(`{Url.APIS_URL}user-blocking-api/v1/users/{p}/unblock-user`, "POST")
end

function UserBlock.isBlockedUser(callback, p: string)
	return callback(`{Url.APIS_URL}user-blocking-api/v1/users/{p}/is-blocked`, "GET")
end

return UserBlock
