local module = require("@luauforge/deferred/ehV")
local module2 = require("@luauforge/bundled/ehA")
local module3 = require("@luauforge/bundled/ehj")
local module4 = require("@luauforge/bundled/ehW")

local module5 = require("@luauforge/deferred/ehX")
local module6 = require("@luauforge/bundled/eia")

local openAmpWizardContainer = require("@luauforge/bundled/eif").OpenAmpWizardContainer

local fFlagAmpWizardEntryPointEventCtxFallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAmpWizardEntryPointEventCtxFallback

return function(callback)
	return {
		navigateDownToFriendRequests = function()
			callback(module())
		end,
		openProfilePeekView = function(value, p2)
			assert(type(value) == "string", "Expected userId to be a string")
			callback(module2(value, p2))
		end,
		openPlayerContextualMenu = function(p2)
			callback(module5(p2))
		end,
		navigateToUserInfo = function(value, p2)
			assert(type(value) == "string", "Expected userId to be a string")
			callback(module3(value, p2))
		end,
		openLearnMoreLink = function()
			callback(module4())
		end,
		navigateTo3DQRCodePage = function(p2)
			callback(module6(p2))
		end,
		openAmpWizardContainer = function(p2, p3)
			callback(openAmpWizardContainer(
				p2,
				p3,
				nil,
				fFlagAmpWizardEntryPointEventCtxFallback and "FriendsLanding" or nil
			))
		end
	}
end
