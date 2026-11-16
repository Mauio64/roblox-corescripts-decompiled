local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

require(Groups.Common.Types)
local GroupsWebApi = require(Groups.Networking.GroupsWebApi)

local v = { isLoading = false, loadFailure = false, groupsList = nil, canCreateGroup = true }

local function translateResultToGroup(data, p: string)
	local group = data.group or {}
	local role = data.role or {}
	local rank = not role.rank and 0 or role.rank
	local owner = group.owner
	local v2 = {
		id = not group.id and 0 or group.id,
		name = group.name,
		memberCount = group.memberCount,
		role = { name = role.name, rank = rank },
		isPrimary = data.isPrimaryGroup or false,
		isOwner = 0,
		groupHasVerifiedBadge = 0,
		hasSocialModules = 0,
		thumbnail = 0
	}
	local isOwner

	if owner and owner.userId then
		isOwner = tostring(owner.userId) == p
	else
		isOwner = false
	end

	v2.isOwner = isOwner
	v2.groupHasVerifiedBadge = group.hasVerifiedBadge or false
	v2.hasSocialModules = group.hasSocialModules or false
	v2.thumbnail = group.emblemUrl
	return v2
end

local function compareNames(name: string, name2: string): boolean
	local v2 = string.lower(name)
	local v3 = string.lower(name2)

	local v4 = string.sub(v2, 1, 1)
	local v5 = string.sub(v3, 1, 1)
	local v6

	if v4 >= "a" then
		v6 = v4 <= "z"
	else
		v6 = false
	end

	local v7

	if v5 >= "a" then
		v7 = v5 <= "z"
	else
		v7 = false
	end

	return not (v6 or not v7) or not (v6 and not v7) and v2 < v3
end

local function sortGroups(p)
	local clone = table.clone(p)
	table.sort(clone, function(a, b)
		local isOwner = a.isOwner or false
		local isOwner2 = b.isOwner or false
		local name = a.name or ""
		local name2 = b.name or ""

		if isOwner and isOwner2 then
			return compareNames(name, name2)
		end

		if isOwner then
			return true
		end

		return not isOwner2 and compareNames(name, name2)
	end)

	return clone
end

local function getVisibleGroups(mapped, data)
	if not (data and data.groups) then
		return {}
	end

	local v2 = {}

	for _, item in ipairs(mapped) do
		v2[item.id] = item
	end

	local result = {}

	for _, group in ipairs(data.groups) do
		if not (group and group.canViewGroup and group.groupId) then
			continue
		end

		local groupId = tonumber(group.groupId)

		if groupId and v2[groupId] then
			table.insert(result, v2[groupId])
		end
	end

	return result
end

local function movePrimaryGroupToFront(clone)
	local v2 = nil

	for i, item in ipairs(clone) do
		if item.isPrimary then
			v2 = i
			break
		end
	end

	if not v2 then
		return clone
	end

	local result = {}
	table.insert(result, clone[v2])

	for i, item in ipairs(clone) do
		if i ~= v2 then
			table.insert(result, item)
		end
	end

	return result
end

local function deriveCanCreateGroup(data): boolean -- 2 equivalent calls inferred from this helper
	if not data then
		return true
	end

	local groupLimit = data.groupLimit
	local currentGroupCount = data.currentGroupCount

	return not (groupLimit and currentGroupCount) or currentGroupCount < groupLimit
end

local function collectGroupIds(list)
	if not list then
		return {}
	end

	local ids = {}

	for _, item in ipairs(list) do
		if item.group and item.group.id then
			table.insert(ids, item.group.id)
		end
	end

	return ids
end

local function createGroupsListStore()
	local signal, v2 = Signals.createSignal(v)

	local effects = {}
	local v3 = {}

	local function cleanup()
		for _, v4 in effects do
			v4()
		end

		for _, v4 in v3 do
			v4()
		end

		effects = {}
		v3 = {}
	end

	local function fetchGroups(p: string)
		cleanup()

		v2({ isLoading = true, loadFailure = false, groupsList = nil, canCreateGroup = true })

		local userGroups, v4 = GroupsWebApi.GetUserGroupsWithRoles(p)
		local groupsMetadata, v5 = GroupsWebApi.GetGroupsMetadata()
		table.insert(v3, v4)
		table.insert(v3, v5)

		local flag = false

		local effect = Signals.createEffect(function(p2)
			if flag then
				return
			end

			local v6 = userGroups(p2)

			if v6.status == "Loading" then
				return
			end

			if v6.status == "Failed" then
				flag = true
				v2({
					isLoading = false,
					loadFailure = true,
					groupsList = nil,
					canCreateGroup = true
				})
			else
				local v7 = not (v6.data and v6.data.data) and {} or v6.data.data

				if #v7 == 0 then
					flag = true
					v2({
						isLoading = false,
						loadFailure = false,
						groupsList = {},
						canCreateGroup = true
					})
				else
					local v8 = collectGroupIds(v7)
					local groupPolicies, v9 = GroupsWebApi.GetGroupPolicies(v8)
					table.insert(v3, v9)

					local effect = Signals.createEffect(function(p3)
						if flag then
							return
						end

						local v10 = groupPolicies(p3)

						if v10.status == "Loading" then
							return
						end

						local v11 = groupsMetadata(p3)
						local data

						if v11.status == "Success" then
							data = v11.data
						end

						flag = true
						local data2

						if v10.status == "Success" then
							data2 = v10.data
						end

						local mapped = Cryo.List.map(v7, function(p4)
							return translateResultToGroup(p4, p)
						end)

						local v12 = not data2 and {} or getVisibleGroups(mapped, data2)
						local clone = table.clone(v12)
						table.sort(clone, function(a, b)
							local isOwner = a.isOwner or false
							local isOwner2 = b.isOwner or false
							local name = a.name or ""
							local name2 = b.name or ""

							if isOwner and isOwner2 then
								return compareNames(name, name2)
							end

							if isOwner then
								return true
							end

							return not isOwner2 and compareNames(name, name2)
						end)

						if #clone == 0 then
							v2({
								isLoading = false,
								loadFailure = false,
								groupsList = {},
								canCreateGroup = deriveCanCreateGroup(data) -- inferred equivalent call
							})
						else
							v2({
								isLoading = false,
								loadFailure = false,
								groupsList = movePrimaryGroupToFront(clone),
								canCreateGroup = deriveCanCreateGroup(data) -- inferred equivalent call
							})
						end
					end)

					table.insert(effects, effect)
				end
			end
		end)

		table.insert(effects, effect)
	end

	local function reset()
		cleanup()
		v2(v)
	end

	return { getState = signal, fetchGroups = fetchGroups, reset = reset }
end

return createGroupsListStore
