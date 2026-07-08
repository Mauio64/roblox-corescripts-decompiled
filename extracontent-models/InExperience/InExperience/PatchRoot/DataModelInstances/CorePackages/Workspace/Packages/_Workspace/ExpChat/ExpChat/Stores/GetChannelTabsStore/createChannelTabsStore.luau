local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local tutils = require(ExpChatParent.tutils)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(ExpChat.Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local getFixedTabPriority = nil

local function reorderTabs(t1: {[any]: any}) -- line: 67
	-- upvalues: getFixedTabPriority (ref)
	local v18 = table.clone(t1)
	local t2 = {}

	for _, v in pairs(v18) do
		table.insert(t2, v)
	end

	table.sort(t2, function(p1, p2) -- line: 75
		-- upvalues: getFixedTabPriority (ref)
		local v38 = getFixedTabPriority(p1.name)
		local v39 = getFixedTabPriority(p2.name)

		if v38 and v39 then
			return v38 < v39
		end

		if v38 then
			return true
		end

		if v39 then
			return false
		end

		return p1.tabIndex < p2.tabIndex
	end)

	for i, v in ipairs(t2) do
		v18[v.name] = {
			type = v.type,
			name = v.name,
			tabIndex = i,
			HasUnreadMessages = v.HasUnreadMessages
		}
	end

	return v18
end
local function insertTabAndReorder(t3: {[any]: any}, t4: {[any]: any}) -- line: 102
	-- upvalues: reorderTabs (copy)
	local v26 = table.clone(t3)

	v26[t4.name] = t4

	return (reorderTabs(v26))
end
local function removeTabAndReorder(t5: {[any]: any}, t6: {[any]: any}) -- line: 112
	-- upvalues: reorderTabs (copy)
	local v29 = table.clone(t5)

	v29[t6.name] = nil

	return (reorderTabs(v29))
end

function getFixedTabPriority(s1: string?) -- line: 125
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy)
	if s1 == "RBXGeneral" then
		return 1
	end

	if s1 == "RBXGlobal" and GetFFlagTextChatEnableUniverseChatTabs() then
		return 2
	end

	if s1 == "FriendsChat" and FFlagExpChatEnableFriendsTab then
		return 3
	end

	return nil
end

