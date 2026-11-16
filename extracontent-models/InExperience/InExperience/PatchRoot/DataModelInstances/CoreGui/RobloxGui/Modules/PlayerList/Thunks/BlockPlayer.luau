local CorePackages = game:GetService("CorePackages")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local parent = script.Parent.Parent

local SetPlayerIsBlocked = require(parent.Actions.SetPlayerIsBlocked)

local function BlockPlayer(p)
	return function(object)
		coroutine.wrap(function()
			if BlockingUtility:BlockPlayerAsync(p) then
				object:dispatch(SetPlayerIsBlocked(p, true))
			end
		end)()
	end
end

return BlockPlayer
