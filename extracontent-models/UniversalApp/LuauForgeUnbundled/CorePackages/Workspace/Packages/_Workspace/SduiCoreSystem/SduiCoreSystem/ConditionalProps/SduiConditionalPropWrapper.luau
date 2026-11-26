local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local getInputModeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Responsive").GetInputModeStore
local compareSduiProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiProps")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiResponsiveDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiResponsiveDetector")
local SduiPresenceDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiPresenceDetector")
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Display").GetDisplayStore

local checkPresenceConditions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/checkPresenceConditions")
local checkResponsiveConditions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiResponsiveHelpers").checkResponsiveConditions
local SduiConditionalPropTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes")
local sduiConditionKey = SduiConditionalPropTypes.SduiConditionKey
local sduiResponsiveKey = SduiConditionalPropTypes.SduiResponsiveKey

local v5 = {}

local function SduiConditionalPropWrapper(props)
	local sduiContext = props.sduiContext
	sduiContext.dependencies.instrumentation:startTimerFlow("SduiConditionalPropWrapper")

	local conditionalProps = props.componentConfig.conditionalProps
	local dataStore = sduiContext.dataStore

	local v6 = React.useMemo(function()
		local result = {}

		if not conditionalProps then
			return result
		end

		assert(conditionalProps, "conditionalProps must exist")

		for k, conditionalProp in conditionalProps do
			if not conditionalProp.conditions then
				continue
			end

			for k2, condition in conditionalProp.conditions do
				if k2 == sduiConditionKey.friendInGame then
					result.hasPresenceProp = true
				elseif sduiResponsiveKey[k2] == nil then
					result.hasCustomProp = true
				else
					result.hasResponsiveProp = true
				end
			end
		end

		return result
	end, { conditionalProps })

	local state, setState = React.useState(nil)
	local v7 = React.useCallback(function(p2, p3)
		setState(function(p4)
			if p4 == nil and p3 == nil then
				return nil
			end

			if p4 == nil then
				return { [p2] = p3 }
			end

			if p4[p2] == p3 then
				return p4
			end

			local clone = table.clone(p4)
			clone[p2] = p3
			return clone
		end)
	end, {})

	local state2, setState2 = React.useState(function()
		if not v6.hasResponsiveProp then
			return v5
		end

		local getViewportSize = getDisplayStore(false).getViewportSize
		local getLastInputType = getInputModeStore(false).getLastInputType
		local getPreferredInputType = getInputModeStore(false).getPreferredInputType
		local getIsSpatial = getDisplayStore(false).getIsSpatial

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
		if v6.hasPresenceProp then
			return checkPresenceConditions(conditionalProps, dataStore.social.getInGameFriendsByGame(false))
		end

		return v5
	end)

	local v8 = React.useCallback(function(p2, p3)
		if state2[p2] or state3[p2] then
			return false
		end

		if not p3.conditions then
			return true
		end

		for k, condition in p3.conditions do
			if sduiResponsiveKey[k] == nil and k ~= sduiConditionKey.friendInGame then
				return state and state[k] == condition and true or false
			end
		end

		return true
	end, { state2, state3, state })

	local v9 = React.useMemo(function()
		local joined = { setCustomConditionState = v7 }

		if conditionalProps then
			for k, conditionalProp in conditionalProps do
				if conditionalProp.propOverrides and v8(k, conditionalProp) then
					joined = Cryo.Dictionary.join(joined, conditionalProp.propOverrides)
				end
			end
		end

		return joined
	end, { v8, conditionalProps, v7 })

	local v10 = React.useMemo(function()
		if not conditionalProps then
			return {}
		end

		assert(conditionalProps, "conditionalProps must exist")

		local children = {}

		if v6.hasPresenceProp then
			children.PresenceDetector = React.createElement(SduiPresenceDetector, {
				setFailedPresencePropIndexes = setState3,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		if v6.hasResponsiveProp then
			children.ResponsiveDetector = React.createElement(SduiResponsiveDetector, {
				setFailedResponsivePropIndexes = setState2,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		return children
	end, { conditionalProps, sduiContext, v6 })

	v10.WrappedComponent = React.useMemo(function()
		return React.createElement(
			props.wrappedComponent,
			Cryo.Dictionary.join(props, { conditionalProps = v9 })
		)
	end, { props.wrappedComponent, v9, props })

	sduiContext.dependencies.instrumentation:stopTimerFlow("SduiConditionalPropWrapper", sduiContext)

	return React.createElement(React.Fragment, nil, v10)
end

return React.memo(SduiConditionalPropWrapper, compareSduiProps)
