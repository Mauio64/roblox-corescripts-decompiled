local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local SetConnectionState = require(Modules.AvatarExperience.AvatarEditor.Actions.SetConnectionState)
local RevokeOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeOutfit)
local GrantAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.GrantAsset)
local RevokeAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.RevokeAsset)
local GrantOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GrantOutfit)
local UpdateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.UpdateOutfit)
local UpdateAssetModerationStatus = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateAssetModerationStatus)
local v16 = Roact.PureComponent:extend("EventReceiver")
local t1 = {
	approved = Enum.ModerationStatus.ReviewedApproved,
	moderated = Enum.ModerationStatus.ReviewedRejected
}

function v16.init(p1) -- line: 30
	-- upvalues: t1 (copy)
	local RobloxEventReceiver = p1.props.RobloxEventReceiver
	local networking = p1.props.networking
	local analytics = p1.props.analytics
	local grantAsset = p1.props.grantAsset
	local revokeAsset = p1.props.revokeAsset
	local grantOutfit = p1.props.grantOutfit
	local revokeCostume = p1.props.revokeCostume
	local updateOutfit = p1.props.updateOutfit
	local updateAssetModerationStatus = p1.props.updateAssetModerationStatus
	local setConnectionState = p1.props.setConnectionState

	p1.tokens = {
		RobloxEventReceiver:observeEvent("AvatarAssetOwnershipNotifications", function(p2) -- line: 43
			-- upvalues: p1 (copy), grantAsset (copy), networking (copy), analytics (copy), revokeAsset (copy)
			if p2.Type == "Grant" then
				local opaquePage = p1.props.opaquePage

				grantAsset(tostring(p2.AssetTypeId), tostring(p2.AssetId), networking, analytics, opaquePage)

				return
			end

			if p2.Type == "Revoke" then
				revokeAsset(p2.AssetTypeId, p2.AssetId)
			end
		end),
		RobloxEventReceiver:observeEvent("signalR", function(p3) -- line: 53
			-- upvalues: setConnectionState (copy)
			setConnectionState(p3)
		end),
		RobloxEventReceiver:observeEvent("AvatarOutfitOwnershipNotifications", function(p4) -- line: 56
			-- upvalues: p1 (copy), grantOutfit (copy), revokeCostume (copy), updateOutfit (copy), networking (copy)
			if p4.Type == "Grant" then
				local opaquePage = p1.props.opaquePage

				grantOutfit(p4.UserOutfitId, opaquePage)

				return
			end

			if p4.Type == "Revoke" then
				revokeCostume(p4.UserOutfitId)

				return
			end

			if p4.Type == "Update" then
				updateOutfit(p4.UserOutfitId, networking)
			end
		end),
		RobloxEventReceiver:observeEvent("IecOutfitModerationStatus", function(p5) -- line: 66
			-- upvalues: updateOutfit (copy), networking (copy)
			if p5 and p5.UserOutfitId then
				updateOutfit(p5.UserOutfitId, networking)
			end
		end),
		RobloxEventReceiver:observeEvent("IecAssetModerationStatus", function(p6) -- line: 71
			-- upvalues: t1 (copy), updateAssetModerationStatus (copy)
			if p6 and (p6.TargetId and p6.ModerationStatus) then
				local v44 = t1[p6.ModerationStatus]

				if v44 then
					updateAssetModerationStatus(p6.TargetId, v44, p6.TargetName, p6.UniverseId)
				end
			end
		end)
	}
end
function v16.render(_) -- line: 82
end
function v16.willUnmount(p8) -- line: 84
	for _, v33 in p8.tokens do
		v33:disconnect()
	end
end

local v18 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics
})(v16)

return RoactRodux.connect(function(p9) -- line: 95
	local opaque = p9.AvatarExperience.AvatarScene.AvatarRoute.opaque

	return {
		opaquePage = opaque and opaque.name or nil
	}
end, function(p10) -- line: 100
	-- upvalues: GrantAsset (copy), RevokeAsset (copy), SetConnectionState (copy), GrantOutfit (copy), RevokeOutfit (copy), UpdateOutfit (copy), UpdateAssetModerationStatus (copy)
	return {
		grantAsset = function(p11, p12, p13, p14, p15) -- line: 102
			-- upvalues: p10 (copy), GrantAsset (copy)
			return p10(GrantAsset(p11, p12, p13, p14, p15))
		end,
		revokeAsset = function(p16, p17) -- line: 105
			-- upvalues: p10 (copy), RevokeAsset (copy)
			return p10(RevokeAsset(p16, p17))
		end,
		setConnectionState = function(p18) -- line: 108
			-- upvalues: p10 (copy), SetConnectionState (copy)
			return p10(SetConnectionState(p18))
		end,
		grantOutfit = function(p19, p20) -- line: 111
			-- upvalues: p10 (copy), GrantOutfit (copy)
			return p10(GrantOutfit(tostring(p19), p20))
		end,
		revokeCostume = function(p21) -- line: 114
			-- upvalues: p10 (copy), RevokeOutfit (copy)
			return p10(RevokeOutfit(p21))
		end,
		updateOutfit = function(p22, p23) -- line: 117
			-- upvalues: p10 (copy), UpdateOutfit (copy)
			return p10(UpdateOutfit(tostring(p22), p23))
		end,
		updateAssetModerationStatus = function(p24, p25, p26, p27) -- line: 120
			-- upvalues: p10 (copy), UpdateAssetModerationStatus (copy)
			return p10(UpdateAssetModerationStatus(tostring(p24), p25, p26, (tostring(p27))))
		end
	}
end)(v18)
