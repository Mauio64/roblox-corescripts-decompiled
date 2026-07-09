local ParentParent = script.Parent.Parent
local Networking = require(ParentParent.App.Networking)

return function(s1: string) -- line: 5
	-- upvalues: Networking (copy)
	return function(p1) -- line: 6
		-- upvalues: Networking (copy), s1 (copy)
		p1:dispatch(Networking.ContentSharingNetworking.DeletePost.API({
			postId = s1
		})):andThen(function() -- line: 11
		end):catch(function() -- line: 14
		end)
	end
end
