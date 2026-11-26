local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Cryo")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Http")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/LuauPolyfill")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/SquadExternalContractProvider")
local useCurrentSquadSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RoduxSquads").Hooks.useCurrentSquadSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RobloxAppHooks").useLocalUserId
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Navigation").useNavigationFocus

local networkingSquads = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Http").NetworkingSquads
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local squadViewFlags = SquadExternalContractProvider.SquadViewFlags

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local SquadStartedCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/SquadCard/SquadStartedCard")
local SquadEndedCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/SquadCard/SquadEndedCard")

local function SquadCard(props)
	local v5 = useDispatch()
	local v6 = useLocalUserId()

	local v7 = React.useContext(squadExternalContractContext)
	local v8 = useCurrentSquadSelector()
	local v9 = if v8 then v8.squadId == props.group_up_id else false

	local v10 = React.useCallback(function(p2)
		if not v9 then
			return Cryo.List.filter(p2, function(p3): boolean
				return tostring(p3) ~= v6
			end)
		end

		local userIds = {}

		for i, member in ipairs(v8.members) do
			table.insert(userIds, member.userId)
		end

		return userIds
	end, { v9, v8, v6 })

	local state, setState = React.useState(props.is_alive)
	local state2, setState2 = React.useState(v10(props.participant_user_ids))

	local v11 = useNavigationFocus()
	local v12 = v9 and v11
	React.useEffect(function()
		if v12 then
			v7.updateSquadViewFlags(squadViewFlags.SquadSystemMessage, true)
		end

		return function()
			if v12 then
				v7.updateSquadViewFlags(squadViewFlags.SquadSystemMessage, false)
			end
		end
	end, { v7.updateSquadViewFlags, v12 })

	React.useEffect(function()
		setState2(v10(props.participant_user_ids))
	end, { setState2, props.participant_user_ids, v10 })

	local v13 = React.useCallback(function(p2)
		v5(networkingSquads.GetSquadFromSquadId.API({ squadId = p2 })):andThen(function(p3)
			if p3 and p3.responseBody and p3.responseBody.groupUp and p3.responseBody.groupUp.members then
				local userIds = {}

				for i, member in ipairs(p3.responseBody.groupUp.members) do
					table.insert(userIds, member.userId)
				end

				setState2(userIds)
			end
		end):catch(function(p3)
			if p3.StatusCode == Http.StatusCodes.NOT_FOUND then
				setState(false)
			else
				warn("Unsupported error type")
			end
		end)
	end, { v5 })

	React.useEffect(function()
		local v14

		if state and not v9 then
			v14 = setInterval(function()
				v13(props.group_up_id)
			end, 10000)
		else
			v14 = nil
		end

		return function()
			if v14 then
				clearInterval(v14)
			end
		end
	end, { v13, state, v9, props.group_up_id })

	local v14 = React.useMemo(function()
		if state then
			return React.createElement(SquadStartedCard, {
				conversationId = props.conversation_id,
				participantUserIds = state2,
				squadLocation = props.moduleLocation
			})
		end

		return React.createElement(SquadEndedCard, {
			conversationId = props.conversation_id,
			squadLocation = props.moduleLocation
		})
	end, { state, state2, props.conversation_id, props.group_up_id })

	return React.createElement(
		Foundation.View,
		{ AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(0, 280, 0, 0) },
		v14
	)
end

return SquadCard
