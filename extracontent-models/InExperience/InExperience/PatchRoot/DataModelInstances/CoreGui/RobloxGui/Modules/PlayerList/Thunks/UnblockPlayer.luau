local CorePackages = game:GetService("CorePackages")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local parent = script.Parent.Parent

local SetPlayerIsBlocked = require(parent.Actions.SetPlayerIsBlocked)

local function UnblockPlayer(p)
	return function(object)
		coroutine.wrap(function()
			if BlockingUtility:UnblockPlayerAsync(p) then
				object:dispatch(SetPlayerIsBlocked(p, false))
			end
		end)()
	end
end

return UnblockPlayer
