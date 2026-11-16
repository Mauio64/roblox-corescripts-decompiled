local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppAmpWizardLaunchBridge = require(AmpUpsell.Common.AppAmpWizardLaunchBridge)
local OpenAmpWizardContainer = require(AmpUpsell.Common.OpenAmpWizardContainer)

local function AmpWizardLaunchReceiver(): nil
	local v = useDispatch()

	React.useEffect(function()
		local v2 = AppAmpWizardLaunchBridge.subscribe(function(data)
			v(OpenAmpWizardContainer(
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
			v2:disconnect()
		end
	end, { v })

	return nil
end

return AmpWizardLaunchReceiver
