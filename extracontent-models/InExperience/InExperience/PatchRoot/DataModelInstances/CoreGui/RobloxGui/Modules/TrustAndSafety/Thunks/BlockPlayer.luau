local CorePackages = game:GetService("CorePackages")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local ParentParent = script.Parent.Parent
local ShowToast = require(ParentParent.Actions.ShowToast)

local function BlockPlayer(p1, p2, p3) -- line: 7
	-- upvalues: BlockingUtility (copy), ShowToast (copy)
	return function(p4) -- line: 8
		-- upvalues: BlockingUtility (copy), p1 (copy), ShowToast (copy), p2 (copy), p3 (copy)
		coroutine.wrap(function() -- line: 9
			-- upvalues: BlockingUtility (copy), p1 (copy), p4 (copy), ShowToast (copy), p2 (copy), p3 (copy)
			if BlockingUtility:BlockPlayerAsync(p1) then
				p4:dispatch(ShowToast(p2, p3))
			end
		end)()
	end
end

return BlockPlayer
