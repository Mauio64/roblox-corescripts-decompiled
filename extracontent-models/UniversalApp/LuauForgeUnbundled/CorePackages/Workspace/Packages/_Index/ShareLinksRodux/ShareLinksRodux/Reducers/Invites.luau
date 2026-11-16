local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/Rodux")

local SetShareInviteLink = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Actions/SetShareInviteLink")
local ClearShareInviteLink = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Actions/ClearShareInviteLink")

local v5 = {}

return function(p2)
	local shareLinksNetworking = p2.shareLinksNetworking

	return Rodux.createReducer(v5, {
		[shareLinksNetworking.GenerateLink.Succeeded.name] = function(p3, p4)
			return Cryo.Dictionary.join(p3, { ShareInviteLink = p4.responseBody })
		end,
		[SetShareInviteLink.name] = function(p3, p4)
			return Cryo.Dictionary.join(p3, { ShareInviteLink = p4.shareInviteLink })
		end,
		[ClearShareInviteLink.name] = function(p3, p4)
			return Cryo.Dictionary.join(p3, { ShareInviteLink = Cryo.None })
		end
	})
end
