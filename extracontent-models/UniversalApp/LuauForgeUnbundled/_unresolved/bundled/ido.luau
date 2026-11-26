local module = require("@luauforge/bundled/idc")
local module2 = require("@luauforge/bundled/idh")
local module3 = require("@luauforge/bundled/idp")
local module4 = require("@luauforge/bundled/idq")
local module5 = require("@luauforge/bundled/ide")
local module6 = require("@luauforge/bundled/idr")
local groupSidebar = require("@luauforge/bundled/ids").getGroupSidebar()
local module7 = require("@luauforge/bundled/idt")

local function SduiGroupSection(props)
	local v5 = module.useContext(groupSidebar.Context)
	assert(v5, "Community section requires its page provider")
	local formatted = `group:{props.groupId}`
	local configKey = props.sduiContext.configKey
	local v6 = module.useMemo(function()
		return module3.createComputed(function(p2)
			local v7 = v5.expanded(p2)[formatted]

			if v7 ~= nil then
				return v7
			end

			if v5.hasEntryExpansion or not configKey then
				return false
			end

			local inputData = module6.getSduiApiStore().getInputData(configKey, "groupSidebar", p2)
			return inputData ~= nil and inputData.initially_expanded_group_id == props.groupId
		end)
	end, { v5, formatted, configKey, props.groupId })
	local v7 = module4.useSignalState(v6)
	local v8 = module.useMemo(function()
		return module3.createComputed(function(p2)
			return v5.isVisiting(props.groupId, p2)
		end)
	end, { v5, props.groupId })
	local v9 = module4.useSignalState(v8)

	local v10 = module.useMemo(function()
		return module3.createComputed(function(p2)
			local activeDestination = v5.activeDestination(p2)

			if activeDestination then
				return activeDestination.groupId == props.groupId
			end

			return v5.isVisiting(props.groupId, p2)
		end)
	end, { v5, props.groupId })
	local v11 = module4.useSignalState(v10)
	local v12 = module.useCallback(function(p2)
		v5.setExpanded(formatted, p2)
	end, { v5, formatted })
	local v13 = module.useCallback(function(p2)
		v5.setSectionFrame(props.groupId, p2)
	end, { v5, props.groupId })
	local expandableList = props.expandableList

	local v14 = module.useMemo(function()
		return {
			Section = module.createElement(module7, {
				sduiContext = props.sduiContext,
				groupId = props.groupId,
				errorText = props.errorText,
				retryText = props.retryText
			})
		}
	end, { props.sduiContext, props.groupId, props.errorText, props.retryText })

	local createElement = module.createElement
	local view = module2.View
	local v15 = {
		tag = {
			["col size-full-0 auto-y radius-medium"] = true,
			["padding-y-large"] = v9
		},
		LayoutOrder = props.layoutOrder,
		testId = props.testId or `GroupSidebar.Section.{props.groupId}`,
		ref = v13
	}

	local v17 = if expandableList then module.createElement(
		module5.getSduiComponentWrapper(expandableList),
		{
			componentConfig = expandableList,
			sduiContext = props.sduiContext,
			extraLocalProps = {
				isExpanded = v7,
				onExpandedChanged = v12,
				isSelected = v11,
				size = groupSidebar.listSize,
				children = v14
			}
		}
	) else nil
	return createElement(view, v15, { List = v17 })
end

return module.memo(SduiGroupSection)
