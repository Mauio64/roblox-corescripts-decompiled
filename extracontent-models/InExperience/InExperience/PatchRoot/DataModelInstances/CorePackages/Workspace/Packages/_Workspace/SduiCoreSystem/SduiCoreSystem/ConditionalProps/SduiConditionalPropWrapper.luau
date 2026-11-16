local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
local SduiResponsiveDetector = require(SduiCoreSystem.ConditionalProps.SduiResponsiveDetector)
local SduiPresenceDetector = require(SduiCoreSystem.ConditionalProps.SduiPresenceDetector)
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore

local checkPresenceConditions = require(SduiCoreSystem.ConditionalProps.checkPresenceConditions)
local SduiResponsiveHelpers = require(SduiCoreSystem.SduiResponsiveHelpers)
local checkResponsiveConditions = SduiResponsiveHelpers.checkResponsiveConditions
local SduiConditionalPropTypes = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local SduiConditionKey = SduiConditionalPropTypes.SduiConditionKey
local SduiResponsiveKey = SduiConditionalPropTypes.SduiResponsiveKey

local v = {}

local function SduiConditionalPropWrapper(props)
	local sduiContext = props.sduiContext
	sduiContext.dependencies.instrumentation:startTimerFlow("SduiConditionalPropWrapper")

	local conditionalProps = props.componentConfig.conditionalProps
	local dataStore = sduiContext.dataStore

	local v2 = React.useMemo(function()
		local result = {}

		if not conditionalProps then
			return result
		end

		assert(conditionalProps, "conditionalProps must exist")

		for _, conditionalProp in conditionalProps do
			if not conditionalProp.conditions then
				continue
			end

			for k, _ in conditionalProp.conditions do
				if k == SduiConditionKey.friendInGame then
					result.hasPresenceProp = true
				elseif SduiResponsiveKey[k] == nil then
					result.hasCustomProp = true
				else
					result.hasResponsiveProp = true
				end
			end
		end

		return result
	end, { conditionalProps })

	local state, setState = React.useState(nil)
	local setCustomConditionState = React.useCallback(function(p: string, p2)
		setState(function(p3)
			if p3 == nil and p2 == nil then
				return nil
			end

			if p3 == nil then
				return { [p] = p2 }
			end

			if p3[p] == p2 then
				return p3
			end

			local clone = table.clone(p3)
			clone[p] = p2
			return clone
		end)
	end, {})

	local state2, setState2 = React.useState(function()
		if not v2.hasResponsiveProp then
			return v
		end

		local getViewportSize = GetDisplayStore(false).getViewportSize
		local getLastInputType = GetInputModeStore(false).getLastInputType
		local getPreferredInputType = GetInputModeStore(false).getPreferredInputType
		local getIsSpatial = GetDisplayStore(false).getIsSpatial

		return checkResponsiveConditions(
			conditionalProps,
			getViewportSize(false),
			getLastInputType(false),
			getPreferredInputType(false),
			getIsSpatial(false),
			sduiContext
		)
	end)

	local state3, setState3 = React.useState(function()
		if v2.hasPresenceProp then
			return checkPresenceConditions(conditionalProps, dataStore.social.getInGameFriendsByGame(false))
		end

		return v
	end)

	local v3 = React.useCallback(function(p: number, p2)
		if state2[p] or state3[p] then
			return false
		end

		if not p2.conditions then
			return true
		end

		for k, condition in p2.conditions do
			if SduiResponsiveKey[k] == nil and k ~= SduiConditionKey.friendInGame then
				return state and state[k] == condition and true or false
			end
		end

		return true
	end, { state2, state3, state })

	local conditionalProps2 = React.useMemo(function()
		local joined = { setCustomConditionState = setCustomConditionState }

		if conditionalProps then
			for k, conditionalProp in conditionalProps do
				if conditionalProp.propOverrides and v3(k, conditionalProp) then
					joined = Cryo.Dictionary.join(joined, conditionalProp.propOverrides)
				end
			end
		end

		return joined
	end, { v3, conditionalProps, setCustomConditionState })

	local v4 = React.useMemo(function()
		if not conditionalProps then
			return {}
		end

		assert(conditionalProps, "conditionalProps must exist")

		local children = {}

		if v2.hasPresenceProp then
			children.PresenceDetector = React.createElement(SduiPresenceDetector, {
				setFailedPresencePropIndexes = setState3,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		if v2.hasResponsiveProp then
			children.ResponsiveDetector = React.createElement(SduiResponsiveDetector, {
				setFailedResponsivePropIndexes = setState2,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		return children
	end, { conditionalProps, sduiContext, v2 })

	v4.WrappedComponent = React.useMemo(function()
		return React.createElement(
			props.wrappedComponent,
			Cryo.Dictionary.join(props, { conditionalProps = conditionalProps2 })
		)
	end, { props.wrappedComponent, conditionalProps2, props })

	sduiContext.dependencies.instrumentation:stopTimerFlow("SduiConditionalPropWrapper", sduiContext)

	return React.createElement(React.Fragment, nil, v4)
end

return React.memo(SduiConditionalPropWrapper, compareSduiProps)
