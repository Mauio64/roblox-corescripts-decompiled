local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@luauforge/deferred/gNs")
local module = require("@luauforge/bundled/dXh")
local module2 = require("@luauforge/deferred/gLS")
local module3 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled
local useReconcileDeletedOutfits

if fFlagAXAvatarFoldersEnabled then
	useReconcileDeletedOutfits = require("@luauforge/deferred/gNB").Hooks.useReconcileDeletedOutfits
else
	useReconcileDeletedOutfits = nil
end

local v5 = {
	[module3.OutfitTypes.Avatar] = {
		multipleTitle = "Feature.Avatar.Label.Title.DeleteMultipleAvatars"
	},
	[module3.OutfitTypes.Makeup] = {
		multipleTitle = "Feature.Avatar.Title.BulkDeleteMakeupLooks"
	}
}

local function selectOutfitInfos(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local v6 = { "0" }

local function useDeleteOutfitDialogProps()
	local v7 = useNavigation()
	local v8 = useDispatch()

	local v9 = v7.getParam("outfitIds")

	if not (v9 and #v9 > 0) then
		if v9 then
			mutedError("outfitIds must contain at least one outfit id")
		else
			mutedError("outfitIds is required")
		end

		v9 = v6
	end

	React.useEffect(function()
		if v9 == v6 then
			module.closeOverlay(v7)
		end
	end, { v9 })

	local v10 = useSelector(selectOutfitInfos)
	local v11 = React.useMemo(function()
		return v10[v9[1]]
	end, { v10, v9 })

	local outfitType = v11 and v11.outfitType or module3.OutfitTypes.Avatar

	local name = v11 and v11.name or ""

	local v12 = useLocalization({
		title = #v9 > 1 and {
			v5[outfitType].multipleTitle,
			count = #v9
		} or {
			"Feature.Avatar.Title.SingleDeleteOutfit",
			outfitName = name
		},
		body = "Feature.Avatar.Label.Message.DeleteAvatars",
		confirm = "Feature.Avatar.Action.Delete",
		cancel = "Feature.Avatar.Action.Cancel"
	})

	local v13 = React.useCallback(function()
		module.closeOverlay(v7)
	end, { v7 })

	local v14 = if fFlagAXAvatarFoldersEnabled then useReconcileDeletedOutfits() else nil

	local reconcile = if fFlagAXAvatarFoldersEnabled and v14 ~= nil then v14.reconcile else nil

	local function fn()
		for k, v15 in v9 do
			if fFlagAXAvatarFoldersEnabled and reconcile ~= nil then
				v8(module2(v15)):andThen(function()
					reconcile({ v15 })
				end, function() end)
			else
				v8(module2(v15))
			end
		end

		module.closeOverlay(v7)
	end

	local v18 = React.useCallback(fn, {
		v8,
		v9,
		v7,
		if fFlagAXAvatarFoldersEnabled then reconcile else nil
	})

	return {
		titleText = v12.title,
		bodyText = v12.body,
		confirmButtonText = v12.confirm,
		cancelButtonText = v12.cancel,
		onConfirm = v18,
		onClose = v13
	}
end

return useDeleteOutfitDialogProps
