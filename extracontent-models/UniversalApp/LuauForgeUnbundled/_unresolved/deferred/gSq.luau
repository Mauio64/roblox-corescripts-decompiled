local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local tutils = require(CorePackages.Packages.tutils)
local module = require("@luauforge/deferred/gOI")
local module2 = require("@luauforge/bundled/dCn")

local module3 = require("@luauforge/bundled/dNQ")
local module4 = require("@luauforge/bundled/dNS")
local UIBlox = require(CorePackages.Packages.UIBlox)
local systemSlider = UIBlox.App.Slider.SystemSlider
require("@luauforge/bundled/dHK")

local fFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider
local fFlagAXMakeSlidersSmoothWithGamepad = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMakeSlidersSmoothWithGamepad
local defineFastFlag = game:DefineFastFlag("AXFixVRHeadSliderSoftlock", false)
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local function selectHeadState(p2)
	return {
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		head = p2.AvatarExperience.AvatarEditor.Character.AvatarScales.head,
		headScaleRules = p2.AvatarExperience.AvatarEditor.AvatarSettings[module3.AvatarSettings.scalesRules].head
	}
end

local fn, fn2

if fFlagAXMigrateSystemSliderToFoundationSlider then
	fn = function(p2, p3, p4)
		return p2 * (p4 - p3) + p3
	end

	fn2 = function(p2, p3, p4)
		if p4 <= p3 then
			module2("HeadSlider.lua convertHeadValueToSliderValue argument error: headMaxVal must be greater than headMinVal.")

			return 0.5
		end

		return (p2 - p3) / (p4 - p3)
	end
else
	fn = nil
	fn2 = nil
end

local function HeadSlider(props, p2)
	local v5 = useSelector(selectHeadState, tutils.deepEqual)
	local v6 = useDispatch()
	local v7 = module()
	local v8 = if defineFastFlag then useIsSpatial() else nil

	local avatarType = v5.avatarType
	local head = v5.head
	local headScaleRules = v5.headScaleRules
	local isDisabled = props.isDisabled or avatarType == module3.AvatarType.R6

	local state, setState = React.useState({ head = head })
	local v9

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		v9 = React.useCallback(function(p3)
			local v10 = fn(p3, headScaleRules.min, headScaleRules.max)
			v7.setAvatarScales({ head = v10 })
			setState({ head = v10 })
		end, { v7 })
	else
		v9 = React.useCallback(function(p3)
			v7.setAvatarScales({ head = p3 })
			setState({ head = p3 })
		end, { v7, headScaleRules })
	end

	local function fn3()
		if props.lockNavigationCallback and not (defineFastFlag and v8) then
			props.lockNavigationCallback()
		end
	end

	local v12 = React.useCallback(fn3, { props.lockNavigationCallback, if defineFastFlag then v8 else nil })

	local function fn4()
		if props.unlockNavigationCallback and not (defineFastFlag and v8) then
			props.unlockNavigationCallback()
		end

		v7.setAvatarScales(nil)

		v6(module4({ head = state.head }))
	end

	local v15 = React.useCallback(fn4, {
		props.unlockNavigationCallback,
		state,
		v7,
		v6,
		if defineFastFlag then v8 else nil
	})

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		return React.createElement(Foundation.Slider, {
			LayoutOrder = props.LayoutOrder,
			range = NumberRange.new(0, 1),
			value = fn2(state.head, headScaleRules.min, headScaleRules.max),
			onValueChanged = v9,
			onDragStarted = v12,
			onDragEnded = v15,
			isDisabled = isDisabled,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			ref = p2,
			step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
		})
	end

	return React.createElement(systemSlider, {
		layoutOrder = props.LayoutOrder,
		min = headScaleRules.min,
		max = headScaleRules.max,
		stepInterval = headScaleRules.increment,
		value = state.head,
		onValueChanged = v9,
		onDragStart = v12,
		onDragEnd = v15,
		isDisabled = isDisabled,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		ref = p2
	})
end

return React.memo(React.forwardRef(HeadSlider))
