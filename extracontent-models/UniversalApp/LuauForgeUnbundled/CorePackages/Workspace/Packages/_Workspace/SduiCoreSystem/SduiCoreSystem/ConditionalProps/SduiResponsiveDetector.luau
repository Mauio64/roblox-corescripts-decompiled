local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Display").GetDisplayStore
local getInputModeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Responsive").GetInputModeStore

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes")
local checkResponsiveConditions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiResponsiveHelpers").checkResponsiveConditions

local function SduiResponsiveDetector(data): nil
	local allConditionalProps = data.allConditionalProps
	local setFailedResponsivePropIndexes = data.setFailedResponsivePropIndexes
	local sduiContext = data.sduiContext
	local getViewportSize = getDisplayStore(false).getViewportSize
	local getLastInputType = getInputModeStore(false).getLastInputType
	local getPreferredInputType = getInputModeStore(false).getPreferredInputType
	local getIsSpatial = getDisplayStore(false).getIsSpatial

	React.useLayoutEffect(function()
		local v5 = {}

		local function checkConditions(p2, p3, p4, p5)
			local v6 = checkResponsiveConditions(allConditionalProps, p2, p3, p4, p5, sduiContext)
			local flag = nil

			for k, v8 in v6 do
				if (v5[k] and true or false) ~= (v8 and true or false) then
					flag = true
					break
				end
			end

			if not flag then
				for k, v9 in v5 do
					if (v6[k] and true or false) ~= (v9 and true or false) then
						flag = true
						break
					end
				end
			end

			if flag then
				v5 = v6
				setFailedResponsivePropIndexes(v6)
			end
		end

		checkConditions(
			getViewportSize(false),
			getLastInputType(false),
			getPreferredInputType(false),
			getIsSpatial(false)
		)

		return Signals.createEffect(function(p2)
			checkConditions(
				getViewportSize(p2),
				getLastInputType(p2),
				getPreferredInputType(p2),
				getIsSpatial(p2)
			)
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
