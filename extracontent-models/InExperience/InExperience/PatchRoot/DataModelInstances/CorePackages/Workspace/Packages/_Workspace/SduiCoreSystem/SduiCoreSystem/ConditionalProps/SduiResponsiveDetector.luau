local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local SduiResponsiveHelpers = require(SduiCoreSystem.SduiResponsiveHelpers)
local checkResponsiveConditions = SduiResponsiveHelpers.checkResponsiveConditions

local function SduiResponsiveDetector(data): nil
	local allConditionalProps = data.allConditionalProps
	local setFailedResponsivePropIndexes = data.setFailedResponsivePropIndexes
	local sduiContext = data.sduiContext
	local getViewportSize = GetDisplayStore(false).getViewportSize
	local getLastInputType = GetInputModeStore(false).getLastInputType
	local getPreferredInputType = GetInputModeStore(false).getPreferredInputType
	local getIsSpatial = GetDisplayStore(false).getIsSpatial

	React.useLayoutEffect(function()
		local v = {}

		local function checkConditions(vector2: Vector2, p: string, p2: string, flag: boolean)
			local v2 = checkResponsiveConditions(allConditionalProps, vector2, p, p2, flag, sduiContext)
			local flag2 = nil

			for k, v3 in v2 do
				if (v[k] and true or false) ~= (v3 and true or false) then
					flag2 = true
					break
				end
			end

			if not flag2 then
				for k, v3 in v do
					if (v2[k] and true or false) ~= (v3 and true or false) then
						flag2 = true
						break
					end
				end
			end

			if flag2 then
				v = v2
				setFailedResponsivePropIndexes(v2)
			end
		end

		checkConditions(
			getViewportSize(false),
			getLastInputType(false),
			getPreferredInputType(false),
			getIsSpatial(false)
		)

		return Signals.createEffect(function(p)
			checkConditions(getViewportSize(p), getLastInputType(p), getPreferredInputType(p), getIsSpatial(p))
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
