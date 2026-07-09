local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local canGoBack = require(CorePackages.Workspace.Packages.Navigation).canGoBack
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock

require(script.Parent.ManageOutfitsPage)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError

local function useManageOutfitsPageProps() -- line: 24
	-- upvalues: useNavigation (copy), useDispatch (copy), useLocalization (copy), Constants (copy), mutedError (copy), React (copy), canGoBack (copy), AvatarScreen (copy), NavigateWithLock (copy), NavigationUtils (copy)
	local v14 = useNavigation()
	local v15 = useDispatch()
	local v16 = useLocalization({
		title = "Feature.Avatar.Heading.Manage",
		selectAction = "Feature.Avatar.Action.Select",
		cancelAction = "Feature.Avatar.Action.Cancel"
	})
	local v17 = v14.getParam("outfitType")

	if not v17 then
		v17 = Constants.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local v18, v19 = React.useState({})
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(false)
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = React.useCallback(function() -- line: 46
		-- upvalues: canGoBack (copy), v14 (copy)
		if canGoBack(v14) then
			v14.goBack()
		end
	end, { v14 })
	local v27 = React.useCallback(function() -- line: 52
		-- upvalues: v19 (copy)
		v19({})
	end, {})
	local v28 = React.useCallback(function() -- line: 56
		-- upvalues: v14 (copy), AvatarScreen (copy), v18 (copy), v20 (copy), v21 (copy)
		v14.navigate(AvatarScreen.DeleteOutfitPrompt, {
			outfitIds = v18,
			onOverlayClosed = function() -- line: 59
				-- upvalues: v20 (copy), v21 (copy)
				if v20 then
					v21(false)
				end
			end
		})
	end, {
		v14,
		v18,
		v20
	})
	local v29 = React.useCallback(function() -- line: 67
		-- upvalues: v18 (copy), v14 (copy), AvatarScreen (copy)
		local v32 = v18[1]

		if not v32 then
			return
		end

		v14.navigate(AvatarScreen.RenameOutfitPrompt, {
			costumeId = v32,
			onOverlayClosed = function() -- line: 74
			end
		})
	end, {
		v14,
		v18
	})
	local v30 = React.useCallback(function(b1: boolean, s1: string?) -- line: 78
		-- upvalues: v27 (copy), v28 (copy), v29 (copy), v15 (copy), NavigateWithLock (copy), NavigationUtils (copy), v14 (copy), AvatarScreen (copy)
		if b1 and s1 then
			local t1 = {
				ZIndex = 2,
				outfitId = s1,
				onPeekViewClosed = v27,
				exitButtonPosition = Vector2.new(0, 0),
				deleteOutfit = v28,
				renameOutfit = v29
			}

			v15(NavigateWithLock(function() -- line: 88
				-- upvalues: NavigationUtils (copy), v14 (copy), AvatarScreen (copy), t1 (copy)
				NavigationUtils.closeFiltersAndItemDetails(v14)
				NavigationUtils.closeTryOnManager(v14)
				v14.navigate(AvatarScreen.OutfitDetails, t1)
			end))

			return
		end

		NavigationUtils.closeFiltersAndItemDetails(v14)
	end, {
		v15,
		v14,
		v27,
		v28,
		v29
	})
	local v31 = React.useCallback(function() -- line: 98
		-- upvalues: v21 (copy), NavigationUtils (copy), v14 (copy)
		v21(function(p1) -- line: 99
			return not p1
		end)
		NavigationUtils.closeFiltersAndItemDetails(v14)
	end, { v14 })

	return {
		outfitType = v17,
		titleText = v16.title,
		selectActionText = if not v20 then v16.selectAction else v16.cancelAction,
		onBackActivated = v26,
		onSelectActivated = v31,
		selectedOutfits = v18,
		setSelectedOutfits = v19,
		onToggleOutfitCard = v30,
		multiSelect = v20,
		gridRef = v24,
		outfitGridCanScroll = v22,
		setCanScroll = v23,
		deleteOutfit = v28,
		renameOutfit = v29,
		actionBarRef = v25
	}
end

return useManageOutfitsPageProps
