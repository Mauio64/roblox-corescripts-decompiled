local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local EditDisplayName = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditDisplayName")
local EditBio = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditBio")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local FFlagEditProfileAlignBioTranslationKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileAlignBioTranslationKeys")
local useRealNamesInDisplayNamesEnabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useRealNamesInDisplayNamesEnabled")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Navigation").useNavigation
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Promise")
local profileRefreshSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Signals.ProfileRefreshSignal

local v5 = {
	[Enums.Screens.EditDisplayName] = {
		component = EditDisplayName,
		titleKey = TextKeys.EditDisplayName
	}
}

local editBio = Enums.Screens.EditBio

local v7 = if FFlagEditProfileAlignBioTranslationKeys then TextKeys.EditBio else TextKeys.About
v5[editBio] = { component = EditBio, titleKey = v7 }

return function(p2)
	local v8 = v5[p2]
	local v9 = useNavigation()
	local v10 = useRealNamesInDisplayNamesEnabled()

	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v11 = React.useCallback(function(p3)
		setState2(p3)
	end, {})

	local v12 = React.useCallback(function()
		profileRefreshSignal.notifyProfileRefresh()
		v9.goBack()
	end, { v9 })

	local v13 = React.useCallback(function(current)
		ref.current = current
	end, {})

	local v14 = React.useCallback(function()
		if ref.current and not state2 then
			setState(true)
			Promise.resolve(ref.current()):andThen(function()
				setState(false)
				v12()
			end):catch(function(p3)
				setState(false)
			end)
		end
	end, { state2 })
	local v15

	if p2 == Enums.Screens.EditDisplayName then
		v15 = if v10 then TextKeys.EditAgedUpDisplayName else TextKeys.EditDisplayName
	else
		v15 = v8.titleKey
	end

	return {
		component = v8.component,
		titleKey = v15,
		saveKey = TextKeys.SaveButtonText,
		onClose = v12,
		onSave = v14,
		isLoading = state,
		registerSaveHandler = v13,
		updateErrorState = v11,
		hasError = state2
	}
end
