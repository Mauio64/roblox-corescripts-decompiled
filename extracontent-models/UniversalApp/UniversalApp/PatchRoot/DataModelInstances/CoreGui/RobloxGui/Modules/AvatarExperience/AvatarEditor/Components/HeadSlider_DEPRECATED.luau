local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UIBlox = require(CorePackages.Packages.UIBlox)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local mutedError = require(Modules.LuaApp.mutedError)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMakeSlidersSmoothWithGamepad = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMakeSlidersSmoothWithGamepad
local SystemSlider = UIBlox.App.Slider.SystemSlider
local v18 = Roact.PureComponent:extend("HeadSlider")

function v18.init(p1) -- line: 30
	-- upvalues: Roact (copy), FFlagAXMigrateSystemSliderToFoundationSlider (copy), mutedError (copy)
	p1.moveListen = nil
	p1.endListen = nil
	p1.scaleRef = Roact.createRef()

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		function p1.convertHeadValueToSliderValue(n1: number, n2: number, n3: number) -- line: 37
			-- upvalues: mutedError (copy)
			if n3 <= n2 then
				mutedError("HeadSlider_DEPRECATED.lua convertHeadValueToSliderValue argument error: headMaxVal must be greater than headMinVal.")

				return 0.5
			end

			return (n1 - n2) / (n3 - n2)
		end
		function p1.convertSliderValueToHeadValue(n4: number, n5: number, n6: number) -- line: 47
			return n4 * (n6 - n5) + n5
		end
	end
end
function v18.render(p2) -- line: 53
	-- upvalues: FFlagAXMigrateSystemSliderToFoundationSlider (copy), Roact (copy), Foundation (copy), Constants (copy), FFlagAXMakeSlidersSmoothWithGamepad (copy), SystemSlider (copy)
	local avatarType = p2.props.avatarType
	local head = p2.props.head
	local headScaleRules = p2.props.headScaleRules
	local propsLayoutOrder = p2.props.LayoutOrder
	local forwardRef = p2.props.forwardRef

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		return Roact.createElement(Foundation.Slider, {
			LayoutOrder = propsLayoutOrder,
			range = NumberRange.new(0, 1),
			value = p2.convertHeadValueToSliderValue(head, headScaleRules.min, headScaleRules.max),
			onValueChanged = function(p3) -- line: 66
				-- upvalues: p2 (copy), headScaleRules (copy)
				local v42 = p2.convertSliderValueToHeadValue(p3, headScaleRules.min, headScaleRules.max)

				p2.props.setScales({
					head = v42
				})
			end,
			onDragStarted = p2.props.lockNavigationCallback,
			onDragEnded = p2.props.unlockNavigationCallback,
			isDisabled = avatarType == Constants.AvatarType.R6,
			NextSelectionUp = p2.props.NextSelectionUp,
			NextSelectionDown = p2.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			step = if not FFlagAXMakeSlidersSmoothWithGamepad then nil else 0.01
		})
	end

	return Roact.createElement(SystemSlider, {
		layoutOrder = propsLayoutOrder,
		min = headScaleRules.min,
		max = headScaleRules.max,
		stepInterval = headScaleRules.increment,
		value = head,
		onValueChanged = function(p4) -- line: 89
			-- upvalues: p2 (copy)
			p2.props.setScales({
				head = p4
			})
		end,
		onDragStart = p2.props.lockNavigationCallback,
		onDragEnd = p2.props.unlockNavigationCallback,
		isDisabled = avatarType == Constants.AvatarType.R6,
		NextSelectionUp = p2.props.NextSelectionUp,
		NextSelectionDown = p2.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	})
end

local v19 = RoactServices.connect({
	analytics = Analytics
})(v18)

local function mapStateToProps(p5, _) -- line: 108
	-- upvalues: Constants (copy)
	return {
		avatarType = p5.AvatarExperience.AvatarEditor.Character.AvatarType,
		head = p5.AvatarExperience.AvatarEditor.Character.AvatarScales.head,
		headScaleRules = p5.AvatarExperience.AvatarEditor.AvatarSettings[Constants.AvatarSettings.scalesRules].head
	}
end
local function mapDispatchToProps(p7) -- line: 116
	-- upvalues: SetAvatarScales (copy), SendAnalytics (copy), SetCurrentToastMessage (copy)
	return {
		setScales = function(p8) -- line: 118
			-- upvalues: p7 (copy), SetAvatarScales (copy)
			p7(SetAvatarScales(p8))
		end,
		sendAnalytics = function(p9, p10) -- line: 121
			-- upvalues: p7 (copy), SendAnalytics (copy)
			p7(SendAnalytics(p9, p10))
		end,
		setCurrentToastMessage = function(p11) -- line: 124
			-- upvalues: p7 (copy), SetCurrentToastMessage (copy)
			p7(SetCurrentToastMessage(p11))
		end
	}
end

local u22 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v19)

return Roact.forwardRef(function(p12, p13) -- line: 132
	-- upvalues: Roact (copy), u22 (ref), Cryo (copy)
	return Roact.createElement(u22, Cryo.Dictionary.join(p12, {
		forwardRef = p13
	}))
end)
