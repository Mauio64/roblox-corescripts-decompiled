local parent = script.Parent.Parent
local actions = parent.Actions

local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Rodux = require(parent2.Rodux)

local SetShareInviteLink = require(actions.SetShareInviteLink)
local ClearShareInviteLink = require(actions.ClearShareInviteLink)

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
