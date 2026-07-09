local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Enums = require(EditProfile.Common.Enums)
local EditDisplayName = require(EditProfile.Components.EditDisplayName)
local EditBio = require(EditProfile.Components.EditBio)
local TextKeys = require(EditProfile.Common.TextKeys)
local useRealNamesInDisplayNamesEnabled = require(EditProfile.Hooks.useRealNamesInDisplayNamesEnabled)
local useNavigation = require(EditProfileParent.Navigation).useNavigation
local Promise = require(EditProfileParent.Promise)
local ProfileRefreshSignal = require(EditProfileParent.ProfilePlatformCommon).Signals.ProfileRefreshSignal
local t1 = {
	[Enums.Screens.EditDisplayName] = {
		component = EditDisplayName,
		titleKey = TextKeys.EditDisplayName
	},
	[Enums.Screens.EditBio] = {
		component = EditBio,
		titleKey = TextKeys.About
	}
}

return function(p1) -- line: 38
	-- upvalues: t1 (copy), useNavigation (copy), useRealNamesInDisplayNamesEnabled (copy), React (copy), ProfileRefreshSignal (copy), Promise (copy), Enums (copy), TextKeys (copy)
	local v14 = t1[p1]
	local v15 = useNavigation()
	local v16 = useRealNamesInDisplayNamesEnabled()
	local v17 = React.useRef(nil)
	local v18, v19 = React.useState(false)
	local v20, v21 = React.useState(false)
	local v22 = React.useCallback(function(b1: boolean) -- line: 47
		-- upvalues: v21 (copy)
		v21(b1)
	end, {})
	local v23 = React.useCallback(function() -- line: 51
		-- upvalues: ProfileRefreshSignal (copy), v15 (copy)
		ProfileRefreshSignal.notifyProfileRefresh()
		v15.goBack()
	end, { v15 })
	local v24 = React.useCallback(function(p2: ((...any) -> ...any)) -- line: 56
		-- upvalues: v17 (copy)
		v17.current = p2
	end, {})
	local v25 = React.useCallback(function() -- line: 60
		-- upvalues: v17 (copy), v20 (copy), v19 (copy), Promise (copy), v23 (copy)
		if v17.current and not v20 then
			v19(true)
			Promise.resolve(v17.current()):andThen(function() -- line: 64
				-- upvalues: v19 (copy), v23 (copy)
				v19(false)
				v23()
			end):catch(function(_) -- line: 68
				-- upvalues: v19 (copy)
				v19(false)
			end)
		end
	end, { v20 })
	local v26 = if p1 ~= Enums.Screens.EditDisplayName then v14.titleKey else if not v16 then TextKeys.EditDisplayName else TextKeys.EditAgedUpDisplayName

	return {
		component = v14.component,
		titleKey = v26,
		saveKey = TextKeys.SaveButtonText,
		onClose = v23,
		onSave = v25,
		isLoading = v18,
		registerSaveHandler = v24,
		updateErrorState = v22,
		hasError = v20
	}
end
