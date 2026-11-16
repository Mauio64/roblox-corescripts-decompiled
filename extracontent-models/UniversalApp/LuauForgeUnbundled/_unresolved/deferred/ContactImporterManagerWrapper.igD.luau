local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local module = require("@luauforge/bundled/fDv")
local module2 = require("@luauforge/bundled/fvl")

local module3 = require("@luauforge/deferred/hvD")
local module4 = require("@luauforge/bundled/guW")
local module5 = require("@luauforge/bundled/eez")
local module6 = require("@luauforge/bundled/eed")

local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local contactImporterManager = require("@luauforge/bundled/coQ").ContactImporterManager
local openAmpWizardContainer = require("@luauforge/bundled/eeI").OpenAmpWizardContainer

local fFlagAmpWizardEntryPointEventCtxFallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAmpWizardEntryPointEventCtxFallback
local setHomePageUpsellCardVariation = require("@luauforge/bundled/dpZ").Modules.LuaApp.Actions.SetHomePageUpsellCardVariation
local module7 = require("@luauforge/bundled/fAN")

local function ContactImporterManagerWrapper()
	local v5 = useDispatch()

	local function fn(p2, p3)
		v5(openAmpWizardContainer(
			p2,
			p3,
			nil,
			fFlagAmpWizardEntryPointEventCtxFallback and "ContactImporterManager" or nil
		))
	end

	local function fn2(p2, p3)
		v5(module({ Dash.join({ name = p2 }, p3) }))
	end

	local function fn3(p2)
		v5(module3(p2))
	end

	local function onCloseDiscoverabilityModal()
		v5(module2())
	end

	local function fn4()
		v5(setHomePageUpsellCardVariation("", "", ""))
	end

	local function fn5(p2)
		return v5(module7(IXPService, p2))
	end

	return React.createElement(contactImporterManager, {
		openAmpUpsell = fn,
		navigate = fn2,
		openDiscoverabilityModal = fn3,
		onCloseDiscoverabilityModal = onCloseDiscoverabilityModal,
		openPhoneUpsellModal = module4,
		closeCentralOverlay = module2,
		openContactImporterLearnMoreLink = module5,
		openProfilePeekView = module6,
		hideUpsellCard = fn4,
		waitUntilIXPUserInit = fn5
	})
end

return ContactImporterManagerWrapper
