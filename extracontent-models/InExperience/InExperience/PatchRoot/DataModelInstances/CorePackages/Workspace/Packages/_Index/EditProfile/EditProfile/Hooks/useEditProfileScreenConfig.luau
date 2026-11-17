local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local Enums = require(EditProfile.Common.Enums)
local EditDisplayName = require(EditProfile.Components.EditDisplayName)
local EditBio = require(EditProfile.Components.EditBio)
local TextKeys = require(EditProfile.Common.TextKeys)
local FFlagEditProfileAlignBioTranslationKeys = require(EditProfile.Flags.FFlagEditProfileAlignBioTranslationKeys)
local useRealNamesInDisplayNamesEnabled = require(EditProfile.Hooks.useRealNamesInDisplayNamesEnabled)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Promise = require(parent.Promise)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal

local v = {
	[Enums.Screens.EditDisplayName] = {
		component = EditDisplayName,
		titleKey = TextKeys.EditDisplayName
	}
}

local editBio = Enums.Screens.EditBio
local titleKey

if FFlagEditProfileAlignBioTranslationKeys then
	titleKey = TextKeys.EditBio
else
	titleKey = TextKeys.About
end

v[editBio] = { component = EditBio, titleKey = titleKey }

return function(p)
	local v2 = v[p]
	local v3 = useNavigation()
	local v4 = useRealNamesInDisplayNamesEnabled()

	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local updateErrorState = React.useCallback(function(flag: boolean)
		setState2(flag)
	end, {})

	local onClose = React.useCallback(function()
		ProfileRefreshSignal.notifyProfileRefresh()
		v3.goBack()
	end, { v3 })

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
	local titleKey2

	if p == Enums.Screens.EditDisplayName then
		if v4 then
			titleKey2 = TextKeys.EditAgedUpDisplayName
		else
			titleKey2 = TextKeys.EditDisplayName
		end
	else
		titleKey2 = v2.titleKey
	end

	return {
		component = v2.component,
		titleKey = titleKey2,
		saveKey = TextKeys.SaveButtonText,
		onClose = onClose,
		onSave = onSave,
		isLoading = state,
		registerSaveHandler = registerSaveHandler,
		updateErrorState = updateErrorState,
		hasError = state2
	}
end
