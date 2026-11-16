local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/eed")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local contactsList = require("@luauforge/bundled/coP").ContactsList
local module3 = require("@luauforge/bundled/dCh")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local openAmpWizardContainer = require("@luauforge/bundled/eeI").OpenAmpWizardContainer
local module4 = require("@luauforge/bundled/eez")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAmpWizardEntryPointEventCtxFallback = SharedFlags.FFlagAmpWizardEntryPointEventCtxFallback
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local function ContactsListUniversalAppWrapper(p2)
	local v5 = useDispatch()

	local function fn(p3)
		v5(module3({ toastMessage = p3 }))
	end

	local function fn2(p3, p4)
		v5(module(p3, p4))
	end

	local function onClose(p3)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(p3)
		else
			v5(RobloxAppToastsRodux(p3))
		end
	end

	local function fn3(p3, p4)
		v5(openAmpWizardContainer(
			p3,
			p4,
			nil,
			fFlagAmpWizardEntryPointEventCtxFallback and "ContactsList" or nil
		))
	end

	local function fn4()
		v5(module4())
	end

	return React.createElement(contactsList, Dash.join(p2, {
		showToast = fn,
		onClose = onClose,
		openProfilePeekView = fn2,
		openAmpUpsell = fn3,
		openLearnMoreLink = fn4
	}))
end

return ContactsListUniversalAppWrapper
