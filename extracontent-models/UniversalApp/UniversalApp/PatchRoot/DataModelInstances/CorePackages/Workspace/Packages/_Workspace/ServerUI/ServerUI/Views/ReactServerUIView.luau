local ServerUI = script:FindFirstAncestor("ServerUI")
local ServerUIParent = ServerUI.Parent
local React = require(ServerUIParent.React)
local Cryo = require(ServerUIParent.Cryo)
local useDispatch = require(ServerUIParent.RoactUtils).Hooks.RoactRodux.useDispatch
local UIConfiguration = require(ServerUI.Components.UIConfiguration)

require(ServerUI.Types)

local useState = React.useState
local Constants = require(ServerUI.Constants)
local useNavigator = require(ServerUI.Navigation.Hooks.useNavigator)
local t1 = {
	enableLogging = false,
	maxRetryCount = game:DefineFastInt("ReactServerUIViewHttpRetryCount", 1)
}
local v11 = React.forwardRef(function(t2: {[any]: any}, p1) -- line: 43
	-- upvalues: Constants (copy), useNavigator (copy), React (copy), Cryo (copy)
	local v14 = t2.defaultTemplateName or Constants.DEFAULT_TEMPLATE_NAME
	local uiDefinition = t2.uiDefinition
	local v16 = useNavigator()
	local v17 = v16.currentRoute and v16.currentRoute.templateName or v14

	React.useEffect(function() -- line: 50
		-- upvalues: uiDefinition (copy), v17 (copy), v16 (copy)
		if uiDefinition then
			local v27 = uiDefinition.templates[v17]

			v16.reset(v27.children, {}, v27.name)
		end
	end, { uiDefinition })

	local function v18(p2) -- line: 57
		-- upvalues: t2 (copy), Cryo (copy), v16 (copy), React (copy)
		local props = p2.props

		if t2.mapComponentPropsFromState then
			props = Cryo.Dictionary.join(props, t2.mapComponentPropsFromState(p2))
		end

		if v16.currentRoute and v16.currentRoute.params and #Cryo.Dictionary.keys(v16.currentRoute.params) > 0 then
			props = Cryo.Dictionary.join(props, {
				params = v16.currentRoute.params
			})
		end

		return React.createElement(p2.component, props, p2.children)
	end

	local v19 = v16.currentRoute and v16.currentRoute.templateName or v14
	local v20 = uiDefinition and uiDefinition.templates[v19]

	return v20 and (function(p3, p4) -- line: 77
		-- upvalues: v16 (copy), v18 (copy), Cryo (copy), p1 (copy), React (copy)
		local t3 = {}

		if v16.currentRoute and v16.currentRoute.componentRefs then
			for _, v in ipairs(v16.currentRoute.componentRefs) do
				local v35 = p4.components[v]

				if v35 then
					local v36 = v18(v35)

					if v36 then
						t3[v35.name] = v36
					end
				end
			end
		end

		p3.props = Cryo.Dictionary.join({
			ref = p1
		}, p3.props or {})

		return React.createElement(p3.component, p3.props, t3)
	end)(v20, uiDefinition) or nil
end)

return (React.forwardRef(function(t4: {[any]: any}, p5) -- line: 105
	-- upvalues: t1 (copy), useDispatch (copy), useState (copy), React (copy), UIConfiguration (copy), Constants (copy), v11 (copy)
	local v23 = t4.uiConfigurationConfig or t1
	local v24 = useDispatch()
	local v25, v26 = useState(nil)

	React.useEffect(function() -- line: 111
		-- upvalues: UIConfiguration (copy), v23 (copy), v24 (copy), t4 (copy), v26 (copy), Constants (copy)
		local v37 = UIConfiguration.new(v23)

		v24(v37:fetch(t4.url, t4.queryArgs)):andThen(function(p6) -- line: 115
			-- upvalues: t4 (copy), v26 (copy), Constants (copy)
			local responseBody = p6.responseBody
			local ok, result = pcall(function() -- line: 118
				-- upvalues: t4 (copy), responseBody (copy)
				return t4.transform(responseBody)
			end)

			if ok and result then
				v26(result)

				return
			end

			t4.onError({
				type = Constants.CONFIGURATION_VIEW_ERROR.RENDER_TRANSFORM_ERROR
			})
		end):catch(function() -- line: 130
			-- upvalues: t4 (copy), Constants (copy)
			t4.onError({
				type = Constants.CONFIGURATION_VIEW_ERROR.NETWORK_FETCH_ERROR
			})
		end)
	end, {})

	return React.createElement(v11, {
		uiDefinition = v25,
		defaultTemplateName = t4.defaultTemplateName,
		mapComponentPropsFromState = t4.mapComponentPropsFromState,
		ref = p5
	})
end))
