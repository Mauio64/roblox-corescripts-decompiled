local parent = script:FindFirstAncestor("Groups").Parent
local Signals = require(parent.Signals)

local function createGroupSidebarState(groupId: string?, p)
	local function overview(groupId2: string?) -- 2 equivalent calls inferred from this helper
		if groupId2 then
			return { groupId = groupId2, section = "overview" }
		end

		return nil
	end

	local signal, v = Signals.createSignal(overview(groupId)) -- inferred equivalent call

	local signal2, v2 = Signals.createSignal(not p and {} or table.clone(p))
	local signal3, v3 = Signals.createSignal({})
	local signal4, v4 = Signals.createSignal(0)
	local v5 = {}
	return {
		activeDestination = signal,
		selectedGroupId = function(p2)
			local v2 = signal(p2)
			return if v2 then v2.groupId else nil
		end,
		selectGroup = function(groupId2: string?)
			v(overview(groupId2)) -- inferred equivalent call
		end,
		expanded = signal2,
		hasEntryExpansion = p ~= nil,
		setSectionFrame = function(p2: string, p3)
			v5[p2] = p3
		end,
		getSectionFrame = function(p2: string)
			return v5[p2]
		end,
		isVisiting = function(p2: string, p3): boolean
			return signal3(p3)[p2] == true
		end,
		setVisitingGroups = function(items)
			local set = {}

			for _, item in items do
				set[item] = true
			end

			v3(set)
		end,
		sectionRefreshCount = signal4,
		refreshSections = function()
			v4(signal4(false) + 1)
		end,
		setExpanded = function(p2: string, flag: boolean)
			local clone = table.clone(signal2(false))
			clone[p2] = flag
			v2(clone)
		end
	}
end

return createGroupSidebarState
