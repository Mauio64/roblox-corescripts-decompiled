local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/efi")
require("@luauforge/deferred/efZ")

require("@luauforge/deferred/eil")

local function useSectionsViewModel(data)
	local sections = data.sections

	local state, setState = module.useState(function()
		return {}
	end)

	local state2, setState2 = module.useState(function()
		return {}
	end)

	local state3, setState3 = module.useState(false)

	local v5 = module.useMemo(function()
		local result = {}

		for k in sections do
			result[k] = {
				onLoadingChange = function(p2)
					setState(function(p3)
						if p3[k] == p2 then
							return p3
						end

						return module2.Dictionary.join(p3, { [k] = p2 })
					end)
				end,
				onCountChange = function(p2)
					setState2(function(p3)
						if p3[k] == p2 then
							return p3
						end

						return module2.Dictionary.join(p3, { [k] = p2 })
					end)
				end
			}
		end

		return result
	end, { sections })

	local v6 = module.useMemo(function(): boolean
		for k, v7 in state do
			if v7 then
				return true
			end
		end

		return false
	end, { state })

	module.useEffect(function()
		if state3 or v6 then
			return
		end

		if next(sections) == nil then
			setState3(true)
			return
		end

		for k in sections do
			if state[k] == nil and state2[k] == nil then
				return
			end
		end

		setState3(true)
	end, { v6, state3, sections, state, state2 })

	local onInitialLoadComplete = data.onInitialLoadComplete
	local ref = module.useRef(false)

	module.useEffect(function()
		if not state3 or ref.current or not onInitialLoadComplete then
			return
		end

		ref.current = true

		local v7 = {}

		for k, section in sections do
			if section.analyticsKey then
				v7[section.analyticsKey] = state2[k] or 0
			end
		end

		onInitialLoadComplete(v7)
	end, { state3, onInitialLoadComplete, sections, state2 })

	local v7 = module.useMemo(function(): boolean
		local total = 0

		for k, v8 in state2 do
			total += v8
		end

		return total == 0
	end, { state2 })

	local v8 = module.useMemo(function()
		local v9 = nil

		for k in sections do
			if state[k] ~= true and (state2[k] or 0) > 0 and (v9 == nil or v9 < k) then
				v9 = k
			end
		end

		return v9
	end, { sections, state, state2 })
	local v9 = v6 and not state3
	local v10 = v7 and state3
	local v11 = v9 or v10

	local v12 = module.useMemo(function()
		local children = {}

		for k, section in sections do
			local v13 = v5[k]
			local v14 = not (v8 == nil) and k < v8
			children["Section" .. tostring(k)] = module.createElement(
				section.component,
				module2.Dictionary.join(section.props or {}, {
					sectionProps = {
						refreshSignal = data.refreshSignal,
						onLoadingChange = v13.onLoadingChange,
						onCountChange = v13.onCountChange,
						LayoutOrder = k,
						shouldFold = v14,
						hide = v11
					}
				})
			)
		end

		return children
	end, { sections, v5, data.refreshSignal, v8, v11 })

	return {
		feedProps = data.feedProps,
		renderedSections = v12,
		showLoadingView = v9,
		showEmptyView = v10,
		loadingView = data.loadingView,
		emptyView = data.emptyView
	}
end

return useSectionsViewModel
