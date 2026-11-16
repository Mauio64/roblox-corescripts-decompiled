local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SduiCoreSystem")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SduiSharedUtilities")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/DataHydration")
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")
local GroupSidebarContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/GroupSidebarContext")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/constants")
local getGroupSduiPageConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/getGroupSduiPageConfig")
local fetchGroupSduiPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/fetchGroupSduiPage")

local function isFresh(p2): boolean
	return p2 ~= nil and os.clock() - p2 < constants.SIDEBAR_STALE_TIME_SEC
end

local function noRefreshes(): number
	return 0
end

local function useGroupSidebarSection(p2, p3)
	local v5 = useGroupsWrapperContext()
	local v6 = React.useContext(GroupSidebarContext)
	local configKey = p2.configKey
	local v7 = React.useMemo(function()
		return getGroupSduiPageConfig("sidebarSection", v5.userId, p3)
	end, { v5.userId, p3 })
	local v8 = not v7 and "" or v7.configKey

	local v9 = React.useCallback(function(p4)
		if not configKey then
			return nil
		end

		local sduiApiStore = SduiSharedUtilities.getSduiApiStore()

		sduiApiStore.getData(configKey).data(p4)
		local inputData = sduiApiStore.getInputData(configKey, "groupSidebarSection", p4)

		if inputData and inputData.group_id == p3 then
			return sduiApiStore.getRootConfig(configKey, p4, `{configKey}_groupSidebarSection`)
		end

		return nil
	end, { configKey, p3 })
	local v10 = SignalsReact.useSignalState(v9)
	local v11 = React.useCallback(function(p4)
		return SduiSharedUtilities.getSduiApiStore().getRootConfig(v8, p4, nil)
	end, { v8 })
	local v12 = SignalsReact.useSignalState(v11)

	local v13 = React.useCallback(function(p4)
		if configKey and v9(p4) ~= nil then
			return SduiSharedUtilities.getSduiApiStore().getDataUpdatedTimestamp(
				configKey,
				p4,
				`{configKey}_groupSidebarSection`
			)
		end

		return nil
	end, { configKey, v9 })
	local v14 = React.useCallback(function(p4): boolean
		local v15 = v13(p4)
		local dataUpdatedTimestamp = SduiSharedUtilities.getSduiApiStore().getDataUpdatedTimestamp(v8, p4, nil)
		return v15 ~= nil and (dataUpdatedTimestamp == nil or dataUpdatedTimestamp < v15)
	end, { v13, v8 })
	local v15 = SignalsReact.useSignalState(v14)

	local ref = React.useRef(0)
	local v16 = React.useCallback(function(p4)
		return SduiSharedUtilities.getSduiApiStore().getData(v8).status(p4)
	end, { v8 })
	local v17 = SignalsReact.useSignalState(v16)

	local v18 = React.useCallback(function(p4)
		if v7 then
			fetchGroupSduiPage(
				v7,
				SduiSharedUtilities.SduiLoadTimer.createLoadTimer(v7.surfaceKey),
				p4,
				constants.SIDEBAR_STALE_TIME_SEC
			)
		end
	end, { v7 })
	React.useEffect(function()
		if not v7 then
			return
		end

		ref.current = os.clock()
		local sduiApiStore = SduiSharedUtilities.getSduiApiStore()
		local v19

		if configKey then
			v19 = sduiApiStore.getDataUpdatedTimestamp(configKey, false, `{configKey}_groupSidebarSection`)
		end

		if v9(false) ~= nil then
			local v20 = not (v19 == nil) and os.clock() - v19 < constants.SIDEBAR_STALE_TIME_SEC

			if v20 then
				return
			end
		end

		v18(false)
	end, { v7, v18, v9, configKey })

	local useSignalState = SignalsReact.useSignalState
	local v19 = if v6 then v6.sectionRefreshCount else noRefreshes
	local v20 = useSignalState(v19)
	local ref2 = React.useRef(v20)
	React.useEffect(function()
		if v20 ~= ref2.current then
			ref2.current = v20
			local v21 = v13(false)
			local v22 = not (v21 == nil) and ref.current < v21
			ref.current = os.clock()

			if not v22 then
				v18(true)
			end
		end
	end, { v20, v18, v13 })
	local v21 = React.useCallback(function()
		v18(true)
	end, { v18 })
	local v22 = v15 and v10 or v12 or v10
	local ref3 = React.useRef(nil)

	if v22 then
		ref3.current = { groupId = p3, root = v22 }
	elseif
		v17 ~= DataHydration.DataHydrationTypes.DataStatus.Ready
		and ref3.current
		and ref3.current.groupId == p3
	then
		v22 = ref3.current.root
	end

	return { root = v22, status = v17, retry = v21 }
end

return useGroupSidebarSection
