local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Roact = require(parent.Roact)

local InExperienceContainer = require(parent.InExperienceContainer)
local SetScreenSize = InExperienceContainer.SetScreenSize

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

require(AmpUpsell.Common.Types)
local AppAmpWizardLaunchBridge = require(AmpUpsell.Common.AppAmpWizardLaunchBridge)
require(AmpUpsell.Components.WizardContainer)
local InExpWizardNavigator = require(AmpUpsell.Components.InExpWizardNavigator)
local InExperienceContainer2 = require(parent.InExperienceContainer)
local InExperienceProviderContainer = InExperienceContainer2.InExperienceProviderContainer

game:DefineFastString("DummyAMPWizardAccessResponse", "Granted")
game:DefineFastString("DummyAMPWizardActionsTakenJSON", "{}")
local GetFFlagEnableDummyAMPWizard = require(AmpUpsell.Flags.GetFFlagEnableDummyAMPWizard)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagInExperienceContainerScreenSizeReducer = SharedFlags.GetFFlagInExperienceContainerScreenSizeReducer
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagMoveAmpUpsellOffNavigateDown = SharedFlags2.GetFFlagMoveAmpUpsellOffNavigateDown
local defineFastInt = game:DefineFastInt("InExpAmpWizardDisplayOrder", 6)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagRouteStandaloneAmpThroughUniversalApp = SharedFlags3.FFlagRouteStandaloneAmpThroughUniversalApp

local ApolloClient = require(parent.ApolloClient)
local ApolloProvider = ApolloClient.ApolloProvider

local v = nil

local function WizardScreenGui(extraProps)
	local v2 = useDispatch()
	local displayOrder = defineFastInt

	if extraProps and extraProps.displayOrder then
		displayOrder = extraProps.displayOrder
	end

	local onTopOfCoreBlur = extraProps and extraProps.onTopOfCoreBlur and true or nil

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = displayOrder,
		Enabled = true,
		OnTopOfCoreBlur = onTopOfCoreBlur,
		[Roact.Change.AbsoluteSize] = function(p)
			v2(SetScreenSize(p.AbsoluteSize))
		end
	}, { React.createElement(InExpWizardNavigator, {
			screenProps = { extraProps = extraProps }
		}) })
end

local function renderAmpWizard(p, client)
	if v == nil then
		local CoreGui = game:GetService("CoreGui")
		local ampWizard = Instance.new("Folder")
		ampWizard.Name = "AmpWizard"
		ampWizard.Parent = CoreGui

		v = ReactRoblox.createRoot(ampWizard)
	end

	local element = React.createElement(InExperienceProviderContainer, {}, React.createElement(WizardScreenGui, p))

	if client then
		v:render(React.createElement(ApolloProvider, { client = client }, element))
	else
		v:render(element)
	end
end

return {
	OpenAmpWizardContainerInExp = function(featureName: string, completionCallback, recourseData, entryPointEventCtx: string?, extraParameters, nameSpace: string?, client, displayOrder: number?, onTopOfCoreBlur: boolean?, usePrologue: boolean?, prologueOptions)
		if GetFFlagEnableDummyAMPWizard() then
			task.delay(0.5, function()
				if completionCallback then
					local fastString = game:GetFastString("DummyAMPWizardAccessResponse")
					local fastString2 = game:GetFastString("DummyAMPWizardActionsTakenJSON")

					if pcall(function()
						HttpService:JSONDecode(fastString2)
					end) then
						completionCallback(fastString, (HttpService:JSONDecode(fastString2)))
					else
						print("Failed to decode DummyWizardActionsTakenJSON, not calling completionCallback")
					end
				end
			end)
			return
		end

		if FFlagRouteStandaloneAmpThroughUniversalApp and AppAmpWizardLaunchBridge.requestOpen({
			featureName = featureName,
			nameSpace = nameSpace,
			recourseData = recourseData,
			entryPointEventCtx = entryPointEventCtx,
			extraParameters = extraParameters,
			usePrologue = usePrologue,
			prologueOptions = prologueOptions,
			completionCallback = completionCallback
		}) then
			return
		end

		if GetFFlagInExperienceContainerScreenSizeReducer() and GetFFlagMoveAmpUpsellOffNavigateDown() then
			renderAmpWizard({
				isInExperienceEntry = true,
				nameSpace = nameSpace,
				featureName = featureName,
				completionCallback = function(p, p2)
					if v then
						v:render(nil)
					end

					if completionCallback then
						completionCallback(p, p2)
					end
				end,
				recourseData = recourseData,
				entryPointEventCtx = entryPointEventCtx,
				extraParameters = extraParameters,
				usePrologue = usePrologue,
				prologueOptions = prologueOptions,
				displayOrder = displayOrder,
				onTopOfCoreBlur = onTopOfCoreBlur
			}, client)
		else
			print("InExpAmpWizardController: OpenAmpWizardContainerInExp called without necessary flags")
		end
	end
}
