local ancestor = script:FindFirstAncestor("ultimate-list")

require(ancestor.Dimensions)

local DimensionsMethods = require(ancestor.Dimensions.DimensionsMethods)
local React = require(ancestor.Parent.React)

require(ancestor.Renderers)

local adjustPositionToScrollAxis = require(ancestor.Dimensions.adjustPositionToScrollAxis)

require(ancestor.createVirtualizedListController)

local joinAndMapBindings = require(ancestor.Util.joinAndMapBindings)
local createElement = React.createElement

local function getKeyDefault(_, n1: number) -- line: 13
	return (tostring(n1))
end
local function ReactStateRenderer(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), getKeyDefault (copy), DimensionsMethods (copy), createElement (copy), joinAndMapBindings (copy), adjustPositionToScrollAxis (copy)
	local v12, v13 = React.useState(t1.virtualizedListController.get)
	local v14, v15 = React.useBinding(nil)

	React.useEffect(function() -- line: 39
		-- upvalues: v12 (copy), t1 (copy), v15 (copy), v13 (copy)
		local u23 = v12

		return t1.virtualizedListController.bindToUpdate(function() -- line: 42
			-- upvalues: v15 (copy), u23 (ref), t1 (copy), v13 (copy)
			v15({
				lockedTo = u23,
				scrollAxis = t1.scrollAxisBinding:getValue()
			})
			u23 = t1.virtualizedListController.get()
			v13(u23)
		end)
	end, {
		t1.virtualizedListController,
		t1.scrollAxisBinding
	})

	local t2 = {}
	local v17 = t1.getKey or getKeyDefault
	local v18 = t1.virtualizedListController.getRange()

	for v19, v20 in v12 do
		local v21 = v18.X + (v19 - 1)
		local v22 = DimensionsMethods.getUDimRect(t1.dimensions, v20, v21, t1.virtualizedListController.getWindowSize(), t1.direction)

		t2[v17(v20, v21)] = createElement("Frame", {
			BackgroundTransparency = 1,
			Position = joinAndMapBindings(function(n2: number, t3: {[any]: any}?) -- line: 70
				-- upvalues: t1 (copy), v12 (copy), adjustPositionToScrollAxis (copy), v22 (copy)
				if t1.config.freezeViewWhileScrolling ~= false and (t3 ~= nil and t3.lockedTo == v12) then
					return adjustPositionToScrollAxis(v22.position, t3.scrollAxis, t1.direction)
				end

				return adjustPositionToScrollAxis(v22.position, n2, t1.direction)
			end, t1.scrollAxisBinding, v14),
			Size = v22.size
		}, t1.callback(v20))
	end

	return createElement(React.Fragment, nil, t2)
end

return ReactStateRenderer
