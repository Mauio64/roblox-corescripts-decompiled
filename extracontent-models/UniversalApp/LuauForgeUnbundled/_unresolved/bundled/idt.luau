local module = require("@luauforge/bundled/idc")
local module2 = require("@luauforge/bundled/idh")
local module3 = require("@luauforge/bundled/idp")
local module4 = require("@luauforge/bundled/idq")
local module5 = require("@luauforge/bundled/ide")
local groupSidebar = require("@luauforge/bundled/ids").getGroupSidebar()

local v5 = { 0.45, 0.35, 0.3, 0.4 }

local function useTitleInset()
	local v6 = module2.Hooks.useTokens()
	return UDim.new(0, v6.Size.Size_300)
end

local function Skeleton(p2)
	local v6 = module2.Hooks.useTokens()
	local v7 = module2.Hooks.useTokens()
	local udim = UDim.new(0, v7.Size.Size_300)

	local children = {}

	for k, v8 in v5 do
		children[`Row_{k}`] = module.createElement(module2.View, {
			tag = "row align-y-center size-full-1000",
			padding = { left = udim },
			LayoutOrder = k
		}, {
			Title = module.createElement(module2.Skeleton, {
				Size = UDim2.new(v8, 0, 0, v6.Size.Size_350),
				radius = module2.Enums.Radius.Small
			})
		})
	end

	return module.createElement(
		module2.View,
		{
			tag = "col gap-xxsmall size-full-0 auto-y",
			testId = `GroupSidebar.Section.Loading.{p2.groupId}`
		},
		children
	)
end

local function Failure(props)
	local v6 = module2.Hooks.useTokens()
	local udim = UDim.new(0, v6.Size.Size_300)

	return module.createElement(module2.View, {
		tag = "col gap-small size-full-0 auto-y",
		padding = { left = udim },
		testId = `GroupSidebar.Section.Error.{props.groupId}`
	}, {
		Message = module.createElement(module2.Text, {
			Text = props.errorText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 1
		}),
		Retry = module.createElement(module2.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Button = module.createElement(module2.Button, {
				text = props.retryText or "",
				onActivated = props.onRetry,
				size = module2.Enums.InputSize.Small,
				variant = module2.Enums.ButtonVariant.Utility,
				testId = `GroupSidebar.Section.Retry.{props.groupId}`
			})
		})
	})
end

local function withoutRows(root)
	local clone = table.clone(root)
	local clone2 = table.clone(root.propSignals)
	clone2.children = nil

	if not next(clone2) then
		clone2 = nil
	end

	clone.propSignals = clone2

	local v6 = {}

	for k, v7 in root.nestedComponentConfigListPropSignalNames or {} do
		if k ~= "children" then
			v6[k] = v7
		end
	end

	if not next(v6) then
		v6 = nil
	end

	clone.nestedComponentConfigListPropSignalNames = v6
	return clone
end

local function Rows(props)
	local v6 = module.useContext(groupSidebar.Context)
	assert(v6, "Community rows require their page provider")
	local formatted = `forums:{props.groupId}`
	local root = props.root
	local children = root.propSignals.children
	local v7 = module.useMemo(function()
		return withoutRows(root)
	end, { root })
	local v8 = module.useMemo(function()
		return module3.createComputed(function(p2)
			return children(p2).data or {}
		end)
	end, { children })
	local v9 = module4.useSignalState(v8)
	local v10 = module.useMemo(function()
		return module3.createComputed(function(p2)
			return v6.expanded(p2)[formatted]
		end)
	end, { v6, formatted })
	local v11 = module4.useSignalState(v10)
	local v12 = module.useCallback(function(p2)
		v6.setExpanded(formatted, p2)
	end, { v6, formatted })
	local v13 = module.useMemo(function()
		local children2 = {}

		for k, v14 in v9 do
			local v15

			if v14.nestedComponentConfigListPropSignalNames == nil then
				v15 = false
			else
				v15 = v14.nestedComponentConfigListPropSignalNames.children == true
			end

			local formatted2 = `children_{k}_{v14.componentType}`
			local createElement = module.createElement
			local sduiComponentWrapper = module5.getSduiComponentWrapper(v14)
			local v16 = {
				componentConfig = v14,
				sduiContext = props.sduiContext,
				extraLocalProps = 0,
				debugName = 0
			}
			local v17

			if v15 then
				v17 = { layoutOrder = k, isExpanded = 0, onExpandedChanged = 0 }

				local v18 = if v11 == nil then not (v14.props == nil) and v14.props.initiallyExpanded == true else v11
				v17.isExpanded = v18

				v17.onExpandedChanged = v12
			else
				v17 = { layoutOrder = k }
			end

			v16.extraLocalProps = v17

			v16.debugName = `GroupSidebar.Section.{props.groupId}.children[{k}]`
			children2[formatted2] = createElement(sduiComponentWrapper, v16)
		end

		return children2
	end, { v9, v11, v12, props.sduiContext, props.groupId })
	return module.createElement(module5.getSduiComponentWrapper(v7), {
		componentConfig = v7,
		sduiContext = props.sduiContext,
		extraLocalProps = { children = v13 }
	})
end

local function GroupSidebarSectionContent(props)
	local v6 = groupSidebar.useSection(props.sduiContext, props.groupId)

	local root = v6.root

	if root and root.propSignals and root.propSignals.children then
		return module.createElement(Rows, {
			root = root,
			sduiContext = props.sduiContext,
			groupId = props.groupId
		})
	end

	if root then
		return module.createElement(module5.getSduiComponentWrapper(root), {
			componentConfig = root,
			sduiContext = props.sduiContext
		})
	end

	if v6.status == "Ready" then
		return nil
	end

	if v6.status == "Failed" then
		return module.createElement(Failure, {
			sduiContext = props.sduiContext,
			groupId = props.groupId,
			errorText = props.errorText,
			retryText = props.retryText,
			onRetry = v6.retry
		})
	end

	return module.createElement(Skeleton, { groupId = props.groupId })
end

return module.memo(GroupSidebarSectionContent)
