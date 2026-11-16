local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local DataHydration = require(parent.DataHydration)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)
local GroupSidebarContext = require(Groups.Contexts.GroupSidebarContext)
local constants = require(Groups.Common.constants)
local getGroupSduiPageConfig = require(Groups.Common.getGroupSduiPageConfig)
local fetchGroupSduiPage = require(Groups.Common.fetchGroupSduiPage)

local function isFresh(p: number?): boolean -- 1 equivalent call inferred from this helper
	return p ~= nil and os.clock() - p < constants.SIDEBAR_STALE_TIME_SEC
end

local function noRefreshes(): number
	return 0
end

local function useGroupSidebarSection(p, groupId: string)
	local v = useGroupsWrapperContext()
	local v2 = React.useContext(GroupSidebarContext)
	local configKey = p.configKey
	local v3 = React.useMemo(function()
		return getGroupSduiPageConfig("sidebarSection", v.userId, groupId)
	end, { v.userId, groupId })
	local v4 = not v3 and "" or v3.configKey

	local v5 = React.useCallback(function(p2)
		if not configKey then
			return nil
		end

		local sduiApiStore = SduiSharedUtilities.getSduiApiStore()

		sduiApiStore.getData(configKey).data(p2)
		local inputData = sduiApiStore.getInputData(configKey, "groupSidebarSection", p2)

		if inputData and inputData.group_id == groupId then
			return sduiApiStore.getRootConfig(configKey, p2, `{configKey}_groupSidebarSection`)
		end

		return nil
	end, { configKey, groupId })
	local v6 = SignalsReact.useSignalState(v5)
	local v7 = React.useCallback(function(p2)
		return SduiSharedUtilities.getSduiApiStore().getRootConfig(v4, p2, nil)
	end, { v4 })
	local v8 = SignalsReact.useSignalState(v7)

	local v9 = React.useCallback(function(p2)
		if configKey and v5(p2) ~= nil then
			return SduiSharedUtilities.getSduiApiStore().getDataUpdatedTimestamp(
				configKey,
				p2,
				`{configKey}_groupSidebarSection`
			)
		end

		return nil
	end, { configKey, v5 })
	local v10 = React.useCallback(function(p2): boolean
		local v10 = v9(p2)
		local dataUpdatedTimestamp = SduiSharedUtilities.getSduiApiStore().getDataUpdatedTimestamp(v4, p2, nil)
		return v10 ~= nil and (dataUpdatedTimestamp == nil or dataUpdatedTimestamp < v10)
	end, { v9, v4 })
	local v11 = SignalsReact.useSignalState(v10)

	local ref = React.useRef(0)
	local v12 = React.useCallback(function(p2)
		return SduiSharedUtilities.getSduiApiStore().getData(v4).status(p2)
	end, { v4 })
	local status = SignalsReact.useSignalState(v12)

	local v13 = React.useCallback(function(flag: boolean)
		if v3 then
			fetchGroupSduiPage(
				v3,
				SduiSharedUtilities.SduiLoadTimer.createLoadTimer(v3.surfaceKey),
				flag,
				constants.SIDEBAR_STALE_TIME_SEC
			)
		end
	end, { v3 })
	React.useEffect(function()
		if not v3 then
			return
		end

		ref.current = os.clock()
		local sduiApiStore = SduiSharedUtilities.getSduiApiStore()
		local v14

		if configKey then
			v14 = sduiApiStore.getDataUpdatedTimestamp(configKey, false, `{configKey}_groupSidebarSection`)
		end

		if v5(false) ~= nil and isFresh(v14) then -- inferred equivalent call
			return
		end

		v13(false)
	end, { v3, v13, v5, configKey })

	local useSignalState = SignalsReact.useSignalState
	local v14 = if v2 then v2.sectionRefreshCount else noRefreshes
	local current = useSignalState(v14)
	local ref2 = React.useRef(current)
	React.useEffect(function()
		if current ~= ref2.current then
			ref2.current = current
			local v15 = v9(false)
			local v16

			if v15 == nil then
				v16 = false
			else
				v16 = ref.current < v15
			end

			ref.current = os.clock()

			if not v16 then
				v13(true)
			end
		end
	end, { current, v13, v9 })
	local retry = React.useCallback(function()
		v13(true)
	end, { v13 })
	local root = v11 and v6 or v8 or v6
	local ref3 = React.useRef(nil)

	if root then
		ref3.current = { groupId = groupId, root = root }
	elseif
		status ~= DataHydration.DataHydrationTypes.DataStatus.Ready
		and ref3.current
		and ref3.current.groupId == groupId
	then
		root = ref3.current.root
	end

	return { root = root, status = status, retry = retry }
end

return useGroupSidebarSection
