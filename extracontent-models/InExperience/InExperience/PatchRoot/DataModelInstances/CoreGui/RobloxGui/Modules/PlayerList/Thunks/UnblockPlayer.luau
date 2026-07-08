local CorePackages = game:GetService("CorePackages")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local ParentParent = script.Parent.Parent
local SetPlayerIsBlocked = require(ParentParent.Actions.SetPlayerIsBlocked)

local function UnblockPlayer(p1) -- line: 9
	-- upvalues: BlockingUtility (copy), SetPlayerIsBlocked (copy)
	return function(p2) -- line: 10
		-- upvalues: BlockingUtility (copy), p1 (copy), SetPlayerIsBlocked (copy)
		coroutine.wrap(function() -- line: 11
			-- upvalues: BlockingUtility (copy), p1 (copy), p2 (copy), SetPlayerIsBlocked (copy)
			if BlockingUtility:UnblockPlayerAsync(p1) then
				p2:dispatch(SetPlayerIsBlocked(p1, false))
			end
		end)()
	end
end

return UnblockPlayer
