local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local Otter = PurchasePromptDeps.Otter
local t = PurchasePromptDeps.t

local extended = Roact.Component:extend(script.Name)

local v = { dampingRatio = 1, frequency = 1.6 }

extended.validateProps = t.interface({
	shouldShow = t.boolean,
	skipAnimation = t.optional(t.boolean),
	onShown = t.optional(t.callback),
	onHidden = t.optional(t.callback)
})

function extended:init()
	local binding, setProgress = Roact.createBinding(1)

	self.motor = Otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(setProgress)
	self.animationProgress = binding
	self.setProgress = setProgress

	function self.onComplete()
		if self.props.shouldShow then
			if self.props.onShown then
				self.props.onShown()
			end
		elseif self.props.onHidden then
			self.props.onHidden()
		end
	end
	self.motor:onComplete(self.onComplete)

	local v2 = self.props.shouldShow and 0 or 1

	if not self.props.skipAnimation then
		self.motor:setGoal(Otter.spring(v2, v))

		return
	end

	self.motor:stop()
	setProgress(v2)
	task.defer(function()
		self.onComplete()
	end)
end

function extended.didUpdate(data, p, _)
	if p.shouldShow ~= data.props.shouldShow or p.skipAnimation ~= data.props.skipAnimation then
		local v2 = data.props.shouldShow and 0 or 1

		if data.props.skipAnimation then
			data.motor:stop()
			data.setProgress(v2)
			task.defer(function()
				data.onComplete()
			end)
		else
			data.motor:setGoal(Otter.spring(v2, v))
		end
	end
end

function extended.render(p)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = p.animationProgress:map(function(p2)
			return UDim2.new(0, 0, -1 * p2, 0)
		end)
	}, p.props[Roact.Children])
end

return extended
