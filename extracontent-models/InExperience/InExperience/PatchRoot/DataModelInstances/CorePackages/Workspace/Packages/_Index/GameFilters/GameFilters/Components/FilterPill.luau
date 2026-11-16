local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
require(parent.DiscoveryTypes)
local Foundation = require(parent.Foundation)
local IconPosition = Foundation.Enums.IconPosition
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local Chip = Foundation.Chip
local React = require(parent.React)

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens

local FilterClickButtonName = require(GameFilters.Analytics.FilterClickButtonName)
require(GameFilters.Components.Menu.FilterMenuDropdown)
local OpenFilterMenuPeekView = require(GameFilters.OpenFilterMenuPeekView)
local shouldUsePeekView = require(GameFilters.Components.Menu.shouldUsePeekView)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag
require(GameFilters.FilterCallbackTypes)

return React.memo(function(props)
	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v = useDispatch()
	local v2 = useTokens()

	local isChecked = React.useMemo(function(): boolean
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
		ImpressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)

		return function()
			ImpressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local sendFilterClick = React.useCallback(
		function(p: string, p2: string, p3: string?, p4: string?, p5: string?, flag: boolean?)
			props.sendFilterClick(p, props.filter.filterId, p2, p3, p4, p5, flag)
		end,
		{ props.sendFilterClick, props.filter.filterId }
	)

	local v3 = shouldUsePeekView()
	local onFilterMenuClosed = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated = React.useCallback(function()
		local v4

		if FFlagLuaAppChartsFilterOptionTextTag then
			v4 = getOptionContextTag(props.filter, props.filter.selectedOptionId)
		end

		if v3 then
			v(OpenFilterMenuPeekView(props.filter, props.onFilterApplied, onFilterMenuClosed, sendFilterClick))

			local openPeekView = FilterClickButtonName.OpenPeekView
			local selectedOptionId = props.filter.selectedOptionId

			if not FFlagLuaAppChartsFilterOptionTextTag then
				v4 = nil
			end

			sendFilterClick(openPeekView, selectedOptionId, nil, v4, nil, isChecked)
		else
			local openPosition

			if ref.current then
				openPosition = Vector2.new(
					ref.current.AbsolutePosition.X,
					ref.current.AbsolutePosition.Y + ref.current.AbsoluteSize.Y + v2.Gap.Small
				)
			end

			local v5 = {
				openPosition = openPosition,
				filter = props.filter,
				onFilterApplied = props.onFilterApplied,
				onFilterMenuClosed = onFilterMenuClosed,
				sendFilterClick = sendFilterClick
			}

			v(SetCentralOverlay(CentralOverlayType.GameFilterMenuDropdown, v5))

			local openDropdown = FilterClickButtonName.OpenDropdown
			local selectedOptionId = props.filter.selectedOptionId

			if not FFlagLuaAppChartsFilterOptionTextTag then
				v4 = nil
			end

			sendFilterClick(openDropdown, selectedOptionId, nil, v4, nil, isChecked)
		end

		setState(true)
	end, { props.filter, props.onFilterApplied, onFilterMenuClosed, sendFilterClick, v3, isChecked })

	return React.createElement(Chip, {
		icon = { name = "icons/actions/truncationExpand_small", position = IconPosition.Right },
		text = props.filter.selectedOptionDisplayName,
		isChecked = isChecked,
		onActivated = onActivated,
		ref = ref
	})
end)
