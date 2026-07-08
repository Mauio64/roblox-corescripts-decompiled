local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local Signals = require(GroupsParent.Signals)
local Cryo = require(GroupsParent.Cryo)

require(Groups.Common.Types)

local GroupsWebApi = require(Groups.Networking.GroupsWebApi)
local t1 = {
	isLoading = false,
	loadFailure = false,
	groupsList = nil,
	canCreateGroup = true
}

local function translateResultToGroup(p1, s1: string) -- line: 38
	local v17 = p1.group or {}
	local v18 = p1.role or {}
	local v19 = not v18.rank and 0 or v18.rank
	local owner = v17.owner

	return {
		id = not v17.id and 0 or v17.id,
		name = v17.name,
		memberCount = v17.memberCount,
		role = {
			name = v18.name,
			rank = v19
		},
		isPrimary = p1.isPrimaryGroup or false,
		isOwner = not not owner and (not not owner.userId and s1 == tostring(owner.userId)),
		groupHasVerifiedBadge = v17.hasVerifiedBadge or false,
		hasSocialModules = v17.hasSocialModules or false,
		thumbnail = v17.emblemUrl
	}
end
local function compareNames(s2: string, s3: string) -- line: 62
	local v23 = string.lower(s2)
	local v24 = string.lower(s3)
	local v25 = string.sub(v23, 1, 1)
	local v26 = string.sub(v24, 1, 1)
	local v27 = v25 >= "a" and v25 <= "z"
	local v28 = v26 >= "a" and v26 <= "z"

	if not v27 and v28 then
		return true
	end

	if v27 and not v28 then
		return false
	end

	return v23 < v24
end
local function sortGroups(t2: {[any]: any}) -- line: 82
	-- upvalues: compareNames (copy)
	local v30 = table.clone(t2)

	table.sort(v30, function(p2, p3) -- line: 84
		-- upvalues: compareNames (copy)
		local v61 = p2.isOwner or false
		local v62 = p3.isOwner or false
		local v63 = p2.name or ""
		local v64 = p3.name or ""

		if v61 and v62 then
			return (compareNames(v63, v64))
		end

		if v61 then
			return true
		end

		if v62 then
			return false
		end

		return (compareNames(v63, v64))
	end)

	return v30
end
local function getVisibleGroups(t3: {[any]: any}, p4) -- line: 107
	if not p4 or not p4.groups then
		return {}
	end

	local t4 = {}

	for _, v in ipairs(t3) do
		t4[v.id] = v
	end

	local t5 = {}

	for _, v in ipairs(p4.groups) do
		if v and v.canViewGroup and v.groupId then
			local num = tonumber(v.groupId)

			if num and t4[num] then
				table.insert(t5, t4[num])
			end
		end
	end

	return t5
end
local function movePrimaryGroupToFront(t6: {[any]: any}) -- line: 133
	local v41 = nil

	for i, v in ipairs(t6) do
		if v.isPrimary then
			v41 = i

			break
		end
	end

	if not v41 then
		return t6
	end

	local t7 = {}

	table.insert(t7, t6[v41])

	for i, v in ipairs(t6) do
		if i ~= v41 then
			table.insert(t7, v)
		end
	end

	return t7
end
local function deriveCanCreateGroup(p5) -- line: 159
	if not p5 then
		return true
	end

	local groupLimit = p5.groupLimit
	local currentGroupCount = p5.currentGroupCount

	if groupLimit and currentGroupCount then
		return currentGroupCount < groupLimit
	end

	return true
end
local function collectGroupIds(p6) -- line: 171
	if not p6 then
		return {}
	end

	local t8 = {}

	for _, v in ipairs(p6) do
		if v.group and v.group.id then
			table.insert(t8, v.group.id)
		end
	end

	return t8
