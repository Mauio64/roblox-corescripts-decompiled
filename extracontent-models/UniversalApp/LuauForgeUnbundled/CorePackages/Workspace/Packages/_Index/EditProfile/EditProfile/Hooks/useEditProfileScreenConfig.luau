local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local EditDisplayName = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditDisplayName")
local EditBio = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditBio")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local useRealNamesInDisplayNamesEnabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useRealNamesInDisplayNamesEnabled")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Navigation").useNavigation
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Promise")
local profileRefreshSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ProfilePlatformCommon").Signals.ProfileRefreshSignal

local titleEntries = {
	[Enums.Screens.EditDisplayName] = {
		component = EditDisplayName,
		titleKey = TextKeys.EditDisplayName
	},
	[Enums.Screens.EditBio] = { component = EditBio, titleKey = TextKeys.About }
}

return function(p2)
	local v5 = titleEntries[p2]
	local v6 = useNavigation()
	local v7 = useRealNamesInDisplayNamesEnabled()

	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v8 = React.useCallback(function(p3)
		setState2(p3)
	end, {})

	local v9 = React.useCallback(function()
		profileRefreshSignal.notifyProfileRefresh()
		v6.goBack()
	end, { v6 })

	local v10 = React.useCallback(function(current)
		ref.current = current
	end, {})

	local v11 = React.useCallback(function()
		if ref.current and not state2 then
			setState(true)
			Promise.resolve(ref.current()):andThen(function()
				setState(false)
				v9()
			end):catch(function(p3)
				setState(false)
			end)
		end
	end, { state2 })
	local v12

	if p2 == Enums.Screens.EditDisplayName then
		v12 = if v7 then TextKeys.EditAgedUpDisplayName else TextKeys.EditDisplayName
	else
		v12 = v5.titleKey
	end

	return {
		component = v5.component,
		titleKey = v12,
		saveKey = TextKeys.SaveButtonText,
		onClose = v9,
		onSave = v11,
		isLoading = state,
		registerSaveHandler = v10,
		updateErrorState = v8,
		hasError = state2
	}
end
