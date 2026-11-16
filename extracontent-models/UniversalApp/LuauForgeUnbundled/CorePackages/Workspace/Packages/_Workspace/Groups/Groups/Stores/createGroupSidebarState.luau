local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Signals")

local function createGroupSidebarState(p2, p3)
	local function overview(p4)
		if p4 then
			return { groupId = p4, section = "overview" }
		end

		return nil
	end
	local signal, v5 = Signals.createSignal(p2 and { groupId = p2, section = "overview" } or nil)

	local signal2, v6 = Signals.createSignal(not p3 and {} or table.clone(p3))
	local signal3, v7 = Signals.createSignal({})
	local signal4, v8 = Signals.createSignal(0)
	local v9 = {}
	return {
		activeDestination = signal,
		selectedGroupId = function(p4)
			local v6 = signal(p4)

			if v6 then
				return v6.groupId
			end

			return nil
		end,
		selectGroup = function(p4)
			v5(p4 and { groupId = p4, section = "overview" } or nil)
		end,
		expanded = signal2,
		hasEntryExpansion = p3 ~= nil,
		setSectionFrame = function(p4, p5)
			v9[p4] = p5
		end,
		getSectionFrame = function(p4)
			return v9[p4]
		end,
		isVisiting = function(p4, p5): boolean
			return signal3(p5)[p4] == true
		end,
		setVisitingGroups = function(items)
			local set = {}

			for k, item in items do
				set[item] = true
			end

			v7(set)
		end,
		sectionRefreshCount = signal4,
		refreshSections = function()
			v8(signal4(false) + 1)
		end,
		setExpanded = function(p4, p5)
			local clone = table.clone(signal2(false))
			clone[p4] = p5
			v6(clone)
		end
	}
end

return createGroupSidebarState
