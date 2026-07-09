local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)

require(CorePackages.Packages.Foundation)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useOnAddOutfit = require(Modules.AvatarExperience.OutfitSwitcher.Hooks.useOnAddOutfit)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetDuplicateOutfitOfType = require(Modules.AvatarExperience.AvatarEditor.Selectors.GetDuplicateOutfitOfType)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local t1 = {
	[Constants.OutfitTypes.Avatar] = {
		add = "Feature.Avatar.Label.Title.AddNewAvatar",
		manage = "Feature.Avatar.Label.Title.ManageAvatars",
		update = "Feature.Avatar.Label.Title.UpdateAvatar"
	},
	[Constants.OutfitTypes.Makeup] = {
		add = "Feature.Avatar.Action.AddNewMakeupLook",
		manage = "Feature.Avatar.Action.ManageMakeupLooks",
		update = "Feature.Avatar.Action.UpdateExistingMakeupLook"
	}
}

local function useSettingsTileProps(t2: {[any]: any}, p1) -- line: 59
	-- upvalues: useDispatch (copy), useNavigation (copy), Responsive (copy), ReactFocusNavigation (copy), React (copy), useSelector (copy), GetDuplicateOutfitOfType (copy), useLocalization (copy), t1 (copy), useOnAddOutfit (copy), AvatarScreen (copy), NavigateWithLock (copy)
	local v20 = useDispatch()
	local v21 = useNavigation()
	local v22 = Responsive.usePreferredInput()
	local v23 = ReactFocusNavigation.useFocusGuiObject()
	local v24, v25 = React.useState(false)
	local v26 = useSelector(function(p2) -- line: 67
		return p2.AvatarExperience.AvatarEditor.OutfitInfos
	end)
	local v27 = React.useCallback(function(p3) -- line: 71
		-- upvalues: GetDuplicateOutfitOfType (copy), t2 (copy)
		return GetDuplicateOutfitOfType(p3, t2.outfitType)
	end, { t2.outfitType })
	local v28 = useSelector(v27)
	local v29 = React.useMemo(function() -- line: 77
		-- upvalues: v26 (copy), v28 (copy)
		local v40 = v26[tostring(v28)]

		if v40 then
			return v40.name
		end

		return nil
	end, {
		v28,
		v26
	})
	local v30 = useLocalization({
		add = t1[t2.outfitType].add,
		manage = t1[t2.outfitType].manage,
		update = t1[t2.outfitType].update
	})
	local v31 = React.useCallback(function() -- line: 91
		-- upvalues: v22 (copy), Responsive (copy), v23 (copy), p1 (copy)
		if v22 == Responsive.Input.Directional then
			v23(p1.current)
		end
	end, {
		v22,
		v23,
		p1
	})
	local v32 = React.useCallback(function() -- line: 97
		-- upvalues: v25 (copy)
		v25(function(p4) -- line: 98
			return not p4
		end)
	end, { v25 })
	local v33 = useOnAddOutfit(v21, t2.outfitType, v31, false)
	local v34 = React.useCallback(function(b1: boolean) -- line: 105
		-- upvalues: v21 (copy), AvatarScreen (copy), t2 (copy), v29 (copy), v31 (copy)
		return function() -- line: 106
			-- upvalues: v21 (copy), AvatarScreen (copy), t2 (copy), v29 (copy), b1 (copy), v31 (copy)
			v21.navigate(AvatarScreen.DuplicateOutfitDialog, {
				outfitType = t2.outfitType,
				duplicateOutfitName = v29,
				saveAsNew = b1,
				onOverlayClosed = v31
			})
		end
	end, {
		v21,
		t2.outfitType,
		v29,
		v31
	})
	local v35 = React.useCallback(function(p5) -- line: 117
		-- upvalues: v25 (copy), v28 (copy), v20 (copy), NavigateWithLock (copy), v34 (copy), v33 (copy), v21 (copy), AvatarScreen (copy), t2 (copy)
		v25(false)

		if p5 == "add" then
			if v28 then
				v20(NavigateWithLock(v34(true)))

				return
			end

			v33()

			return
		end

		if p5 == "manage" then
			v20(NavigateWithLock(function() -- line: 127
				-- upvalues: v21 (copy), AvatarScreen (copy), t2 (copy)
				v21.navigate(AvatarScreen.ManageOutfitsPage, {
					outfitType = t2.outfitType
				})
			end))

			return
		end

		if p5 == "update" then
			print("updating")
		end
	end, {
		v20,
		v21,
		v34,
		v33,
		v25,
		v28,
		t2.outfitType
	})
	local v36 = React.useCallback(function() -- line: 147
		-- upvalues: v25 (copy)
		v25(false)
	end, { v25 })
	local v37 = React.useMemo(function() -- line: 151
		-- upvalues: v30 (copy)
		return {
			{
				id = "add",
				text = v30.add
			},
			{
				id = "manage",
				text = v30.manage
			},
			{
				id = "update",
				text = v30.update
			}
		}
	end, { v30 })

	return {
		outfitType = t2.outfitType,
		itemWidth = t2.itemWidth,
		index = t2.index,
		squareAspectRatio = t2.squareAspectRatio,
		onTileActivated = if not v24 then v32 else nil,
		onMenuItemActivated = v35,
		onPressedOutside = v36,
		items = v37,
		isOpen = v24
	}
end

return useSettingsTileProps