local function createChannelTabsStore() -- line: 136
	-- upvalues: createSignal (copy), createComputed (copy), tutils (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), reorderTabs (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), getFixedTabPriority (ref)
	local t7 = {
		selectedTabName = nil,
		allChannelTabs = {}
	}
	local v32, v33 = createSignal(t7)
	local v34 = createComputed(function(p3) -- line: 145
		-- upvalues: v32 (copy)
		return v32(p3).selectedTabName
	end)
	local v35 = createComputed(function(p4) -- line: 150
		-- upvalues: v32 (copy)
		local v42 = v32(p4)
		local t8 = {}

		for k, v in pairs(v42.allChannelTabs) do
			if v.HasUnreadMessages then
				t8[k] = true
			end
		end

		return t8
	end, tutils.deepEqual)

	return {
		getChannelTabsState = v32,
		getSelectedTabName = v34,
		getUnreadChannels = v35,
		handleIncomingOrOutgoingMessage = function(p5, b1: boolean, s2: string?) -- line: 163
			-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), v33 (copy)
			if not GetFFlagTextChatEnableUniverseChatTabs() and not p5.TextChannel or b1 then
				return
			end

			local u49 = nil

			if GetFFlagTextChatEnableUniverseChatTabs() then
				if s2 then
					u49 = s2
				else
					if not p5.TextChannel then
						return
					end

					u49 = p5.TextChannel.Name
				end
			end

			v33(function(p6) -- line: 185
				-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), p5 (copy), u49 (ref)
				local v62 = table.clone(p6)

				if not GetFFlagTextChatEnableUniverseChatTabs() then
					local TextChannel = p5.TextChannel

					if TextChannel == nil then
						return p6
					end

					u49 = TextChannel.Name
				end

				if u49 == "RBXSystem" then
					u49 = "RBXGeneral"
				end

				if v62.allChannelTabs[u49] and u49 ~= v62.selectedTabName then
					v62.allChannelTabs = table.clone(v62.allChannelTabs)

					local v64 = table.clone(v62.allChannelTabs[u49])

					v64.HasUnreadMessages = true
					v62.allChannelTabs[u49] = v64
				end

				return v62
			end)
		end,
		setSelectedTab = function(s3: string) -- line: 240
			-- upvalues: v33 (copy)
			v33(function(p7) -- line: 241
				-- upvalues: s3 (copy)
				local v72 = table.clone(p7)

				v72.selectedTabName = s3

				if v72.allChannelTabs[s3] then
					v72.allChannelTabs = table.clone(v72.allChannelTabs)

					local v73 = table.clone(v72.allChannelTabs[s3])

					v73.HasUnreadMessages = false
					v72.allChannelTabs[s3] = v73
				end

				return v72
			end)
		end,
		setTargetChannel = function(s4: string?, b2: boolean) -- line: 256
			-- upvalues: v33 (copy), reorderTabs (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
			v33(function(p8) -- line: 257
				-- upvalues: s4 (copy), b2 (copy), reorderTabs (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
				local v75 = table.clone(p8)

				if s4 and v75.allChannelTabs[s4] then
					local v76 = v75.allChannelTabs[s4]
					local t9 = {
						HasUnreadMessages = false,
						type = v76.type,
						name = v76.name,
						tabIndex = if not b2 then v76.tabIndex else 0
					}
					local allChannelTabs = v75.allChannelTabs
					local v79 = table.clone(allChannelTabs)

					v79[v76.name] = nil

					local v80 = reorderTabs(v79)
					local v81 = table.clone(v80)

					v81[t9.name] = t9
					v75.allChannelTabs = reorderTabs(v81)
					v75.selectedTabName = v76.name

					return v75
				end

				if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
					if s4 then
						v75.selectedTabName = s4

						return v75
					end

					if not GetFFlagTextChatEnableUniverseChatTabs() then
						v75.selectedTabName = nil

						return v75
					end
				else
					v75.selectedTabName = s4
				end

				return v75
			end)
		end,
		addChannelTab = function(p9, n1: number?) -- line: 297
			-- upvalues: v33 (copy), reorderTabs (copy), getFixedTabPriority (ref)
			local name = p9.name

			v33(function(p10) -- line: 300
				-- upvalues: n1 (copy), p9 (copy), name (copy), reorderTabs (copy), getFixedTabPriority (ref)
				local v83 = table.clone(p10)
				local allChannelTabs = v83.allChannelTabs

				if n1 ~= nil then
					allChannelTabs = {}

					for v85, v86 in v83.allChannelTabs do
						if v86.tabIndex >= n1 then
							local v87 = table.clone(v86)

							v87.tabIndex = v86.tabIndex + 1
							allChannelTabs[v85] = v87
						else
							allChannelTabs[v85] = v86
						end
					end
				end

				local t10 = {
					HasUnreadMessages = false,
					type = p9.type,
					name = name,
					tabIndex = n1 or 0
				}
				local v89 = table.clone(allChannelTabs)

				v89[t10.name] = t10
				v83.allChannelTabs = reorderTabs(v89)

				local v90 = getFixedTabPriority(name)
				local v91 = getFixedTabPriority(v83.selectedTabName)

				if v83.selectedTabName == nil then
					v83.selectedTabName = if not v83.allChannelTabs.RBXGeneral then name else "RBXGeneral"

					return v83
				end

				if v90 ~= nil and (v91 == nil or v90 < v91) then
					v83.selectedTabName = name
				end

				return v83
			end)
		end,
		removeChannelTab = function(s5: string) -- line: 342
			-- upvalues: v33 (copy)
			v33(function(p11) -- line: 343
				-- upvalues: s5 (copy)
				local v93 = table.clone(p11)

				v93.allChannelTabs = table.clone(v93.allChannelTabs)
				v93.allChannelTabs[s5] = nil

				if v93.selectedTabName == s5 then
					local n2 = 1e999
					local v95 = nil

					for k, v in pairs(v93.allChannelTabs) do
						if n2 > v.tabIndex then
							n2 = v.tabIndex
							v95 = k
						end
					end

					v93.selectedTabName = v95
				end

				return v93
			end)
		end,
		handleChannelRemoved = function(s6: string) -- line: 367
			-- upvalues: v33 (copy), reorderTabs (copy)
			v33(function(p12) -- line: 368
				-- upvalues: s6 (copy), reorderTabs (copy)
				local v99 = p12.allChannelTabs[s6]

				if v99 == nil then
					return p12
				end

				local v100 = table.clone(p12)
				local allChannelTabs = v100.allChannelTabs
				local v102 = table.clone(allChannelTabs)

				v102[v99.name] = nil
				v100.allChannelTabs = reorderTabs(v102)

				if v99.name == v100.selectedTabName then
					v100.selectedTabName = if not v100.allChannelTabs.RBXGeneral then nil else "RBXGeneral"
				end

				if v100.selectedTabName and v100.allChannelTabs[v100.selectedTabName] then
					v100.allChannelTabs = table.clone(v100.allChannelTabs)

					local v103 = table.clone(v100.allChannelTabs[v100.selectedTabName])

					v103.HasUnreadMessages = false
					v100.allChannelTabs[v100.selectedTabName] = v103
				end

				return v100
			end)
		end,
		markChannelUnread = function(s7: string) -- line: 212
			-- upvalues: v33 (copy)
			v33(function(p13) -- line: 213
				-- upvalues: s7 (copy)
				local v66 = table.clone(p13)

				if v66.allChannelTabs[s7] and s7 ~= v66.selectedTabName then
					v66.allChannelTabs = table.clone(v66.allChannelTabs)

					local v67 = table.clone(v66.allChannelTabs[s7])

					v67.HasUnreadMessages = true
					v66.allChannelTabs[s7] = v67
				end

				return v66
			end)
		end,
		setChannelUnreadStatus = function(s8: string, b3: boolean) -- line: 225
			-- upvalues: v33 (copy)
			v33(function(p14) -- line: 226
				-- upvalues: s8 (copy), b3 (copy)
				if p14.allChannelTabs[s8] == nil then
					return p14
				end

				local v69 = table.clone(p14)

				v69.allChannelTabs = table.clone(v69.allChannelTabs)

				local v70 = table.clone(v69.allChannelTabs[s8])

				v70.HasUnreadMessages = b3
				v69.allChannelTabs[s8] = v70

				return v69
			end)
		end
	}
end

return createChannelTabsStore
