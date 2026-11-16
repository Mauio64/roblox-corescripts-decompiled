local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/React")
local fFlagSduiLocalFeedFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiLocalFeedFilter
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Foundation")
local chip = Foundation.Chip
local scrollView = Foundation.ScrollView
local view = Foundation.View
local chipSize = Foundation.Enums.ChipSize
local visibility = Foundation.Enums.Visibility

local v5 = {
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	AutomaticSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.fromScale(0, 0),
	ScrollingDirection = Enum.ScrollingDirection.X,
	scrollBarVisibility = visibility.None
}

local v6 = { Selectable = false }

local function PillTab(props)
	local optionId = props.optionId
	local onSelect = props.onSelect

	local v7 = React.useCallback(function()
		onSelect(optionId)
	end, { onSelect, optionId })

	return React.createElement(chip, {
		text = props.displayName,
		isChecked = props.isChecked,
		size = props.chipSize,
		LayoutOrder = props.layoutOrder,
		onActivated = v7
	})
end

local memo = React.memo(PillTab)

local function SduiPillTabsCarousel(props)
	local options = props.options
	local onOptionActivated = props.onOptionActivated
	local chipSize2 = props.chipSize or chipSize.Medium

	local v7 = props.selectedOption

	if fFlagSduiLocalFeedFilter then
		if v7 == nil or v7 == "" then
			v7 = props.defaultOption
		end
	else
		v7 = (v7 == nil or v7 == "") and "all" or v7
	end

	local ref = React.useRef(onOptionActivated)
	React.useEffect(function()
		ref.current = onOptionActivated
	end, { onOptionActivated })

	React.useEffect(function()
		local defaultOption = props.defaultOption

		local current = fFlagSduiLocalFeedFilter
			and (props.selectedOption == nil or props.selectedOption == "")
			and defaultOption ~= nil
			and defaultOption ~= ""
			and ref.current

		if current then
			current(nil, nil, { selectedCategoryId = defaultOption })
		end
	end, { props.defaultOption, props.selectedOption })

	local v8 = React.useCallback(function(p2)
		local current = ref.current

		if current then
			current(nil, nil, { selectedCategoryId = p2 })
		end
	end, {})

	local v9 = React.useMemo(function()
		local children = {}

		if not options then
			return children
		end

		for k, option in options do
			local optionId = option.optionId
			children["Pill_" .. optionId] = React.createElement(memo, {
				optionId = optionId,
				displayName = option.displayName,
				isChecked = optionId == v7,
				chipSize = chipSize2,
				layoutOrder = k,
				onSelect = v8
			})
		end

		return children
	end, { options, v7, v8, chipSize2 })

	local v10 = React.useMemo(function()
		local v11 = { ["size-full-0 auto-y"] = true }

		if props.tag then
			v11[props.tag] = true
		end

		return v11
	end, { props.tag })

	if options and #options ~= 0 then
		return React.createElement(
			scrollView,
			{ LayoutOrder = props.layoutOrder, tag = v10, scroll = v5, selection = v6 },
			{
				Row = React.createElement(view, { tag = "row gap-small auto-xy" }, v9)
			}
		)
	end

	return nil
end

return React.memo(SduiPillTabsCarousel)
