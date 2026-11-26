local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local roact = PurchasePromptDeps.Roact
local otter = PurchasePromptDeps.Otter
local t = PurchasePromptDeps.t

local extended = roact.Component:extend("Animator")

local v5 = { dampingRatio = 1, frequency = 1.6 }

extended.validateProps = t.interface({
	shouldShow = t.boolean,
	skipAnimation = t.optional(t.boolean),
	onShown = t.optional(t.callback),
	onHidden = t.optional(t.callback)
})

function extended:init()
	local binding, v6 = roact.createBinding(1)

	self.motor = otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(v6)
	self.animationProgress = binding
	self.setProgress = v6

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

	local v7 = self.props.shouldShow and 0 or 1

	if not self.props.skipAnimation then
		self.motor:setGoal(otter.spring(v7, v5))

		return
	end

	self.motor:stop()
	v6(v7)
	task.defer(function()
		self.onComplete()
	end)
end

function extended.didUpdate(data, p2, p3)
	if p2.shouldShow ~= data.props.shouldShow or p2.skipAnimation ~= data.props.skipAnimation then
		local v6 = data.props.shouldShow and 0 or 1

		if data.props.skipAnimation then
			data.motor:stop()
			data.setProgress(v6)
			task.defer(function()
				data.onComplete()
			end)
		else
			data.motor:setGoal(otter.spring(v6, v5))
		end
	end
end

function extended.render(p2)
	return roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = p2.animationProgress:map(function(p3)
			return UDim2.new(0, 0, -1 * p3, 0)
		end)
	}, p2.props[roact.Children])
end

return extended
