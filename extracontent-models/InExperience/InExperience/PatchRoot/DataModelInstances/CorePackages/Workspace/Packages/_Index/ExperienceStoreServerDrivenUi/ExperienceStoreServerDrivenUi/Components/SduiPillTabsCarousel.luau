local parent = script:FindFirstAncestor("ExperienceStoreServerDrivenUi").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiLocalFeedFilter = SharedFlags.FFlagSduiLocalFeedFilter
local Foundation = require(parent.Foundation)
local Chip = Foundation.Chip
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local ChipSize = Foundation.Enums.ChipSize
local Visibility = Foundation.Enums.Visibility

local scroll = {
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	AutomaticSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.fromScale(0, 0),
	ScrollingDirection = Enum.ScrollingDirection.X,
	scrollBarVisibility = Visibility.None
}

local selection = { Selectable = false }

local function PillTab(props)
	local optionId = props.optionId
	local onSelect = props.onSelect

	local onActivated = React.useCallback(function()
		onSelect(optionId)
	end, { onSelect, optionId })

	return React.createElement(Chip, {
		text = props.displayName,
		isChecked = props.isChecked,
		size = props.chipSize,
		LayoutOrder = props.layoutOrder,
		onActivated = onActivated
	})
end

local memo = React.memo(PillTab)

local function SduiPillTabsCarousel(props)
	local options = props.options
	local onOptionActivated = props.onOptionActivated
	local chipSize = props.chipSize or ChipSize.Medium

	local v = props.selectedOption

	if FFlagSduiLocalFeedFilter then
		if v == nil or v == "" then
			v = props.defaultOption
		end
	else
		v = (v == nil or v == "") and "all" or v
	end

	local ref = React.useRef(onOptionActivated)
	React.useEffect(function()
		ref.current = onOptionActivated
	end, { onOptionActivated })

	React.useEffect(function()
		local defaultOption = props.defaultOption

		local current = FFlagSduiLocalFeedFilter
			and (props.selectedOption == nil or props.selectedOption == "")
			and defaultOption ~= nil
			and defaultOption ~= ""
			and ref.current

		if current then
			current(nil, nil, { selectedCategoryId = defaultOption })
		end
	end, { props.defaultOption, props.selectedOption })

	local onSelect = React.useCallback(function(selectedCategoryId: string)
		local current = ref.current

		if current then
			current(nil, nil, { selectedCategoryId = selectedCategoryId })
		end
	end, {})

	local v2 = React.useMemo(function()
		local children = {}

		if not options then
			return children
		end

		for k, option in options do
			local optionId = option.optionId
			children["Pill_" .. optionId] = React.createElement(memo, {
				optionId = optionId,
				displayName = option.displayName,
				isChecked = optionId == v,
				chipSize = chipSize,
				layoutOrder = k,
				onSelect = onSelect
			})
		end

		return children
	end, { options, v, onSelect, chipSize })

	local tag = React.useMemo(function()
		local v3 = { ["size-full-0 auto-y"] = true }

		if props.tag then
			v3[props.tag] = true
		end

		return v3
	end, { props.tag })

	if options and #options ~= 0 then
		return React.createElement(
			ScrollView,
			{ LayoutOrder = props.layoutOrder, tag = tag, scroll = scroll, selection = selection },
			{
				Row = React.createElement(View, { tag = "row gap-small auto-xy" }, v2)
			}
		)
	end

	return nil
end

return React.memo(SduiPillTabsCarousel)
