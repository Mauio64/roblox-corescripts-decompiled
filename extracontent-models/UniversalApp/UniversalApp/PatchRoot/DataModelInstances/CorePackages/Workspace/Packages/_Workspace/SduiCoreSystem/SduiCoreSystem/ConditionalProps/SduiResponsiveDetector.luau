local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local React = require(SduiCoreSystemParent.React)
local Signals = require(SduiCoreSystemParent.Signals)
local GetDisplayStore = require(SduiCoreSystemParent.Display).GetDisplayStore
local GetInputModeStore = require(SduiCoreSystemParent.Responsive).GetInputModeStore

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)

local checkResponsiveConditions = require(SduiCoreSystem.SduiResponsiveHelpers).checkResponsiveConditions

local function SduiResponsiveDetector(t1: {[any]: any}) -- line: 21
	-- upvalues: GetDisplayStore (copy), GetInputModeStore (copy), React (copy), checkResponsiveConditions (copy), Signals (copy)
	local allConditionalProps = t1.allConditionalProps
	local setFailedResponsivePropIndexes = t1.setFailedResponsivePropIndexes
	local sduiContext = t1.sduiContext
	local getViewportSize = GetDisplayStore(false).getViewportSize
	local getLastInputType = GetInputModeStore(false).getLastInputType
	local getPreferredInputType = GetInputModeStore(false).getPreferredInputType
	local getIsSpatial = GetDisplayStore(false).getIsSpatial

	React.useLayoutEffect(function() -- line: 35
		-- upvalues: checkResponsiveConditions (copy), allConditionalProps (copy), sduiContext (copy), setFailedResponsivePropIndexes (copy), getViewportSize (copy), getLastInputType (copy), getPreferredInputType (copy), getIsSpatial (copy), Signals (copy)
		local t2 = {}

		local function checkConditions(vector2: Vector2, s1: string, s2: string, b1: boolean) -- line: 38
			-- upvalues: checkResponsiveConditions (copy), allConditionalProps (copy), sduiContext (copy), t2 (ref), setFailedResponsivePropIndexes (copy)
			local v23 = checkResponsiveConditions(allConditionalProps, vector2, s1, s2, b1, sduiContext)
			local v24 = nil

			for v25, v26 in v23 do
				if not not t2[v25] ~= not not v26 then
					v24 = true

					break
				end
			end

			if not v24 then
				for v27, v28 in t2 do
					if not not v23[v27] ~= not not v28 then
						v24 = true

						break
					end
				end
			end

			if v24 then
				t2 = v23
				setFailedResponsivePropIndexes(v23)
			end
		end

		checkConditions(getViewportSize(false), getLastInputType(false), getPreferredInputType(false), getIsSpatial(false))

		return Signals.createEffect(function(p1) -- line: 77
			-- upvalues: checkConditions (copy), getViewportSize (copy), getLastInputType (copy), getPreferredInputType (copy), getIsSpatial (copy)
			checkConditions(getViewportSize(p1), getLastInputType(p1), getPreferredInputType(p1), getIsSpatial(p1))
		end)
	end, {
		getViewportSize,
		getLastInputType,
		getPreferredInputType,
		getIsSpatial,
		allConditionalProps,
		setFailedResponsivePropIndexes,
		sduiContext
	})

	return nil
end

return React.memo(SduiResponsiveDetector)
