local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local Enums = require(EditProfile.Common.Enums)
local EditDisplayName = require(EditProfile.Components.EditDisplayName)
local EditBio = require(EditProfile.Components.EditBio)
local TextKeys = require(EditProfile.Common.TextKeys)
local useRealNamesInDisplayNamesEnabled = require(EditProfile.Hooks.useRealNamesInDisplayNamesEnabled)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Promise = require(parent.Promise)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal

local titleEntries = {
	[Enums.Screens.EditDisplayName] = {
		component = EditDisplayName,
		titleKey = TextKeys.EditDisplayName
	},
	[Enums.Screens.EditBio] = { component = EditBio, titleKey = TextKeys.About }
}

return function(p)
	local v = titleEntries[p]
	local v2 = useNavigation()
	local v3 = useRealNamesInDisplayNamesEnabled()

	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local updateErrorState = React.useCallback(function(flag: boolean)
		setState2(flag)
	end, {})

	local onClose = React.useCallback(function()
		ProfileRefreshSignal.notifyProfileRefresh()
		v2.goBack()
	end, { v2 })

	local registerSaveHandler = React.useCallback(function(current)
		ref.current = current
	end, {})

	local onSave = React.useCallback(function()
		if ref.current and not state2 then
			setState(true)
			Promise.resolve(ref.current()):andThen(function()
				setState(false)
				onClose()
			end):catch(function(_)
				setState(false)
			end)
		end
	end, { state2 })
	local titleKey

	if p == Enums.Screens.EditDisplayName then
		if v3 then
			titleKey = TextKeys.EditAgedUpDisplayName
		else
			titleKey = TextKeys.EditDisplayName
		end
	else
		titleKey = v.titleKey
	end

	return {
		component = v.component,
		titleKey = titleKey,
		saveKey = TextKeys.SaveButtonText,
		onClose = onClose,
		onSave = onSave,
		isLoading = state,
		registerSaveHandler = registerSaveHandler,
		updateErrorState = updateErrorState,
		hasError = state2
	}
end
