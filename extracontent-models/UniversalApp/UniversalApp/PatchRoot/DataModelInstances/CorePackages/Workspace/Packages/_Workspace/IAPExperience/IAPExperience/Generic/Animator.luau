local LocalizationService = game:GetService("LocalizationService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.RobloxAppLocales).Localization
local LocaleProvider = require(ParentParent.Locale.LocaleProvider)
local LocalizationProvider = require(ParentParentParent.Localization).LocalizationProvider
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParentParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local Roact = require(ParentParentParent.Roact)
local Otter = require(ParentParentParent.Otter)
local v10 = Roact.Component:extend(script.Name)
local t1 = {
	dampingRatio = 1,
	frequency = 1.6
}

function v10.init(p1) -- line: 36
	-- upvalues: Roact (copy), Otter (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), t1 (copy)
	p1.state = {
		shouldRenderChildren = p1.props.shouldShow
	}

	local v13, v14 = Roact.createBinding(1)

	p1.motor = Otter.createSingleMotor(1)
	p1.motor:start()
	p1.motor:onStep(v14)
	p1.animationProgress = v13
	p1.motor:onComplete(function() -- line: 49
		-- upvalues: p1 (copy)
		local props = p1.props

		if props.shouldShow then
			if props.onShown ~= nil then
				props.onShown()

				return
			end
		else
			p1:setState({
				shouldRenderChildren = false
			})

			if props.onHidden ~= nil then
				props.onHidden()
			end
		end
	end)

	local v15 = not p1.props.shouldShow and 1 or 0

	if FFlagEnableUnifiedProductPurchaseFlow and p1.props.skipAnimation then
		p1.motor:setGoal(Otter.instant(v15))

		return
	end

	p1.motor:setGoal(Otter.spring(v15, t1))
end
function v10.didUpdate(t2: {[any]: any}, t3: {[any]: any}, _) -- line: 73
	-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), Otter (copy), t1 (copy)
	local props = t2.props

	if t3.shouldShow ~= props.shouldShow then
		if props.shouldShow then
			t2:setState({
				shouldRenderChildren = props.shouldShow
			})
		end

		local v20 = not t2.props.shouldShow and 1 or 0

		if FFlagEnableUnifiedProductPurchaseFlow and t2.props.skipAnimation then
			t2.motor:setGoal(Otter.instant(v20))

			return
		end

		t2.motor:setGoal(Otter.spring(v20, t1))
	end
end
function v10.willUnmount(p3) -- line: 91
	p3.motor:destroy()
end
function v10.renderWithoutLocale(p4) -- line: 95
	-- upvalues: Roact (copy)
	local props = p4.props

	if props.shouldAnimate then
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = p4.animationProgress:map(function(p5) -- line: 103
				-- upvalues: props (copy)
				if props.animateDown then
					return UDim2.new(0, 0, -1 * p5, 0)
				end

				return UDim2.new(0, 0, 1 * p5, 0)
			end),
			ZIndex = props.ZIndex
		}, p4.state.shouldRenderChildren and props.renderChildren() or nil)
	end

	if props.shouldShow then
		return props.renderChildren()
	end

	return nil
end
function v10.render(p6) -- line: 121
	-- upvalues: Roact (copy), LocaleProvider (copy), LocalizationService (copy), LocalizationProvider (copy), Localization (copy)
	return Roact.createElement(LocaleProvider, {
		locale = LocalizationService and LocalizationService.RobloxLocaleId
	}, { Roact.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, { p6:renderWithoutLocale() }) })
end

return v10
