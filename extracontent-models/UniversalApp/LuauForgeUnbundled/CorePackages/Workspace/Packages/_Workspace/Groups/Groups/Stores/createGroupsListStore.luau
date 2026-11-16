local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local GroupsWebApi = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Networking/GroupsWebApi")

local v5 = {
	isLoading = false,
	loadFailure = false,
	groupsList = nil,
	canCreateGroup = true
}

local function translateResultToGroup(data, p2)
	local group = data.group or {}
	local role = data.role or {}
	local v6 = not role.rank and 0 or role.rank
	local owner = group.owner
	local v7 = {
		id = not group.id and 0 or group.id,
		name = group.name,
		memberCount = group.memberCount,
		role = { name = role.name, rank = v6 },
		isPrimary = data.isPrimaryGroup or false,
		isOwner = 0,
		groupHasVerifiedBadge = 0,
		hasSocialModules = 0,
		thumbnail = 0
	}
	local v8 = if owner and owner.userId then tostring(owner.userId) == p2 else false
	v7.isOwner = v8
	v7.groupHasVerifiedBadge = group.hasVerifiedBadge or false
	v7.hasSocialModules = group.hasSocialModules or false
	v7.thumbnail = group.emblemUrl
	return v7
end

local function compareNames(name, name2): boolean
	local v6 = string.lower(name)
	local v7 = string.lower(name2)

	local v8 = string.sub(v6, 1, 1)
	local v9 = string.sub(v7, 1, 1)

	local v10 = v8 >= "a" and v8 <= "z"
	local v11 = v9 >= "a" and v9 <= "z"

	if v10 or not v11 then
		if v10 and not v11 then
			return false
		end

		return v6 < v7
	end

	return true
end

local function sortGroups(p2)
	local clone = table.clone(p2)
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

		if isOwner2 then
			return false
		end

		return compareNames(name, name2)
	end)

	return clone
end

local function getVisibleGroups(mapped, data)
	if not (data and data.groups) then
		return {}
	end

	local v6 = {}

	for i, item in ipairs(mapped) do
		v6[item.id] = item
	end

	local result = {}

	for i, group in ipairs(data.groups) do
		if not (group and group.canViewGroup and group.groupId) then
			continue
		end

		local groupId = tonumber(group.groupId)

		if groupId and v6[groupId] then
			table.insert(result, v6[groupId])
		end
	end

	return result
end

local function movePrimaryGroupToFront(clone)
	local v6 = nil

	for i, item in ipairs(clone) do
		if item.isPrimary then
			v6 = i
			break
		end
	end

	if not v6 then
		return clone
	end

	local result = {}
	table.insert(result, clone[v6])

	for i, item in ipairs(clone) do
		if i ~= v6 then
			table.insert(result, item)
		end
	end

	return result
end

local function deriveCanCreateGroup(p2): boolean
	if not p2 then
		return true
	end

	local groupLimit = p2.groupLimit
	local currentGroupCount = p2.currentGroupCount

	if groupLimit and currentGroupCount then
		return currentGroupCount < groupLimit
	end

	return true
end

local function collectGroupIds(list)
	if not list then
		return {}
	end

	local ids = {}

	for i, item in ipairs(list) do
		if item.group and item.group.id then
			table.insert(ids, item.group.id)
		end
	end

	return ids
end

local function createGroupsListStore()
	local signal, v6 = Signals.createSignal(v5)

	local effects = {}
	local v7 = {}

	local function cleanup()
		for k, v8 in effects do
			v8()
		end

		for k, v8 in v7 do
			v8()
		end

		effects = {}
		v7 = {}
	end

	local function fetchGroups(p2)
		cleanup()

		v6({
			isLoading = true,
			loadFailure = false,
			groupsList = nil,
			canCreateGroup = true
		})

		local userGroups, v8 = GroupsWebApi.GetUserGroupsWithRoles(p2)
		local groupsMetadata, v9 = GroupsWebApi.GetGroupsMetadata()
		table.insert(v7, v8)
		table.insert(v7, v9)

		local flag = false

		local effect = Signals.createEffect(function(p3)
			if flag then
				return
			end

			local v10 = userGroups(p3)

			if v10.status == "Loading" then
				return
			end

			if v10.status == "Failed" then
				flag = true
				v6({
					isLoading = false,
					loadFailure = true,
					groupsList = nil,
					canCreateGroup = true
				})
			else
				local v11 = not (v10.data and v10.data.data) and {} or v10.data.data

				if #v11 == 0 then
					flag = true
					v6({
						isLoading = false,
						loadFailure = false,
						groupsList = {},
						canCreateGroup = true
					})
				else
					local v12 = collectGroupIds(v11)
					local groupPolicies, v13 = GroupsWebApi.GetGroupPolicies(v12)
					table.insert(v7, v13)

					local effect2 = Signals.createEffect(function(p4)
						if flag then
							return
						end

						local v14 = groupPolicies(p4)

						if v14.status == "Loading" then
							return
						end

						local v15 = groupsMetadata(p4)
						local data = if v15.status == "Success" then v15.data else nil

						flag = true

						local data2 = if v14.status == "Success" then v14.data else nil

						local mapped = Cryo.List.map(v11, function(p5)
							return translateResultToGroup(p5, p2)
						end)

						local v16 = not data2 and {} or getVisibleGroups(mapped, data2)
						local clone = table.clone(v16)
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

							if isOwner2 then
								return false
							end

							return compareNames(name, name2)
						end)

						if #clone == 0 then
							local v19

							if data then
								local groupLimit = data.groupLimit
								local currentGroupCount = data.currentGroupCount

								v19 = not (groupLimit and currentGroupCount)
									or currentGroupCount < groupLimit
							else
								v19 = true
							end

							v6({
								isLoading = false,
								loadFailure = false,
								groupsList = {},
								canCreateGroup = v19
							})
						else
							local v17 = movePrimaryGroupToFront(clone)
							local v20

							if data then
								local groupLimit = data.groupLimit
								local currentGroupCount = data.currentGroupCount

								v20 = not (groupLimit and currentGroupCount)
									or currentGroupCount < groupLimit
							else
								v20 = true
							end

							v6({
								isLoading = false,
								loadFailure = false,
								groupsList = v17,
								canCreateGroup = v20
							})
						end
					end)

					table.insert(effects, effect2)
				end
			end
		end)

		table.insert(effects, effect)
	end

	local function reset()
		cleanup()
		v6(v5)
	end

	return { getState = signal, fetchGroups = fetchGroups, reset = reset }
end

return createGroupsListStore
