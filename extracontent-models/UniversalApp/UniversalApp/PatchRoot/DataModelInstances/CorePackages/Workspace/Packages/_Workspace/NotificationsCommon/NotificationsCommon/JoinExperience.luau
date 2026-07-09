local ParentParent = script.Parent.Parent
local default = require(ParentParent.LinkingProtocol).LinkingProtocol.default
local isSubjectToDesktopPolicies = require(ParentParent.SharedFlags).isSubjectToDesktopPolicies

return function(p1, p2) -- line: 10
	-- upvalues: isSubjectToDesktopPolicies (copy), default (copy)
	return pcall(function() -- line: 11
		-- upvalues: p2 (copy), isSubjectToDesktopPolicies (copy), default (copy), p1 (copy)
		if p2 and not isSubjectToDesktopPolicies() then
			game:Shutdown()
		end

		default:isURLRegistered(p1):andThen(function(p3) -- line: 15
			-- upvalues: default (copy), p1 (copy), p2 (copy)
			if p3 then
				default:detectURL(p1)

				return
			end

			if p2 then
				game:Shutdown()
				default:detectURL(p1)
			end
		end)
	end)
end
