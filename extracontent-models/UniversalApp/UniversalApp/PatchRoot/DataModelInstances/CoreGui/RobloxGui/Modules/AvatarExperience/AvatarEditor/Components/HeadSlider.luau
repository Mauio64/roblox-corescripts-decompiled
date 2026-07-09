local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local tutils = require(CorePackages.Packages.tutils)
local useBodyDataCallbacksContext = require(Modules.AvatarExperience.Common.Context.useBodyDataCallbacksContext)
local mutedError = require(Modules.LuaApp.mutedError)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local SystemSlider = require(CorePackages.Packages.UIBlox).App.Slider.SystemSlider

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMakeSlidersSmoothWithGamepad = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMakeSlidersSmoothWithGamepad

local function selectHeadState(p1) -- line: 37
	-- upvalues: Constants (copy)
	return {
		avatarType = p1.AvatarExperience.AvatarEditor.Character.AvatarType,
		head = p1.AvatarExperience.AvatarEditor.Character.AvatarScales.head,
		headScaleRules = p1.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules].head
	}
end

local u17 = nil
local u18 = nil

if FFlagAXMigrateSystemSliderToFoundationSlider then
	function u17(n1: number, n2: number, n3: number) -- line: 48
		-- upvalues: mutedError (copy)
		if n3 <= n2 then
			mutedError("HeadSlider.lua convertHeadValueToSliderValue argument error: headMaxVal must be greater than headMinVal.")

			return 0.5
		end

		return (n1 - n2) / (n3 - n2)
	end
	function u18(n4: number, n5: number, n6: number) -- line: 58
		return n4 * (n6 - n5) + n5
	end
end

local function HeadSlider(t1: {[any]: any}, p2) -- line: 63
	-- upvalues: useSelector (copy), selectHeadState (copy), tutils (copy), useDispatch (copy), useBodyDataCallbacksContext (copy), Constants (copy), React (copy), FFlagAXMigrateSystemSliderToFoundationSlider (copy), u18 (ref), SetAvatarScales (copy), Foundation (copy), u17 (ref), FFlagAXMakeSlidersSmoothWithGamepad (copy), SystemSlider (copy)
	local v29 = useSelector(selectHeadState, tutils.deepEqual)
	local v30 = useDispatch()
	local v31 = useBodyDataCallbacksContext()
	local avatarType = v29.avatarType
	local head = v29.head
	local headScaleRules = v29.headScaleRules
	local v35 = t1.isDisabled or avatarType == Constants.AvatarType.R6
	local v36, v37 = React.useState({
		head = head
	})
	local v38 = if not FFlagAXMigrateSystemSliderToFoundationSlider then React.useCallback(function(n7: number) -- line: 83
		-- upvalues: v31 (copy), v37 (copy)
		v31.setAvatarScales({
			head = n7
		})
		v37({
			head = n7
		})
	end, {
		v31,
		headScaleRules
	}) else React.useCallback(function(n8: number) -- line: 78
		-- upvalues: u18 (ref), headScaleRules (copy), v31 (copy), v37 (copy)
		local v42 = u18(n8, headScaleRules.min, headScaleRules.max)

		v31.setAvatarScales({
			head = v42
		})
		v37({
			head = v42
		})
	end, { v31 })
	local v39 = React.useCallback(function() -- line: 88
		-- upvalues: t1 (copy)
		if t1.lockNavigationCallback then
			t1.lockNavigationCallback()
		end
	end, { t1.lockNavigationCallback })
	local v40 = React.useCallback(function() -- line: 94
		-- upvalues: t1 (copy), v31 (copy), v30 (copy), SetAvatarScales (copy), v36 (copy)
		if t1.unlockNavigationCallback then
			t1.unlockNavigationCallback()
		end

		v31.setAvatarScales(nil)
		v30(SetAvatarScales({
			head = v36.head
		}))
	end, {
		t1.unlockNavigationCallback,
		v36,
		v31,
		v30
	})

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		return React.createElement(Foundation.Slider, {
			LayoutOrder = t1.LayoutOrder,
			range = NumberRange.new(0, 1),
			value = u17(v36.head, headScaleRules.min, headScaleRules.max),
			onValueChanged = v38,
			onDragStarted = v39,
			onDragEnded = v40,
			isDisabled = v35,
			NextSelectionUp = t1.NextSelectionUp,
			NextSelectionDown = t1.NextSelectionDown,
			ref = p2,
			step = if not FFlagAXMakeSlidersSmoothWithGamepad then nil else 0.01
		})
	end

	return React.createElement(SystemSlider, {
		layoutOrder = t1.LayoutOrder,
		min = headScaleRules.min,
		max = headScaleRules.max,
		stepInterval = headScaleRules.increment,
		value = v36.head,
		onValueChanged = v38,
		onDragStart = v39,
		onDragEnd = v40,
		isDisabled = v35,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		ref = p2
	})
end

return React.memo(React.forwardRef(HeadSlider))
