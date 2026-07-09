local ParentParent = script.Parent.Parent
local InspectOpened = require(ParentParent.Actions.InspectOpened)
local Networking = require(ParentParent.App.Networking)

return function(p1) -- line: 6
	-- upvalues: Networking (copy), InspectOpened (copy)
	return function(p2) -- line: 7
		-- upvalues: Networking (copy), p1 (copy), InspectOpened (copy)
		p2:dispatch(Networking.NetworkingCurrentlyWearing.GetItemDetails.API(p1)):andThen(function() -- line: 10
			-- upvalues: p2 (copy), InspectOpened (copy), p1 (copy)
			p2:dispatch(InspectOpened(p1))
		end):catch(function() -- line: 13
		end)
	end
end
