local parent = script.Parent.Parent.Parent

local Otter = require(parent.Otter)
local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)
local t = require(parent.t)

local v = t.intersection(t.strictInterface({
	animatedValues = t.table,
	mapValuesToProps = t.callback,
	springOptions = t.optional(t.table),
	onComplete = t.optional(t.callback),
	regularProps = t.table,
	[Roact.Children] = t.optional(t.table)
}), function(props)
	if props[Roact.Children] == nil or props.regularProps[Roact.Children] == nil then
		return true
	end

	return
		false,
		"Children must be specified in one place, but the [Roact.Children] key was found in both props and props.regularProps on SpringAnimatedItem."
end)

local SpringAnimatedItem = {
	["wrap"] = nil,
	["wrap"] = nil,
	["wrap"] = nil,
	["wrap"] = nil,
	wrap = function(p)
		local extended = Roact.PureComponent:extend(string.format("SpringAnimatedItem(%s)", (tostring(p))))

		extended.defaultProps = { regularProps = {} }

		function extended:init()
			self.ref = self.props.regularProps[Roact.Ref] or Roact.createRef()

			function self.applyAnimatedValues(p2)
				local current = self.ref.current

				if current == nil then
					return
				end

				local mapValuesToProps = self.props.mapValuesToProps(p2)

				for k, mapValuesToProp in pairs(mapValuesToProps) do
					current[k] = mapValuesToProp
				end
			end

			function self.onComplete()
				if self.props.onComplete then
					self.props.onComplete()
				end
			end

			self.motor = nil
		end

		function extended:didMount()
			local animatedValues = self.props.animatedValues

			self.applyAnimatedValues(animatedValues)

			self.motor = Otter.createGroupMotor(animatedValues)
			self.motor:onStep(function(p2)
				self.applyAnimatedValues(p2)
			end)
			self.motor:onComplete(self.onComplete)
			self.motor:start()
		end

		function extended:willUpdate(p2)
			if
				self.props.regularProps[Roact.Ref] ~= p2.regularProps[Roact.Ref]
				and p2.regularProps[Roact.Ref] ~= nil
			then
				self.ref = p2.regularProps[Roact.Ref]
			end
		end

		function extended.render(p2)
			assert(v(p2.props))

			local regularProps = p2.props.regularProps
			local v2 = Cryo.Dictionary.join(regularProps, {
				[Roact.Ref] = p2.ref,
				[Roact.Children] = p2.props[Roact.Children]
			})

			return Roact.createElement(p, v2)
		end

		function extended.didUpdate(p2, p3)
			if p2.props.animatedValues ~= p3.animatedValues then
				local values = {}
				local flag = false

				for k, animatedValue in pairs(p2.props.animatedValues) do
					local springOptions = p2.props.springOptions
					values[k] = Otter.spring(animatedValue, springOptions)

					if animatedValue ~= p3.animatedValues[k] then
						flag = true
					end
				end

				if flag then
					p2.motor:setGoal(values)
				end
			end
		end

		function extended:willUnmount()
			if self.motor then
				self.motor:destroy()
				self.motor = nil
			end
		end

		return extended
	end
}

SpringAnimatedItem.AnimatedFrame = SpringAnimatedItem.wrap("Frame")
SpringAnimatedItem.AnimatedScrollingFrame = SpringAnimatedItem.wrap("ScrollingFrame")
SpringAnimatedItem.AnimatedImageLabel = SpringAnimatedItem.wrap("ImageLabel")
SpringAnimatedItem.AnimatedTextButton = SpringAnimatedItem.wrap("TextButton")
SpringAnimatedItem.AnimatedUIScale = SpringAnimatedItem.wrap("UIScale")

return SpringAnimatedItem
