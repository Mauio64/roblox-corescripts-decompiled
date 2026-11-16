local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.Dimensions)
local DimensionsMethods = require(ultimatelist.Dimensions.DimensionsMethods)
local React = require(ultimatelist.Parent.React)
local adjustPositionToScrollAxis = require(ultimatelist.Dimensions.adjustPositionToScrollAxis)
local createDebugLogger = require(ultimatelist.Util.createDebugLogger)
require(ultimatelist.createVirtualizedListController)
local joinAndMapBindings = require(ultimatelist.Util.joinAndMapBindings)

local createElement = React.createElement

local debugLogger = createDebugLogger("ReactBindingsRenderer")

local function getKeyDefault(_, p: number)
	return (tostring(p))
end

local function ReactBindingsRenderer(props)
	local state, setState = React.useState(function()
		local result = {}

		local elementsDisplayedHint = DimensionsMethods.elementsDisplayedHint(
			props.dimensions,
			props.virtualizedListController.getWindowSize(),
			props.direction
		)

		if elementsDisplayedHint == nil then
			return result
		end

		for _ = 1, elementsDisplayedHint do
			local binding, set = React.createBinding({
				contents = { type = "vacant" }
			})

			table.insert(result, { binding = binding, set = set })
		end

		return result
	end)

	local getKey = props.getKey or getKeyDefault

	React.useEffect(function()
		return props.virtualizedListController.bindToUpdate(function()
			local v = props.virtualizedListController.get()
			local range = props.virtualizedListController.getRange()

			local v2 = {}

			for k, v3 in v do
				v2[getKey(v3, k + (range.X - 1))] = k
			end

			local sets = {}
			local sets2 = {}
			local v3 = {}

			for _, v4 in state do
				local value = v4.binding:getValue()

				if value.contents.type == "vacant" then
					table.insert(sets2, v4.set)
				else
					local key = value.contents.key
					local v5 = v2[key]

					if v5 == nil then
						debugLogger("%s is now dead", key)
						table.insert(sets, v4.set)
					else
						v2[key] = nil

						local v6 = v[v5]

						if value.contents.value ~= v6 then
							debugLogger("%s existed, but changed", key)
							v4.set({
								contents = {
									type = "full",
									index = v5 + (range.X - 1),
									key = key,
									value = v6
								}
							})
						end
					end
				end
			end

			debugLogger("%d total setters, %d dead setters, %d vacant setters", #state, #sets, #sets2)

			for k, v4 in v2 do
				assert(v4 ~= nil, "Luau")
				local v5 = v[v4]

				local v6 = {
					contents = {
						type = "full",
						index = v4 + (range.X - 1),
						key = k,
						value = v5
					}
				}

				local v7 = table.remove(sets)

				if v7 == nil then
					local v8 = table.remove(sets2)

					if v8 == nil then
						local binding, set = React.createBinding(v6)
						table.insert(v3, { binding = binding, set = set })
					else
						debugLogger("%s is filling vacant spot", k)
						v8(v6)
					end
				else
					debugLogger("%s is filling dead spot", k)
					v7(v6)
				end
			end

			if #v3 > 0 then
				debugLogger("Needed to create %d more bindings to fit, there will be %d setters", #v3, #v3 + #state)

				setState(function(p)
					local clone = table.clone(p)
					table.move(v3, 1, #v3, #clone + 1, clone)
					return clone
				end)
			end

			for _, v4 in sets do
				v4({
					contents = { type = "vacant" }
				})
			end
		end)
	end, { props.virtualizedListController, getKey, state })

	local children = {}

	for k, v in state do
		local binding = v.binding

		local mapped = binding:map(function(p)
			if p.contents.type == "vacant" then
				return { size = UDim2.new(), position = UDim2.new() }
			end

			return DimensionsMethods.getUDimRect(
				props.dimensions,
				p.contents.value,
				p.contents.index,
				props.virtualizedListController.getWindowSize(),
				props.direction
			)
		end)

		children[`Item{k}`] = createElement("Frame", {
			BackgroundTransparency = 1,
			Position = joinAndMapBindings(function(p, p2: number)
				return adjustPositionToScrollAxis(p.position, p2, props.direction)
			end, mapped, props.scrollAxisBinding),
			Size = mapped:map(function(p)
				return p.size
			end),
			Visible = binding:map(function(p): boolean
				return p.contents.type == "full"
			end)
		}, {
			Content = props.callback(binding:map(function(p)
				if p.contents.type == "full" then
					return p.contents.value
				end

				return nil
			end))
		})
	end

	return createElement(React.Fragment, {}, children)
end

return (React.memo(ReactBindingsRenderer))
