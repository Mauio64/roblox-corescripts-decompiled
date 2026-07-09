local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)
local SetShareInviteLink = require(Actions.SetShareInviteLink)
local ClearShareInviteLink = require(Actions.ClearShareInviteLink)
local t1 = {}

return function(p1) -- line: 14
	-- upvalues: Rodux (copy), t1 (copy), Cryo (copy), SetShareInviteLink (copy), ClearShareInviteLink (copy)
	local shareLinksNetworking = p1.shareLinksNetworking

	return Rodux.createReducer(t1, {
		[shareLinksNetworking.GenerateLink.Succeeded.name] = function(p2, p3) -- line: 18
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(p2, {
				ShareInviteLink = p3.responseBody
			})
		end,
		[SetShareInviteLink.name] = function(p4, p5) -- line: 22
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(p4, {
				ShareInviteLink = p5.shareInviteLink
			})
		end,
		[ClearShareInviteLink.name] = function(p6, _) -- line: 26
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(p6, {
				ShareInviteLink = Cryo.None
			})
		end
	})
end
