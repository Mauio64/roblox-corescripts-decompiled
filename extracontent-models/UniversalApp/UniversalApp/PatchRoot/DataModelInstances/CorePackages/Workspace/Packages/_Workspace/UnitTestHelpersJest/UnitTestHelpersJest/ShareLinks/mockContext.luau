local Parent = script:FindFirstAncestor("UnitTestHelpersJest").Parent
local Cryo = require(Parent.Cryo)
local jest = require(Parent.JestGlobals).jest

return function(p1) -- line: 8
	-- upvalues: Cryo (copy), jest (copy)
	return Cryo.Dictionary.join({
		network = jest.fn(),
		closeCentralOverlay = jest.fn(),
		launchGame = jest.fn(),
		resolveLinkFromLinkId = jest.fn().mockReturnValue({}),
		analyticsImpls = {
			shareLinksAnalytics = {
				openAppViaShareLink = jest.fn(),
				resolveLink = jest.fn(),
				errorDialogButtonClick = jest.fn(),
				errorJoinDialogButtonClick = jest.fn(),
				gameLaunch = jest.fn()
			}
		}
	}, p1 or {})
end
