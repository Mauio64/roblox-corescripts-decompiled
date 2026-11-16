local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local LocaleProvider = require(parent.Locale.LocaleProvider)
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local Roact = require(parent2.Roact)
local Otter = require(parent2.Otter)

local extended = Roact.Component:extend(script.Name)

local v = { dampingRatio = 1, frequency = 1.6 }

function extended:init()
	self.state = { shouldRenderChildren = self.props.shouldShow }

	local binding, v2 = Roact.createBinding(1)

	self.motor = Otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(v2)
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

	local v3 = self.props.shouldShow and 0 or 1

	if self.props.skipAnimation then
		self.motor:setGoal(Otter.instant(v3))
	else
		self.motor:setGoal(Otter.spring(v3, v))
	end
end

function extended.didUpdate(object, p, _)
	local props = object.props

	if p.shouldShow ~= props.shouldShow then
		if props.shouldShow then
			object:setState({ shouldRenderChildren = props.shouldShow })
		end

		local v2 = object.props.shouldShow and 0 or 1

		if object.props.skipAnimation then
			object.motor:setGoal(Otter.instant(v2))
		else
			object.motor:setGoal(Otter.spring(v2, v))
		end
	end
end

function extended.willUnmount(p)
	p.motor:destroy()
end

function extended:renderWithoutLocale()
	local props = self.props

	if props.shouldAnimate then
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = self.animationProgress:map(function(p)
				if props.animateDown then
					return UDim2.new(0, 0, -1 * p, 0)
				end

				return UDim2.new(0, 0, 1 * p, 0)
			end),
			ZIndex = props.ZIndex
		}, self.state.shouldRenderChildren and props.renderChildren() or nil)
	end

	if props.shouldShow then
		return props.renderChildren()
	end

	return nil
end

function extended:render()
	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService and LocalizationService.RobloxLocaleId
	}, { Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{ self:renderWithoutLocale() }
		) })
end

return extended
