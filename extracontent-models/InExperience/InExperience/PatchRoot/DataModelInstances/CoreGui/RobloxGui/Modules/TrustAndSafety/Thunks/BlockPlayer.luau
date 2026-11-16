local CorePackages = game:GetService("CorePackages")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local parent = script.Parent.Parent
local ShowToast = require(parent.Actions.ShowToast)

local function BlockPlayer(p, p2, p3)
	return function(object)
		coroutine.wrap(function()
			if BlockingUtility:BlockPlayerAsync(p) then
				object:dispatch(ShowToast(p2, p3))
			end
		end)()
	end
end

return BlockPlayer
