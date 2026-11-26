local module = require("@luauforge/bundled/gMy")
local module2 = require("@luauforge/bundled/gMB")
local useDispatch = require("@luauforge/bundled/gMC").Hooks.RoactRodux.useDispatch
local module3 = require("@luauforge/bundled/gMD")
require("@luauforge/bundled/gMx")
local useState = module.useState
local module4 = require("@luauforge/bundled/gMz")
local module5 = require("@luauforge/bundled/gMI")

local v5 = {
	maxRetryCount = game:DefineFastInt("ReactServerUIViewHttpRetryCount", 1),
	enableLogging = false
}

local forwardRef = module.forwardRef(function(data, p2)
	local v6 = data.defaultTemplateName or module4.DEFAULT_TEMPLATE_NAME
	local uiDefinition = data.uiDefinition
	local v7 = module5()

	local v8 = if v7.currentRoute then v7.currentRoute.templateName or v6 else v6

	module.useEffect(function()
		if uiDefinition then
			local template = uiDefinition.templates[v8]
			v7.reset(template.children, {}, template.name)
		end
	end, { uiDefinition })

	local function fn(props)
		local props2 = props.props

		if data.mapComponentPropsFromState then
			props2 = module2.Dictionary.join(props2, data.mapComponentPropsFromState(props))
		end

		if
			v7.currentRoute
			and v7.currentRoute.params
			and #module2.Dictionary.keys(v7.currentRoute.params) > 0
		then
			props2 = module2.Dictionary.join(props2, { params = v7.currentRoute.params })
		end

		return module.createElement(props.component, props2, props.children)
	end

	local function fn2(state, uiDefinition2)
		local v9 = {}

		if v7.currentRoute and v7.currentRoute.componentRefs then
			for i, componentRef in ipairs(v7.currentRoute.componentRefs) do
				local component = uiDefinition2.components[componentRef]

				if not component then
					continue
				end

				local v10 = fn(component)

				if v10 then
					v9[component.name] = v10
				end
			end
		end

		state.props = module2.Dictionary.join({ ref = p2 }, state.props or {})

		return module.createElement(state.component, state.props, v9)
	end

	v6 = v7.currentRoute and v7.currentRoute.templateName or v6
	local v9 = uiDefinition and uiDefinition.templates[v6]

	return v9 and fn2(v9, uiDefinition) or nil
end)

return (module.forwardRef(function(props, p2)
	local uiConfigurationConfig = props.uiConfigurationConfig or v5
	local v6 = useDispatch()

	local state, setState = useState(nil)

	module.useEffect(function()
		v6(module3.new(uiConfigurationConfig):fetch(props.url, props.queryArgs)):andThen(function(p3)
			local responseBody = p3.responseBody

			local success, result = pcall(function()
				return props.transform(responseBody)
			end)

			if success and result then
				setState(result)
			else
				props.onError({
					type = module4.CONFIGURATION_VIEW_ERROR.RENDER_TRANSFORM_ERROR
				})
			end
		end):catch(function()
			props.onError({
				type = module4.CONFIGURATION_VIEW_ERROR.NETWORK_FETCH_ERROR
			})
		end)
	end, {})

	return module.createElement(forwardRef, {
		uiDefinition = state,
		defaultTemplateName = props.defaultTemplateName,
		mapComponentPropsFromState = props.mapComponentPropsFromState,
		ref = p2
	})
end))
