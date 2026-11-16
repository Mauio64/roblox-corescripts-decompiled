require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local iconPosition = Foundation.Enums.IconPosition
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Impressions").ImpressionsTagUtility
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppEnums").CentralOverlayType
local chip = Foundation.Chip
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")

local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/CentralOverlay").Actions.SetCentralOverlay

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RoactUtils").Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens

local FilterClickButtonName = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/FilterClickButtonName")
require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/FilterMenuDropdown")
local OpenFilterMenuPeekView = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/OpenFilterMenuPeekView")
local shouldUsePeekView = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/Menu/shouldUsePeekView")
local getOptionContextTag = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/getOptionContextTag")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag
require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/FilterCallbackTypes")

return React.memo(function(props)
	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v6 = useDispatch()
	local v7 = useTokens()

	local v8 = React.useMemo(function(): boolean
		if props.filter.inactiveOptionIds == nil or props.filter.selectedOptionId == nil then
			return false
		end

		return not props.filter.inactiveOptionIds[props.filter.selectedOptionId]
	end, { props.filter.selectedOptionId, props.filter.inactiveOptionIds }) or state
	React.useEffect(function()
		local absoluteSizeChangedConnection

		if ref.current then
			absoluteSizeChangedConnection = ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				props.onAbsoluteSizeChanged(ref.current)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { props.onAbsoluteSizeChanged })

	React.useEffect(function()
		impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)

		return function()
			impressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local v9 = React.useCallback(function(p2, p3, p4, p5, p6, p7)
		props.sendFilterClick(p2, props.filter.filterId, p3, p4, p5, p6, p7)
	end, { props.sendFilterClick, props.filter.filterId })

	local v10 = shouldUsePeekView()
	local v11 = React.useCallback(function()
		setState(false)
	end, {})

	local v12 = React.useCallback(function()
		local v13

		if fFlagLuaAppChartsFilterOptionTextTag then
			v13 = getOptionContextTag(props.filter, props.filter.selectedOptionId)
		end

		if v10 then
			v6(OpenFilterMenuPeekView(props.filter, props.onFilterApplied, v11, v9))

			local openPeekView = FilterClickButtonName.OpenPeekView
			local selectedOptionId = props.filter.selectedOptionId

			if not fFlagLuaAppChartsFilterOptionTextTag then
				v13 = nil
			end

			v9(openPeekView, selectedOptionId, nil, v13, nil, v8)
		else
			local v15 = {
				openPosition = if ref.current then Vector2.new(
					ref.current.AbsolutePosition.X,
					ref.current.AbsolutePosition.Y + ref.current.AbsoluteSize.Y + v7.Gap.Small
				) else nil,
				filter = props.filter,
				onFilterApplied = props.onFilterApplied,
				onFilterMenuClosed = v11,
				sendFilterClick = v9
			}

			v6(setCentralOverlay(centralOverlayType.GameFilterMenuDropdown, v15))

			local openDropdown = FilterClickButtonName.OpenDropdown
			local selectedOptionId = props.filter.selectedOptionId

			if not fFlagLuaAppChartsFilterOptionTextTag then
				v13 = nil
			end

			v9(openDropdown, selectedOptionId, nil, v13, nil, v8)
		end

		setState(true)
	end, { props.filter, props.onFilterApplied, v11, v9, v10, v8 })

	return React.createElement(chip, {
		icon = {
			name = "icons/actions/truncationExpand_small",
			position = iconPosition.Right
		},
		text = props.filter.selectedOptionDisplayName,
		isChecked = v8,
		onActivated = v12,
		ref = ref
	})
end)
