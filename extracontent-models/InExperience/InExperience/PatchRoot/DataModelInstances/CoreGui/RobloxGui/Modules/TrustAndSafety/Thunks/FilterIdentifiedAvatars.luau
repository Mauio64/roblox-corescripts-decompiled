local CorePackages = game:GetService("CorePackages")
local AvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification).AvatarIdentification
local ParentParent = script.Parent.Parent
local SetSelectedAvatars = require(ParentParent.Actions.SetSelectedAvatars)
local getAvatarsForPoint = AvatarIdentification.getAvatarsForPoint

return function(t1: {[any]: any}) -- line: 10
	-- upvalues: getAvatarsForPoint (copy), SetSelectedAvatars (copy)
	return function(p1) -- line: 11
		-- upvalues: t1 (copy), getAvatarsForPoint (copy), SetSelectedAvatars (copy)
		coroutine.wrap(function() -- line: 13
			-- upvalues: p1 (copy), t1 (copy), getAvatarsForPoint (copy), SetSelectedAvatars (copy)
			local identifiedAvatars = p1:getState().report.identifiedAvatars
			local t2 = {}

			for _, v in ipairs(t1) do
				local v12 = getAvatarsForPoint(identifiedAvatars, v)

				for k, v2 in pairs(v12) do
					t2[k] = v2
					print("Selected avatar", k, v2)
				end
			end

			p1:dispatch(SetSelectedAvatars(t2))
		end)()
	end
end
