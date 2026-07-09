local Modules = script:FindFirstAncestor("Modules")
local CorePackages = game:GetService("CorePackages")
local NavigateDownToFriendRequests = require(Modules.LuaApp.Thunks.NavigateDownToFriendRequests)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local NavigateToUserInfo = require(Modules.LuaApp.Thunks.NavigateToUserInfo)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local OpenCentralOverlayForPlayerContextualMenu = require(Modules.LuaApp.Thunks.OpenCentralOverlayForPlayerContextualMenu)
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer

return function(p1) -- line: 14
	-- upvalues: NavigateDownToFriendRequests (copy), OpenProfilePeekView (copy), OpenCentralOverlayForPlayerContextualMenu (copy), NavigateToUserInfo (copy), OpenContactImporterLearnMoreLink (copy), NavigateDownTo3DQRCodePage (copy), OpenAmpWizardContainer (copy)
	return {
		navigateDownToFriendRequests = function() -- line: 16
			-- upvalues: p1 (copy), NavigateDownToFriendRequests (copy)
			p1(NavigateDownToFriendRequests())
		end,
		openProfilePeekView = function(p2, p3) -- line: 19
			-- upvalues: p1 (copy), OpenProfilePeekView (copy)
			assert(type(p2) == "string", "Expected userId to be a string")
			p1(OpenProfilePeekView(p2, p3))
		end,
		openPlayerContextualMenu = function(p4) -- line: 23
			-- upvalues: p1 (copy), OpenCentralOverlayForPlayerContextualMenu (copy)
			p1(OpenCentralOverlayForPlayerContextualMenu(p4))
		end,
		navigateToUserInfo = function(p5, p6) -- line: 26
			-- upvalues: p1 (copy), NavigateToUserInfo (copy)
			assert(type(p5) == "string", "Expected userId to be a string")
			p1(NavigateToUserInfo(p5, p6))
		end,
		openLearnMoreLink = function() -- line: 30
			-- upvalues: p1 (copy), OpenContactImporterLearnMoreLink (copy)
			p1(OpenContactImporterLearnMoreLink())
		end,
		navigateTo3DQRCodePage = function(p7) -- line: 33
			-- upvalues: p1 (copy), NavigateDownTo3DQRCodePage (copy)
			p1(NavigateDownTo3DQRCodePage(p7))
		end,
		openAmpWizardContainer = function(p8, p9) -- line: 36
			-- upvalues: p1 (copy), OpenAmpWizardContainer (copy)
			p1(OpenAmpWizardContainer(p8, p9))
		end
	}
end
