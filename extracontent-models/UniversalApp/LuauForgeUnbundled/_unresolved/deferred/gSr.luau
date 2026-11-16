local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/geT")
local module2 = require("@luauforge/bundled/dCn")

local module3 = require("@luauforge/bundled/dNQ")
local module4 = require("@luauforge/bundled/dNS")
local module5 = require("@luauforge/deferred/gOC")
require("@luauforge/bundled/dHK")

local module6 = require("@luauforge/bundled/dCh")

local fFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider
local fFlagAXMakeSlidersSmoothWithGamepad = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMakeSlidersSmoothWithGamepad

local systemSlider = UIBlox.App.Slider.SystemSlider

local extended = Roact.PureComponent:extend("HeadSlider")

function extended:init()
	self.moveListen = nil
	self.endListen = nil

	self.scaleRef = Roact.createRef()

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		function self.convertHeadValueToSliderValue(p3, p4, p5)
			if p5 <= p4 then
				module2("HeadSlider_DEPRECATED.lua convertHeadValueToSliderValue argument error: headMaxVal must be greater than headMinVal.")

				return 0.5
			end

			return (p3 - p4) / (p5 - p4)
		end

		function self.convertSliderValueToHeadValue(p3, p4, p5)
			return p3 * (p5 - p4) + p4
		end
	end
end

function extended.render(props)
	local avatarType = props.props.avatarType
	local head = props.props.head
	local headScaleRules = props.props.headScaleRules
	local layoutOrder = props.props.LayoutOrder

	local forwardRef = props.props.forwardRef

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		return Roact.createElement(Foundation.Slider, {
			LayoutOrder = layoutOrder,
			range = NumberRange.new(0, 1),
			value = props.convertHeadValueToSliderValue(head, headScaleRules.min, headScaleRules.max),
			onValueChanged = function(p2)
				local convertSliderValueToHeadValue = props.convertSliderValueToHeadValue(
					p2,
					headScaleRules.min,
					headScaleRules.max
				)
				props.props.setScales({ head = convertSliderValueToHeadValue })
			end,
			onDragStarted = props.props.lockNavigationCallback,
			onDragEnded = props.props.unlockNavigationCallback,
			isDisabled = avatarType == module3.AvatarType.R6,
			NextSelectionUp = props.props.NextSelectionUp,
			NextSelectionDown = props.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
		})
	end

	return Roact.createElement(systemSlider, {
		layoutOrder = layoutOrder,
		min = headScaleRules.min,
		max = headScaleRules.max,
		stepInterval = headScaleRules.increment,
		value = head,
		onValueChanged = function(p2)
			props.props.setScales({ head = p2 })
		end,
		onDragStart = props.props.lockNavigationCallback,
		onDragEnd = props.props.unlockNavigationCallback,
		isDisabled = avatarType == module3.AvatarType.R6,
		NextSelectionUp = props.props.NextSelectionUp,
		NextSelectionDown = props.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	})
end

local v5 = roactServices.connect({ analytics = module })(extended)

local function mapStateToProps(p2, p3)
	return {
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		head = p2.AvatarExperience.AvatarEditor.Character.AvatarScales.head,
		headScaleRules = p2.AvatarExperience.AvatarEditor.AvatarSettings[module3.AvatarSettings.scalesRules].head
	}
end

local function mapDispatchToProps(callback)
	return {
		setScales = function(p2)
			callback(module4(p2))
		end,
		sendAnalytics = function(p2, p3)
			callback(module5(p2, p3))
		end,
		setCurrentToastMessage = function(p2)
			callback(module6(p2))
		end
	}
end

local v6 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v6, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
