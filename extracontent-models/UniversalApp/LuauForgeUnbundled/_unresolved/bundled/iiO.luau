local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/ecq")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")

local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate

local module3 = require("@luauforge/bundled/iiP")

local v5 = if fFlagAXRefetchInventoryOnUpdate then require("@luauforge/bundled/gLT") else require("@luauforge/bundled/dRw")
local module4 = require("@luauforge/bundled/hkR")
local module5 = require("@luauforge/bundled/iiQ")
local module6 = require("@luauforge/bundled/iiR")
local module7 = require("@luauforge/bundled/hbd")
local module8 = require("@luauforge/bundled/dQo")

local defineFastFlag = game:DefineFastFlag("AXIecLookModerationStatus", false)

local extended = Roact.PureComponent:extend("EventReceiver")

local v6 = {
	["approved"] = Enum.ModerationStatus.ReviewedApproved,
	moderated = Enum.ModerationStatus.ReviewedRejected
}

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver
	local networking = self.props.networking
	local analytics = self.props.analytics
	local grantAsset = self.props.grantAsset
	local revokeAsset = self.props.revokeAsset
	local grantOutfit = self.props.grantOutfit
	local revokeCostume = self.props.revokeCostume
	local updateOutfit = self.props.updateOutfit
	local updateAssetModerationStatus = self.props.updateAssetModerationStatus
	local setConnectionState = self.props.setConnectionState

	self.tokens = {
		robloxEventReceiver:observeEvent("AvatarAssetOwnershipNotifications", function(data)
			if data.Type == "Grant" then
				local opaquePage = self.props.opaquePage

				grantAsset(
					tostring(data.AssetTypeId),
					tostring(data.AssetId),
					networking,
					analytics,
					opaquePage
				)
			elseif data.Type == "Revoke" then
				revokeAsset(data.AssetTypeId, data.AssetId)
			end
		end),
		robloxEventReceiver:observeEvent("signalR", function(p2)
			setConnectionState(p2)
		end),
		robloxEventReceiver:observeEvent("AvatarOutfitOwnershipNotifications", function(p2)
			if p2.Type == "Grant" then
				local opaquePage = self.props.opaquePage
				grantOutfit(p2.UserOutfitId, opaquePage)
			elseif p2.Type == "Revoke" then
				revokeCostume(p2.UserOutfitId)
			elseif p2.Type == "Update" then
				updateOutfit(p2.UserOutfitId, networking)
			end
		end),
		robloxEventReceiver:observeEvent("IecOutfitModerationStatus", function(p2)
			if p2 and p2.UserOutfitId then
				updateOutfit(p2.UserOutfitId, networking)
			end
		end),
		robloxEventReceiver:observeEvent("IecAssetModerationStatus", function(data)
			local v7 = data and data.TargetId and data.ModerationStatus and v6[data.ModerationStatus]

			if v7 then
				updateAssetModerationStatus(data.TargetId, v7, data.TargetName, data.UniverseId)
			end
		end)
	}

	if defineFastFlag then
		table.insert(self.tokens, robloxEventReceiver:observeEvent("IecLookModerationStatus", function(p2)
			if p2 and p2.UserOutfitId and self.props.outfitInfos[tostring(p2.UserOutfitId)] then
				updateOutfit(p2.UserOutfitId, networking)
			end
		end))
	end
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, token in p2.tokens do
		token:disconnect()
	end
end

local v7 = roactServices.connect({ networking = module2, analytics = module })(extended)

return RoactRodux.connect(function(p2)
	local opaque = p2.AvatarExperience.AvatarScene.AvatarRoute.opaque
	local v8 = {
		opaquePage = opaque and opaque.name or nil,
		outfitInfos = 0
	}
	local v9 = if defineFastFlag then p2.AvatarExperience.AvatarEditor.OutfitInfos else nil
	v8.outfitInfos = v9
	return v8
end, function(callback)
	return {
		grantAsset = function(p2, p3, p4, p5, p6)
			return callback(module4(p2, p3, p4, p5, p6))
		end,
		revokeAsset = function(p2, p3)
			return callback(module5(p2, p3))
		end,
		setConnectionState = function(p2)
			return callback(module3(p2))
		end,
		grantOutfit = function(p2, p3)
			return callback(module6(tostring(p2), p3))
		end,
		revokeCostume = function(p2)
			return callback(v5(p2))
		end,
		updateOutfit = function(p2, p3)
			return callback(module7(tostring(p2), p3))
		end,
		updateAssetModerationStatus = function(p2, p3, p4, p5)
			return callback(module8(tostring(p2), p3, p4, (tostring(p5))))
		end
	}
end)(v7)
