local RoduxShareLinks = script:FindFirstAncestor("RoduxShareLinks")
local parent = RoduxShareLinks.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local Actions = RoduxShareLinks.Actions

local SetShareInviteLink = require(Actions.SetShareInviteLink)
local ClearShareInviteLink = require(Actions.ClearShareInviteLink)

local v = {}

return function(p)
	local shareLinksNetworking = p.shareLinksNetworking

	return Rodux.createReducer(v, {
		[shareLinksNetworking.GenerateLink.Succeeded.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, { ShareInviteLink = p3.responseBody })
		end,
		[SetShareInviteLink.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, { ShareInviteLink = p3.shareInviteLink })
		end,
		[ClearShareInviteLink.name] = function(p2, _)
			return Cryo.Dictionary.join(p2, { ShareInviteLink = Cryo.None })
		end
	})
end
