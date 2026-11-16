local SocialCards = script:FindFirstAncestor("SocialCards")
local parent = SocialCards.Parent

local Cryo = require(parent.Cryo)

local Foundation = require(parent.Foundation)
local Http = require(parent.Http)
local LuauPolyfill = require(parent.LuauPolyfill)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local RoduxSquads = require(parent.RoduxSquads)
local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus

local Http2 = require(parent.SquadsCore.Http)
local NetworkingSquads = Http2.NetworkingSquads
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadViewFlags = SquadExternalContractProvider.SquadViewFlags

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local SquadStartedCard = require(SocialCards.Components.SquadCard.SquadStartedCard)
local SquadEndedCard = require(SocialCards.Components.SquadCard.SquadEndedCard)

local function SquadCard(props)
	local v = useDispatch()
	local v2 = useLocalUserId()

	local v3 = React.useContext(SquadExternalContractContext)
	local v4 = useCurrentSquadSelector()
	local v5

	if v4 then
		v5 = v4.squadId == props.group_up_id
	else
		v5 = false
	end

	local v6 = React.useCallback(function(p)
		if not v5 then
			return Cryo.List.filter(p, function(p2: number): boolean
				return tostring(p2) ~= v2
			end)
		end

		local userIds = {}

		for _, member in ipairs(v4.members) do
			table.insert(userIds, member.userId)
		end

		return userIds
	end, { v5, v4, v2 })

	local state, setState = React.useState(props.is_alive)
	local state2, setState2 = React.useState(v6(props.participant_user_ids))

	local v7 = useNavigationFocus()
	local v8 = v5 and v7
	React.useEffect(function()
		if v8 then
			v3.updateSquadViewFlags(SquadViewFlags.SquadSystemMessage, true)
		end

		return function()
			if v8 then
				v3.updateSquadViewFlags(SquadViewFlags.SquadSystemMessage, false)
			end
		end
	end, { v3.updateSquadViewFlags, v8 })

	React.useEffect(function()
		setState2(v6(props.participant_user_ids))
	end, { setState2, props.participant_user_ids, v6 })

	local v9 = React.useCallback(function(squadId: string)
		v(NetworkingSquads.GetSquadFromSquadId.API({ squadId = squadId })):andThen(function(p)
			if p and p.responseBody and p.responseBody.groupUp and p.responseBody.groupUp.members then
				local userIds = {}

				for _, member in ipairs(p.responseBody.groupUp.members) do
					table.insert(userIds, member.userId)
				end

				setState2(userIds)
			end
		end):catch(function(p)
			if p.StatusCode == Http.StatusCodes.NOT_FOUND then
				setState(false)
			else
				warn("Unsupported error type")
			end
		end)
	end, { v })

	React.useEffect(function()
		local v10

		if state and not v5 then
			v10 = setInterval(function()
				v9(props.group_up_id)
			end, 10000)
		else
			v10 = nil
		end

		return function()
			if v10 then
				clearInterval(v10)
			end
		end
	end, { v9, state, v5, props.group_up_id })

	local v10 = React.useMemo(function()
		if state then
			return (React.createElement(SquadStartedCard, {
				conversationId = props.conversation_id,
				participantUserIds = state2,
				squadLocation = props.moduleLocation
			}))
		end

		return (React.createElement(SquadEndedCard, {
			conversationId = props.conversation_id,
			squadLocation = props.moduleLocation
		}))
	end, { state, state2, props.conversation_id, props.group_up_id })

	return React.createElement(
		Foundation.View,
		{ AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(0, 280, 0, 0) },
		v10
	)
end

return SquadCard
