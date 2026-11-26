local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local EditDisplayName = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditDisplayName/EditDisplayName")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/UserProfiles").Stores.UserProfileStore.get()
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SignalsReact").useSignalState
local updateUserDisplayName = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/Requests/updateUserDisplayName")
local validateUserDisplayName = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/Requests/validateUserDisplayName")
local AnalyticsServiceV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsServiceV2")

return function(props)
	local v6 = useLocalUserId()
	local v8 = useSignalState((React.useMemo(function()
		return v5.fetchNamesByUserIds({ (tostring(v6)) })
	end, { v6 })))

	local v9 = React.useMemo(function()
		if v8 and v8.status == "success" and v8.data and #v8.data > 0 then
			return v8.data[1].names.getDisplayName(false) or ""
		end

		return ""
	end, { v8 })

	local state, setState = React.useState(v9)
	local v10 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	React.useEffect(function()
		AnalyticsServiceV2.sendDisplayNameModalLoaded()
	end, {})

	React.useEffect(function()
		props.registerSaveHandler(function()
			return updateUserDisplayName(tostring(v6), state):andThen(function(p2)
				AnalyticsServiceV2.sendDisplayNameSaved(state)

				if v8 and v8.data and #v8.data > 0 then
					local v11 = v8.data[1]

					if v11.names.setDisplayName then
						v11.names.setDisplayName(p2)
					end
				end
			end)
		end)
	end, { props.registerSaveHandler, v6, state, v8 })

	local function validateDisplayName(p2)
		return validateUserDisplayName(tostring(v6), p2)
	end

	return React.createElement(EditDisplayName, {
		initialDisplayName = v9,
		onDataChange = v10,
		validateDisplayName = validateDisplayName,
		updateErrorState = props.updateErrorState,
		textBoxRef = props.textBoxRef
	})
end
