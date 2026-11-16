local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local TooltipContext = require(script.Parent.TooltipContext)

function TooltipProvider(p)
	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)

	local ref4 = React.useRef({})

	local v = React.useCallback(function(current)
		setState(current)
		ref.current = current

		if ref.current and ref2.current and ref.current.id == ref2.current.id then
			ref2.current = nil
		end
	end, {})

	local v2 = React.useCallback(function(p2: string)
		if ref and ref.current and ref.current.id == p2 then
			v(nil)
		end

		if ref2 and ref2.current and ref2.current.id == p2 then
			ref2.current = nil
		end

		local v2 = nil

		for _, v3 in pairs(ref4.current) do
			if v3.id == p2 then
				v2 = v3
				break
			end
		end

		if v2 and v2.priority and ref4.current[v2.priority] then
			ref4.current[v2.priority] = nil
		end
	end, { state })

	ref3.current = React.useCallback(function()
		if ref.current or ref2.current then
			return
		end

		local current = ref4.current
		local v3 = {}

		for _, v4 in pairs(current) do
			table.insert(v3, v4)
		end

		table.sort(v3, function(a, b): boolean
			return a.priority > b.priority
		end)

		local current2 = v3[1]

		if not current2 then
			return
		end

		ref2.current = current2

		task.delay(current2.showDelay / 1000, function()
			v(current2)

			task.delay(current2.dismissDelay / 1000, function()
				v2(current2.id)

				if ref3.current then
					ref3.current()
				end
			end)
		end)
	end, { state })

	local function fn() -- 3 equivalent calls inferred from this helper
		if ref3.current then
			ref3.current()
		end
	end

	local v3 = React.useMemo(function()
		return {
			registerTooltip = function(id: string, priority: number, showDelay: number, dismissDelay: number)
				if not ref4.current[priority] then
					table.insert(ref4.current, priority, {
						id = id,
						priority = priority,
						showDelay = showDelay,
						dismissDelay = dismissDelay
					})
					fn() -- inferred equivalent call
				end
			end,
			unregisterTooltip = function(p2: string)
				v2(p2)
				fn() -- inferred equivalent call
			end,
			dismissTooltip = function(p2: string, _: string?)
				v2(p2)
				fn() -- inferred equivalent call
			end,
			isCurrentTooltip = function(p2: string)
				return state and state.id == p2
			end
		}
	end, { state })

	return React.createElement(TooltipContext.Provider, { value = v3 }, p.children)
end

return TooltipProvider
