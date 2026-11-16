local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useDispatch
local AppAmpWizardLaunchBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppAmpWizardLaunchBridge")
local OpenAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/OpenAmpWizardContainer")

local function AmpWizardLaunchReceiver(): nil
	local v5 = useDispatch()

	React.useEffect(function()
		local v6 = AppAmpWizardLaunchBridge.subscribe(function(data)
			v5(OpenAmpWizardContainer(
				data.featureName,
				data.completionCallback or function() end,
				data.recourseData,
				data.entryPointEventCtx,
				data.extraParameters,
				data.nameSpace,
				nil,
				nil,
				nil,
				data.usePrologue,
				data.prologueOptions
			))
		end)
		return function()
			v6:disconnect()
		end
	end, { v5 })

	return nil
end

return AmpWizardLaunchReceiver
