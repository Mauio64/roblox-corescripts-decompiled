local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/ReactRoblox")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Roact")

local setScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/InExperienceContainer").SetScreenSize

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useDispatch

require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")
local AppAmpWizardLaunchBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppAmpWizardLaunchBridge")
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/WizardContainer")
local InExpWizardNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/InExpWizardNavigator")
local inExperienceProviderContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/InExperienceContainer").InExperienceProviderContainer

game:DefineFastString("DummyAMPWizardAccessResponse", "Granted")
game:DefineFastString("DummyAMPWizardActionsTakenJSON", "{}")
local GetFFlagEnableDummyAMPWizard = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableDummyAMPWizard")

local getFFlagInExperienceContainerScreenSizeReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").GetFFlagInExperienceContainerScreenSizeReducer
local getFFlagMoveAmpUpsellOffNavigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").GetFFlagMoveAmpUpsellOffNavigateDown
local defineFastInt = game:DefineFastInt("InExpAmpWizardDisplayOrder", 6)

local fFlagRouteStandaloneAmpThroughUniversalApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").FFlagRouteStandaloneAmpThroughUniversalApp

local apolloProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/ApolloClient").ApolloProvider

local v5 = nil

local function WizardScreenGui(p2)
	local v6 = useDispatch()
	local v7 = defineFastInt

	if p2 and p2.displayOrder then
		v7 = p2.displayOrder
	end

	local v8 = p2 and p2.onTopOfCoreBlur and true or nil

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = v7,
		Enabled = true,
		OnTopOfCoreBlur = v8,
		[Roact.Change.AbsoluteSize] = function(p3)
			v6(setScreenSize(p3.AbsoluteSize))
		end
	}, { React.createElement(InExpWizardNavigator, {
			screenProps = { extraProps = p2 }
		}) })
end

local function renderAmpWizard(p2, p3)
	if v5 == nil then
		local CoreGui = game:GetService("CoreGui")
		local ampWizard = Instance.new("Folder")
		ampWizard.Name = "AmpWizard"
		ampWizard.Parent = CoreGui

		v5 = ReactRoblox.createRoot(ampWizard)
	end

	local element = React.createElement(
		inExperienceProviderContainer,
		{},
		React.createElement(WizardScreenGui, p2)
	)

	if p3 then
		v5:render(React.createElement(apolloProvider, { client = p3 }, element))
	else
		v5:render(element)
	end
end

return {
	OpenAmpWizardContainerInExp = function(p2, callback, p3, p4, p5, p6, p7, p8, onTopOfCoreBlur, p9, p10)
		if GetFFlagEnableDummyAMPWizard() then
			task.delay(0.5, function()
				if callback then
					local fastString = game:GetFastString("DummyAMPWizardAccessResponse")
					local fastString2 = game:GetFastString("DummyAMPWizardActionsTakenJSON")

					if pcall(function()
						HttpService:JSONDecode(fastString2)
					end) then
						callback(fastString, (HttpService:JSONDecode(fastString2)))
					else
						print("Failed to decode DummyWizardActionsTakenJSON, not calling completionCallback")
					end
				end
			end)
			return
		end

		if fFlagRouteStandaloneAmpThroughUniversalApp and AppAmpWizardLaunchBridge.requestOpen({
			featureName = p2,
			nameSpace = p6,
			recourseData = p3,
			entryPointEventCtx = p4,
			extraParameters = p5,
			usePrologue = p9,
			prologueOptions = p10,
			completionCallback = callback
		}) then
			return
		end

		if getFFlagInExperienceContainerScreenSizeReducer() and getFFlagMoveAmpUpsellOffNavigateDown() then
			renderAmpWizard({
				isInExperienceEntry = true,
				nameSpace = p6,
				featureName = p2,
				completionCallback = function(p11, p12)
					if v5 then
						v5:render(nil)
					end

					if callback then
						callback(p11, p12)
					end
				end,
				recourseData = p3,
				entryPointEventCtx = p4,
				extraParameters = p5,
				usePrologue = p9,
				prologueOptions = p10,
				displayOrder = p8,
				onTopOfCoreBlur = onTopOfCoreBlur
			}, p7)
		else
			print("InExpAmpWizardController: OpenAmpWizardContainerInExp called without necessary flags")
		end
	end
}
