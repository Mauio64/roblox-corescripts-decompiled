local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local ContactsList = require(Modules.LuaApp.Components.ContactImporter.api).ContactsList
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v13 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function ContactsListUniversalAppWrapper(p1) -- line: 17
	-- upvalues: useDispatch (copy), SetCurrentToastMessage (copy), OpenProfilePeekView (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateBack (copy), OpenAmpWizardContainer (copy), OpenContactImporterLearnMoreLink (copy), React (copy), ContactsList (copy), Dash (copy)
	local v16 = useDispatch()

	return React.createElement(ContactsList, Dash.join(p1, {
		showToast = function(p2) -- line: 20
			-- upvalues: v16 (copy), SetCurrentToastMessage (copy)
			v16(SetCurrentToastMessage({
				toastMessage = p2
			}))
		end,
		onClose = function(p3) -- line: 30
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v13 (copy), v16 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v13.back(p3)

				return
			end

			v16(NavigateBack(p3))
		end,
		openProfilePeekView = function(p4, p5) -- line: 26
			-- upvalues: v16 (copy), OpenProfilePeekView (copy)
			v16(OpenProfilePeekView(p4, p5))
		end,
		openAmpUpsell = function(p6, p7) -- line: 38
			-- upvalues: v16 (copy), OpenAmpWizardContainer (copy)
			v16(OpenAmpWizardContainer(p6, p7))
		end,
		openLearnMoreLink = function() -- line: 42
			-- upvalues: v16 (copy), OpenContactImporterLearnMoreLink (copy)
			v16(OpenContactImporterLearnMoreLink())
		end
	}))
end

return ContactsListUniversalAppWrapper
