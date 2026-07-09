local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local llama = dependencies.llama
local RoduxUsers = dependencies.RoduxUsers

local function userUpdatedFromUser(p1) -- line: 7
	-- upvalues: RoduxUsers (copy)
	return RoduxUsers.Actions.UserUpdated({
		id = p1.id,
		username = p1.name,
		displayName = p1.displayName,
		hasVerifiedBadge = p1.hasVerifiedBadge
	})
end

return function(p2, p3) -- line: 16
	-- upvalues: llama (copy), RoduxUsers (copy)
	local v9 = llama.List.reduce(p2.responseBody, function(p4, p5) -- line: 17
		-- upvalues: llama (copy), p3 (copy), RoduxUsers (copy)
		return llama.List.reduce(p5.participants, function(p6, p7) -- line: 18
			-- upvalues: p3 (copy), llama (copy), RoduxUsers (copy)
			local str = tostring(p7.targetId)

			if not p6[str] and not p3.byUserId[str] then
				local v15 = llama.Dictionary.join(p7, {
					id = str
				})

				return llama.Dictionary.join(p6, {
					[str] = RoduxUsers.Actions.UserUpdated({
						id = v15.id,
						username = v15.name,
						displayName = v15.displayName,
						hasVerifiedBadge = v15.hasVerifiedBadge
					})
				})
			end

			return p6
		end, p4)
	end, {})

	return llama.Dictionary.values(v9)
end
