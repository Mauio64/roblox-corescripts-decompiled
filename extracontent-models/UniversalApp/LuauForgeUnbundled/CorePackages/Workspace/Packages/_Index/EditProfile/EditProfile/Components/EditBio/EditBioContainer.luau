local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local EditBio = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditBio/EditBio")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Promise")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local EditProfileStore = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/EditProfileStore")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SignalsReact").useSignalState
local AnalyticsServiceV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsServiceV2")

return function(p2)
	local v5 = useLocalUserId()
	local v6 = useSignalState(EditProfileStore.getDescription(v5).data) or ""

	local state, setState = React.useState(v6)
	local state2, setState2 = React.useState(nil)

	local v7 = React.useCallback(function(p3)
		setState(p3)
		setState2(nil)
	end, {})

	React.useEffect(function()
		setState(v6)
	end, { v6 })

	React.useEffect(function()
		p2.registerSaveHandler(function()
			return EditProfileStore.updateDescription(v5, state):catch(function(p3)
				if not p3 then
					return
				end

				local v8 = nil

				if p3.errors and p3.errors[1] then
					v8 = p3.errors[1].code
				elseif p3.statusCode then
					v8 = p3.statusCode
				end

				if v8 then
					setState2(v8)
					AnalyticsServiceV2.sendError(v8)
				end

				return Promise.reject(p3)
			end)
		end)
	end, { p2.registerSaveHandler, v5, state })

	return React.createElement(EditBio, {
		bioText = state,
		onDataChange = v7,
		errorCode = state2,
		textBoxRef = p2.textBoxRef
	})
end
