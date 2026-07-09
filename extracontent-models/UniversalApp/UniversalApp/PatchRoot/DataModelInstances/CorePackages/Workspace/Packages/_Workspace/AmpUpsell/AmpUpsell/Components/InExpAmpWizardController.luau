local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local HttpService = game:GetService("HttpService")
local React = require(AmpUpsellParent.React)
local ReactRoblox = require(AmpUpsellParent.ReactRoblox)
local Roact = require(AmpUpsellParent.Roact)
local SetScreenSize = require(AmpUpsellParent.InExperienceContainer).SetScreenSize
local useDispatch = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch

require(AmpUpsell.Components.WizardContainer)

local InExpWizardNavigator = require(AmpUpsell.Components.InExpWizardNavigator)
local InExperienceProviderContainer = require(AmpUpsellParent.InExperienceContainer).InExperienceProviderContainer

game:DefineFastString("DummyAMPWizardAccessResponse", "Granted")
game:DefineFastString("DummyAMPWizardActionsTakenJSON", "{}")

local GetFFlagEnableDummyAMPWizard = require(AmpUpsell.Flags.GetFFlagEnableDummyAMPWizard)
local GetFFlagInExperienceContainerScreenSizeReducer = require(AmpUpsellParent.SharedFlags).GetFFlagInExperienceContainerScreenSizeReducer
local GetFFlagMoveAmpUpsellOffNavigateDown = require(AmpUpsellParent.SharedFlags).GetFFlagMoveAmpUpsellOffNavigateDown
local FFlagConnectionAmpUpsellOnLeave = require(AmpUpsellParent.SharedFlags).FFlagConnectionAmpUpsellOnLeave
local v15 = game:DefineFastInt("InExpAmpWizardDisplayOrder", 6)
local ApolloProvider = nil

if FFlagConnectionAmpUpsellOnLeave then
	ApolloProvider = require(AmpUpsellParent.ApolloClient).ApolloProvider
end

local u17 = nil

local function WizardScreenGui(p1) -- line: 35
	-- upvalues: useDispatch (copy), v15 (copy), FFlagConnectionAmpUpsellOnLeave (copy), React (copy), Roact (copy), SetScreenSize (copy), InExpWizardNavigator (copy)
	local v21 = useDispatch()
	local v22 = v15

	if FFlagConnectionAmpUpsellOnLeave and (p1 and p1.displayOrder) then
		v22 = p1.displayOrder
	end

	local v23 = nil

	if FFlagConnectionAmpUpsellOnLeave and p1 and p1.onTopOfCoreBlur then
		v23 = true
	end

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = v22,
		Enabled = true,
		OnTopOfCoreBlur = v23,
		[Roact.Change.AbsoluteSize] = function(p2) -- line: 52
			-- upvalues: v21 (copy), SetScreenSize (copy)
			v21(SetScreenSize(p2.AbsoluteSize))
		end
	}, { React.createElement(InExpWizardNavigator, {
		screenProps = {
			extraProps = p1
		}
	}) })
end
local function renderAmpWizard(p3, p4) -- line: 64
	-- upvalues: u17 (ref), ReactRoblox (copy), FFlagConnectionAmpUpsellOnLeave (copy), React (copy), InExperienceProviderContainer (copy), WizardScreenGui (copy), ApolloProvider (ref)
	if u17 == nil then
		local CoreGui = game:GetService("CoreGui")
		local Folder = Instance.new("Folder")

		Folder.Name = "AmpWizard"
		Folder.Parent = CoreGui
		u17 = ReactRoblox.createRoot(Folder)
	end

	if FFlagConnectionAmpUpsellOnLeave then
		local v28 = React.createElement(InExperienceProviderContainer, {}, React.createElement(WizardScreenGui, p3))

		if p4 then
			u17:render(React.createElement(ApolloProvider, {
				client = p4
			}, v28))

			return
		end

		u17:render(v28)

		return
	end

	u17:render(React.createElement(InExperienceProviderContainer, {}, React.createElement(WizardScreenGui, p3)))
end

return {
	OpenAmpWizardContainerInExp = function(s1: string, p5: ((...any) -> ...any), p6, s2: string?, t1: {[any]: any}?, s3: string?, p7, n1: number?, b1: boolean?, b2: boolean?) -- line: 91
		-- upvalues: GetFFlagEnableDummyAMPWizard (copy), HttpService (copy), GetFFlagInExperienceContainerScreenSizeReducer (copy), GetFFlagMoveAmpUpsellOffNavigateDown (copy), u17 (ref), FFlagConnectionAmpUpsellOnLeave (copy), renderAmpWizard (copy)
		if GetFFlagEnableDummyAMPWizard() then
			task.delay(0.5, function() -- line: 104
				-- upvalues: p5 (copy), HttpService (copy)
				if p5 then
					local FastString = game:GetFastString("DummyAMPWizardAccessResponse")
					local FastString2 = game:GetFastString("DummyAMPWizardActionsTakenJSON")

					if not pcall(function() -- line: 110
						-- upvalues: HttpService (copy), FastString2 (copy)
						HttpService:JSONDecode(FastString2)
					end) then
						print("Failed to decode DummyWizardActionsTakenJSON, not calling completionCallback")

						return
					end

					local data = HttpService:JSONDecode(FastString2)

					p5(FastString, data)
				end
			end)

			return
		end

		if GetFFlagInExperienceContainerScreenSizeReducer() and GetFFlagMoveAmpUpsellOffNavigateDown() then
			local t2 = {
				isInExperienceEntry = true,
				nameSpace = s3,
				featureName = s1,
				completionCallback = function(p8, p9) -- line: 127
					-- upvalues: u17 (ref), p5 (copy)
					if u17 then
						u17:render(nil)
					end

					if p5 then
						p5(p8, p9)
					end
				end,
				recourseData = p6,
				entryPointEventCtx = s2,
				extraParameters = t1,
				usePrologue = b2,
				displayOrder = if not FFlagConnectionAmpUpsellOnLeave then nil else n1,
				onTopOfCoreBlur = if not FFlagConnectionAmpUpsellOnLeave then nil else b1
			}

			renderAmpWizard(t2, if not FFlagConnectionAmpUpsellOnLeave then nil else p7)

			return
		end

		print("InExpAmpWizardController: OpenAmpWizardContainerInExp called without necessary flags")
	end
}
