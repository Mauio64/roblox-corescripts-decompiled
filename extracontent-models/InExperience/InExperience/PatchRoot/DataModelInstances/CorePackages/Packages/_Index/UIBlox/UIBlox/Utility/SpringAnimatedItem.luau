local ParentParent = script.Parent.Parent.Parent
local Otter = require(ParentParent.Otter)
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local v6 = t.intersection(t.strictInterface({
	animatedValues = t.table,
	mapValuesToProps = t.callback,
	springOptions = t.optional(t.table),
	onComplete = t.optional(t.callback),
	regularProps = t.table,
	[Roact.Children] = t.optional(t.table)
}), function(p1) -- line: 53
	-- upvalues: Roact (copy)
	if p1[Roact.Children] ~= nil and p1.regularProps[Roact.Children] ~= nil then
		return false, "Children must be specified in one place, but the [Roact.Children] key was found in both props and props.regularProps on SpringAnimatedItem."
	end

	return true
end)
local t2 = {
	wrap = function(p2) -- line: 66
		-- upvalues: Roact (copy), Otter (copy), v6 (copy), Cryo (copy)
		local v10 = Roact.PureComponent:extend(string.format("SpringAnimatedItem(%s)", (tostring(p2))))

		v10.defaultProps = {
			regularProps = {}
		}

		function v10.init(p3) -- line: 73
			-- upvalues: Roact (copy)
			p3.ref = p3.props.regularProps[Roact.Ref] or Roact.createRef()

			function p3.applyAnimatedValues(p4) -- line: 76
				-- upvalues: p3 (copy)
				local current = p3.ref.current

				if current == nil then
					return
				end

				local v29 = p3.props.mapValuesToProps(p4)

				for k, v in pairs(v29) do
					current[k] = v
				end
			end
			function p3.onComplete() -- line: 90
				-- upvalues: p3 (copy)
				if p3.props.onComplete then
					p3.props.onComplete()
				end
			end

			p3.motor = nil
		end
		function v10.didMount(p5) -- line: 99
			-- upvalues: Otter (copy)
			local animatedValues = p5.props.animatedValues

			p5.applyAnimatedValues(animatedValues)
			p5.motor = Otter.createGroupMotor(animatedValues)
			p5.motor:onStep(function(p6) -- line: 107
				-- upvalues: p5 (copy)
				p5.applyAnimatedValues(p6)
			end)
			p5.motor:onComplete(p5.onComplete)
			p5.motor:start()
		end
		function v10.willUpdate(p7, p8) -- line: 114
			-- upvalues: Roact (copy)
			if p7.props.regularProps[Roact.Ref] ~= p8.regularProps[Roact.Ref] and p8.regularProps[Roact.Ref] ~= nil then
				p7.ref = p8.regularProps[Roact.Ref]
			end
		end
		function v10.render(p9) -- line: 123
			-- upvalues: v6 (copy), Cryo (copy), Roact (copy), p2 (copy)
			assert(v6(p9.props))

			local regularProps = p9.props.regularProps
			local v18 = Cryo.Dictionary.join(regularProps, {
				[Roact.Ref] = p9.ref,
				[Roact.Children] = p9.props[Roact.Children]
			})

			return Roact.createElement(p2, v18)
		end
		function v10.didUpdate(p10, p11) -- line: 135
			-- upvalues: Otter (copy)
			if p10.props.animatedValues ~= p11.animatedValues then
				local t1 = {}
				local v22 = false

				for k, v in pairs(p10.props.animatedValues) do
					local springOptions = p10.props.springOptions

					t1[k] = Otter.spring(v, springOptions)

					if v ~= p11.animatedValues[k] then
						v22 = true
					end
				end

				if v22 then
					p10.motor:setGoal(t1)
				end
			end
		end
		function v10.willUnmount(p12) -- line: 153
			if p12.motor then
				p12.motor:destroy()
				p12.motor = nil
			end
		end

		return v10
	end
}

t2.AnimatedFrame = t2.wrap("Frame")
t2.AnimatedScrollingFrame = t2.wrap("ScrollingFrame")
t2.AnimatedImageLabel = t2.wrap("ImageLabel")
t2.AnimatedTextButton = t2.wrap("TextButton")
t2.AnimatedUIScale = t2.wrap("UIScale")

return t2
