local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(Parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local Otter = PurchasePromptDeps.Otter
local t = PurchasePromptDeps.t
local FFlagEnableUnifiedProductPurchaseFlow = require(Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local v7 = Roact.Component:extend(script.Name)
local t1 = {
	dampingRatio = 1,
	frequency = 1.6
}

v7.validateProps = t.interface({
	shouldShow = t.boolean,
	skipAnimation = t.optional(t.boolean),
	onShown = t.optional(t.callback),
	onHidden = t.optional(t.callback)
})

function v7.init(p1) -- line: 26
	-- upvalues: Roact (copy), Otter (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), t1 (copy)
	local v10, v11 = Roact.createBinding(1)

	p1.motor = Otter.createSingleMotor(1)
	p1.motor:start()
	p1.motor:onStep(v11)
	p1.animationProgress = v10
	p1.setProgress = v11

	function p1.onComplete() -- line: 36
		-- upvalues: p1 (copy)
		if p1.props.shouldShow then
			if p1.props.onShown then
				p1.props.onShown()

				return
			end
		elseif p1.props.onHidden then
			p1.props.onHidden()
		end
	end

	p1.motor:onComplete(p1.onComplete)

	local v12 = not p1.props.shouldShow and 1 or 0

	if FFlagEnableUnifiedProductPurchaseFlow and p1.props.skipAnimation then
		p1.motor:stop()
		v11(v12)
		task.defer(function() -- line: 54
			-- upvalues: p1 (copy)
			p1.onComplete()
		end)

		return
	end

	p1.motor:setGoal(Otter.spring(v12, t1))
end
function v7.didUpdate(p2, p3, _) -- line: 62
	-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), Otter (copy), t1 (copy)
	if p3.shouldShow ~= p2.props.shouldShow or FFlagEnableUnifiedProductPurchaseFlow and p3.skipAnimation ~= p2.props.skipAnimation then
		local v16 = not p2.props.shouldShow and 1 or 0

		if FFlagEnableUnifiedProductPurchaseFlow and p2.props.skipAnimation then
			p2.motor:stop()
			p2.setProgress(v16)
			task.defer(function() -- line: 72
				-- upvalues: p2 (copy)
				p2.onComplete()
			end)

			return
		end

		p2.motor:setGoal(Otter.spring(v16, t1))
	end
end
function v7.render(p5) -- line: 81
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = p5.animationProgress:map(function(p6) -- line: 86
			return UDim2.new(0, 0, -1 * p6, 0)
		end)
	}, p5.props[Roact.Children])
end

return v7