end
local function createGroupsListStore() -- line: 184
	-- upvalues: Signals (copy), t1 (copy), GroupsWebApi (copy), collectGroupIds (copy), Cryo (copy), translateResultToGroup (copy), getVisibleGroups (copy), compareNames (copy), movePrimaryGroupToFront (copy)
	local v54, v55 = Signals.createSignal(t1)
	local t9 = {}
	local t10 = {}

	local function cleanup() -- line: 190
		-- upvalues: t9 (ref), t10 (ref)
		for _, v66 in t9 do
			v66()
		end

		for _, v68 in t10 do
			v68()
		end

		t9 = {}
		t10 = {}
	end

	return {
		getState = v54,
		fetchGroups = function(s4: string) -- line: 201
			-- upvalues: cleanup (copy), v55 (copy), GroupsWebApi (copy), t10 (ref), Signals (copy), collectGroupIds (copy), Cryo (copy), translateResultToGroup (copy), getVisibleGroups (copy), compareNames (copy), movePrimaryGroupToFront (copy), t9 (ref)
			cleanup()
			v55({
				isLoading = true,
				loadFailure = false,
				groupsList = nil,
				canCreateGroup = true
			})

			local v70, v71 = GroupsWebApi.GetUserGroupsWithRoles(s4)
			local v72, v73 = GroupsWebApi.GetGroupsMetadata()

			table.insert(t10, v71)
			table.insert(t10, v73)

			local u74 = false
			local v75 = Signals.createEffect(function(p7) -- line: 220
				-- upvalues: u74 (ref), v70 (copy), v55 (copy), collectGroupIds (copy), GroupsWebApi (copy), t10 (ref), Signals (copy), v72 (copy), Cryo (copy), translateResultToGroup (copy), s4 (copy), getVisibleGroups (copy), compareNames (copy), movePrimaryGroupToFront (copy), t9 (ref)
				if u74 then
					return
				end

				local v77 = v70(p7)

				if v77.status == "Loading" then
					return
				end

				if v77.status == "Failed" then
					u74 = true
					v55({
						isLoading = false,
						loadFailure = true,
						groupsList = nil,
						canCreateGroup = true
					})

					return
				end

				local v78 = if not v77.data or not v77.data.data then {} else v77.data.data

				if #v78 == 0 then
					u74 = true
					v55({
						isLoading = false,
						loadFailure = false,
						canCreateGroup = true,
						groupsList = {}
					})

					return
				end

				local v79 = collectGroupIds(v78)
				local v80, v81 = GroupsWebApi.GetGroupPolicies(v79)

				table.insert(t10, v81)

				local v82 = Signals.createEffect(function(p8) -- line: 260
					-- upvalues: u74 (ref), v80 (copy), v72 (copy), Cryo (copy), v78 (copy), translateResultToGroup (copy), s4 (copy), getVisibleGroups (copy), compareNames (copy), v55 (copy), movePrimaryGroupToFront (copy)
					if u74 then
						return
					end

					local v84 = v80(p8)

					if v84.status == "Loading" then
						return
					end

					local v85 = v72(p8)
					local v86 = if v85.status ~= "Success" then nil else v85.data

					u74 = true

					local v87 = if v84.status ~= "Success" then nil else v84.data
					local v88 = Cryo.List.map(v78, function(p9) -- line: 278
						-- upvalues: translateResultToGroup (copy), s4 (copy)
						return (translateResultToGroup(p9, s4))
					end)
					local v89 = if not v87 then {} else getVisibleGroups(v88, v87)
					local v90 = table.clone(v89)

					table.sort(v90, function(p10, p11) -- line: 84
						-- upvalues: compareNames (copy)
						local v105 = p10.isOwner or false
						local v106 = p11.isOwner or false
						local v107 = p10.name or ""
						local v108 = p11.name or ""

						if v105 and v106 then
							return (compareNames(v107, v108))
						end

						if v105 then
							return true
						end

						if v106 then
							return false
						end

						return (compareNames(v107, v108))
					end)

					if #v90 == 0 then
						local v91 = v55
						local t11 = {
							isLoading = false,
							loadFailure = false,
							groupsList = {}
						}
						local v93

						if not v86 then
							v93 = true
						else
							local groupLimit = v86.groupLimit
							local currentGroupCount = v86.currentGroupCount

							v93 = not groupLimit or (not currentGroupCount or currentGroupCount < groupLimit)
						end

						t11.canCreateGroup = v93
						v91(t11)

						return
					end

					local v96 = movePrimaryGroupToFront(v90)
					local v97 = v55
					local t12 = {
						isLoading = false,
						loadFailure = false,
						groupsList = v96
					}
					local v99

					if not v86 then
						v99 = true
					else
						local groupLimit = v86.groupLimit
						local currentGroupCount = v86.currentGroupCount

						v99 = not groupLimit or (not currentGroupCount or currentGroupCount < groupLimit)
					end

					t12.canCreateGroup = v99
					v97(t12)
				end)

				table.insert(t9, v82)
			end)

			table.insert(t9, v75)
		end,
		reset = function() -- line: 311
			-- upvalues: cleanup (copy), v55 (copy), t1 (copy)
			cleanup()
			v55(t1)
		end
	}
end

return createGroupsListStore
