local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")

local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/EnteredChatFromEntryPoint")
local setAppChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/AppChatVisible").setAppChatVisible
local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local fFlagAppChatDistinctUnibarEntryPoint = SharedFlags.FFlagAppChatDistinctUnibarEntryPoint

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v5 = React.useContext(ParentContainerContext)
	local visibilitySignal = v5.visibilitySignal
	local getShouldSetAppChatVisible = v5.getShouldSetAppChatVisible
	local entryPoint = v5.entryPoint
	local v6 = useDispatch()

	React.useEffect(function()
		local connection = visibilitySignal:connect(function(p2, p3)
			if not getShouldSetAppChatVisible(p2) then
				setAppChatVisible(false)

				return
			end

			setAppChatVisible(true)
			local v7 = if fFlagExpChatEnableFriendsTab or fFlagAppChatDistinctUnibarEntryPoint then p3 or entryPoint else entryPoint
			v6(EnteredChatFromEntryPoint(v7))
		end)

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, {
		setAppChatVisible,
		v6,
		visibilitySignal,
		getShouldSetAppChatVisible,
		entryPoint
	})
end
