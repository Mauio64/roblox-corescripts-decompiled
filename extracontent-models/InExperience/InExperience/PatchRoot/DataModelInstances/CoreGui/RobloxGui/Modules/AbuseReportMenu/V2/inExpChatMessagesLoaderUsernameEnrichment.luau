local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local UserProfileStore = require(CorePackages.Workspace.Packages.UserProfiles).Stores.UserProfileStore

local function collectUserIdsMissingUsername(p1) -- line: 8
	local t1 = {}
	local t2 = {}

	for _, v10 in p1 do
		for _, v12 in v10.items do
			local meta = v12.meta
			local v14 = meta and meta.userId
			local v15 = meta and meta.username

			if v14 and v14 ~= "0" and ((not v15 or v15 == "") and not t1[v14]) then
				t1[v14] = true
				table.insert(t2, v14)
			end
		end
	end

	return t2
end
local function enrichGroupsWithProfileUsernames(p2, p3) -- line: 27
	local t3 = {}

	for _, v20 in p3 do
		local v21 = v20.names.getUsername(false)

		if v21 and #v21 > 0 then
			t3[v20.userId] = v21
		end
	end

	for _, v23 in p2 do
		for _, v25 in v23.items do
			local meta = v25.meta

			if meta and (not meta.username or meta.username == "") then
				local v27 = t3[meta.userId]

				if v27 then
					meta.username = v27
				end
			end
		end
	end
end

return {
	collectUserIdsMissingUsername = collectUserIdsMissingUsername,
	enrichGroupsWithProfileUsernames = enrichGroupsWithProfileUsernames,
	enrichMissingUsernames = function(p4) -- line: 50
		-- upvalues: collectUserIdsMissingUsername (copy), Promise (copy), UserProfileStore (copy), enrichGroupsWithProfileUsernames (copy)
		local v29 = collectUserIdsMissingUsername(p4)

		if #v29 == 0 then
			return Promise.resolve(p4)
		end

		return Promise.new(function(resolve) -- line: 56
			-- upvalues: UserProfileStore (copy), v29 (copy), enrichGroupsWithProfileUsernames (copy), p4 (copy)
			UserProfileStore.get().fetchNamesByUserIds(v29, function(p5) -- line: 57
				-- upvalues: enrichGroupsWithProfileUsernames (copy), p4 (copy), resolve (copy)
				if p5.status == "success" and p5.data then
					enrichGroupsWithProfileUsernames(p4, p5.data)
					resolve(p4)

					return
				end

				if p5.status == "failed" then
					resolve(p4)
				end
			end)
		end)
	end
}
