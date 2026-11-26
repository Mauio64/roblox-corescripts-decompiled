local LocalizationService = game:GetService("LocalizationService")

local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/RobloxAppLocales").Localization
local LocaleProvider = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/LocaleProvider")
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").LocalizationProvider

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Otter")

local extended = Roact.Component:extend("Animator")

local v5 = { dampingRatio = 1, frequency = 1.6 }

function extended:init()
	self.state = { shouldRenderChildren = self.props.shouldShow }

	local binding, v6 = Roact.createBinding(1)

	self.motor = Otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(v6)
	self.animationProgress = binding

	self.motor:onComplete(function()
		local props = self.props

		if props.shouldShow then
			if props.onShown ~= nil then
				props.onShown()
			end
		else
			self:setState({ shouldRenderChildren = false })

			if props.onHidden ~= nil then
				props.onHidden()
			end
		end
	end)

	local v7 = self.props.shouldShow and 0 or 1

	if self.props.skipAnimation then
		self.motor:setGoal(Otter.instant(v7))
	else
		self.motor:setGoal(Otter.spring(v7, v5))
	end
end

function extended.didUpdate(object, p2, p3)
	local props = object.props

	if p2.shouldShow ~= props.shouldShow then
		if props.shouldShow then
			object:setState({ shouldRenderChildren = props.shouldShow })
		end

		local v6 = object.props.shouldShow and 0 or 1

		if object.props.skipAnimation then
			object.motor:setGoal(Otter.instant(v6))
		else
			object.motor:setGoal(Otter.spring(v6, v5))
		end
	end
end

function extended.willUnmount(p2)
	p2.motor:destroy()
end

function extended:renderWithoutLocale()
	local props2 = self.props

	if props2.shouldAnimate then
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = self.animationProgress:map(function(p2)
				if props2.animateDown then
					return UDim2.new(0, 0, -1 * p2, 0)
				end

				return UDim2.new(0, 0, 1 * p2, 0)
			end),
			ZIndex = props2.ZIndex
		}, self.state.shouldRenderChildren and props2.renderChildren() or nil)
	end

	if props2.shouldShow then
		return props2.renderChildren()
	end

	return nil
end

function extended:render()
	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService and LocalizationService.RobloxLocaleId
	}, { Roact.createElement(
			localizationProvider,
			{
				localization = localization.new(LocalizationService.RobloxLocaleId)
			},
			{ self:renderWithoutLocale() }
		) })
end

return extended
