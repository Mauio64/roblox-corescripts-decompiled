local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local React = require(SduiCoreSystemParent.React)
local GetInputModeStore = require(SduiCoreSystemParent.Responsive).GetInputModeStore
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local SduiResponsiveDetector = require(SduiCoreSystem.ConditionalProps.SduiResponsiveDetector)
local SduiPresenceDetector = require(SduiCoreSystem.ConditionalProps.SduiPresenceDetector)
local GetDisplayStore = require(SduiCoreSystemParent.Display).GetDisplayStore
local checkPresenceConditions = require(SduiCoreSystem.ConditionalProps.checkPresenceConditions)
local checkResponsiveConditions = require(SduiCoreSystem.SduiResponsiveHelpers).checkResponsiveConditions
local SduiConditionalPropTypes = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local SduiConditionKey = SduiConditionalPropTypes.SduiConditionKey
local SduiResponsiveKey = SduiConditionalPropTypes.SduiResponsiveKey
local t1 = {}

local function SduiConditionalPropWrapper(t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy), SduiConditionKey (copy), SduiResponsiveKey (copy), GetDisplayStore (copy), GetInputModeStore (copy), checkResponsiveConditions (copy), t1 (copy), checkPresenceConditions (copy), Cryo (copy), SduiPresenceDetector (copy), SduiResponsiveDetector (copy)
	local sduiContext = t2.sduiContext

	sduiContext.dependencies.instrumentation:startTimerFlow("SduiConditionalPropWrapper")

	local conditionalProps = t2.componentConfig.conditionalProps
	local dataStore = sduiContext.dataStore
	local v21 = React.useMemo(function() -- line: 55
		-- upvalues: conditionalProps (copy), SduiConditionKey (copy), SduiResponsiveKey (copy)
		local t3 = {}

		if not conditionalProps then
			return t3
		end

		assert(conditionalProps, "conditionalProps must exist")

		for _, v34 in conditionalProps do
			if v34.conditions then
				for v35, _ in v34.conditions do
					if v35 == SduiConditionKey.friendInGame then
						t3.hasPresenceProp = true
					elseif SduiResponsiveKey[v35] ~= nil then
						t3.hasResponsiveProp = true
					else
						t3.hasCustomProp = true
					end
				end
			end
		end

		return t3
	end, { conditionalProps })
	local v22, v23 = React.useState(nil)
	local v24 = React.useCallback(function(s1: string, p1) -- line: 81
		-- upvalues: v23 (copy)
		v23(function(p2) -- line: 82
			-- upvalues: p1 (copy), s1 (copy)
			if p2 == nil and p1 == nil then
				return p2
			end

			if p2 == nil then
				return {
					[s1] = p1
				}
			end

			if p2[s1] == p1 then
				return p2
			end

			local v52 = table.clone(p2)

			v52[s1] = p1

			return v52
		end)
	end, {})
	local v25, v26 = React.useState(function() -- line: 99
		-- upvalues: v21 (copy), GetDisplayStore (copy), GetInputModeStore (copy), checkResponsiveConditions (copy), conditionalProps (copy), sduiContext (copy), t1 (copy)
		if v21.hasResponsiveProp then
			local getViewportSize = GetDisplayStore(false).getViewportSize
			local getLastInputType = GetInputModeStore(false).getLastInputType
			local getPreferredInputType = GetInputModeStore(false).getPreferredInputType
			local getIsSpatial = GetDisplayStore(false).getIsSpatial

			return checkResponsiveConditions(conditionalProps, getViewportSize(false), getLastInputType(false), getPreferredInputType(false), getIsSpatial(false), sduiContext)
		end

		return t1
	end)
	local v27, v28 = React.useState(function() -- line: 119
		-- upvalues: v21 (copy), checkPresenceConditions (copy), conditionalProps (copy), dataStore (copy), t1 (copy)
		if v21.hasPresenceProp then
			return checkPresenceConditions(conditionalProps, dataStore.social.getInGameFriendsByGame(false))
		end

		return t1
	end)
	local v29 = React.useCallback(function(n1: number, p3) -- line: 128
		-- upvalues: v25 (copy), v27 (copy), SduiResponsiveKey (copy), SduiConditionKey (copy), v22 (copy)
		if v25[n1] or v27[n1] then
			return false
		end

		if p3.conditions then
			for v45, v46 in p3.conditions do
				if SduiResponsiveKey[v45] == nil and v45 ~= SduiConditionKey.friendInGame then
					return not not v22 and (v46 == v22[v45] or false)
				end
			end
		end

		return true
	end, {
		v25,
		v27,
		v22
	})
	local v30 = React.useMemo(function() -- line: 146
		-- upvalues: v24 (copy), conditionalProps (copy), v29 (copy), Cryo (copy)
		local t4 = {
			setCustomConditionState = v24
		}

		if conditionalProps then
			for v48, v49 in conditionalProps do
				if v49.propOverrides and v29(v48, v49) then
					t4 = Cryo.Dictionary.join(t4, v49.propOverrides)
				end
			end
		end

		return t4
	end, {
		v29,
		conditionalProps,
		v24
	})
	local v31 = React.useMemo(function() -- line: 166
		-- upvalues: conditionalProps (copy), v21 (copy), React (copy), SduiPresenceDetector (copy), v28 (copy), sduiContext (copy), SduiResponsiveDetector (copy), v26 (copy)
		if not conditionalProps then
			return {}
		end

		assert(conditionalProps, "conditionalProps must exist")

		local t5 = {}

		if v21.hasPresenceProp then
			t5.PresenceDetector = React.createElement(SduiPresenceDetector, {
				setFailedPresencePropIndexes = v28,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		if v21.hasResponsiveProp then
			t5.ResponsiveDetector = React.createElement(SduiResponsiveDetector, {
				setFailedResponsivePropIndexes = v26,
				sduiContext = sduiContext,
				allConditionalProps = conditionalProps
			})
		end

		return t5
	end, {
		conditionalProps,
		sduiContext,
		v21
	})

	v31.WrappedComponent = React.useMemo(function() -- line: 200
		-- upvalues: React (copy), t2 (copy), Cryo (copy), v30 (copy)
		return React.createElement(t2.wrappedComponent, Cryo.Dictionary.join(t2, {
			conditionalProps = v30
		}))
	end, {
		t2.wrappedComponent,
		v30,
		t2
	})
	sduiContext.dependencies.instrumentation:stopTimerFlow("SduiConditionalPropWrapper", sduiContext)

	return React.createElement(React.Fragment, nil, v31)
end

return React.memo(SduiConditionalPropWrapper, compareSduiProps)
