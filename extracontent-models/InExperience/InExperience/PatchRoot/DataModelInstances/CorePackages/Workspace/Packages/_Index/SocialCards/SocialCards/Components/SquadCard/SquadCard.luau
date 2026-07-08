local SocialCards = script:FindFirstAncestor("SocialCards")
local SocialCardsParent = SocialCards.Parent
local Cryo = require(SocialCardsParent.Cryo)
local Foundation = require(SocialCardsParent.Foundation)
local Http = require(SocialCardsParent.Http)
local LuauPolyfill = require(SocialCardsParent.LuauPolyfill)
local React = require(SocialCardsParent.React)
local SquadExternalContractProvider = require(SocialCardsParent.SquadsCore.SquadExternalContractProvider)
local useCurrentSquadSelector = require(SocialCardsParent.RoduxSquads).Hooks.useCurrentSquadSelector
local useDispatch = require(SocialCardsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(SocialCardsParent.RobloxAppHooks).useLocalUserId
local useNavigationFocus = require(SocialCardsParent.Navigation).useNavigationFocus
local NetworkingSquads = require(SocialCardsParent.SquadsCore.Http).NetworkingSquads
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadViewFlags = SquadExternalContractProvider.SquadViewFlags
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local SquadStartedCard = require(SocialCards.Components.SquadCard.SquadStartedCard)
local SquadEndedCard = require(SocialCards.Components.SquadCard.SquadEndedCard)

local function SquadCard(t1: {[any]: any}) -- line: 35
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadSelector (copy), Cryo (copy), useNavigationFocus (copy), SquadViewFlags (copy), NetworkingSquads (copy), Http (copy), setInterval (copy), clearInterval (copy), SquadStartedCard (copy), SquadEndedCard (copy), Foundation (copy)
	local v22 = useDispatch()
	local v23 = useLocalUserId()
	local v24 = React.useContext(SquadExternalContractContext)
	local v25 = useCurrentSquadSelector()
	local v26 = not not v25 and v25.squadId == t1.group_up_id
	local v27 = React.useCallback(function(t2: {[any]: any}) -- line: 48
		-- upvalues: v26 (copy), v25 (copy), Cryo (copy), v23 (copy)
		if v26 then
			local t3 = {}

			for _, v in ipairs(v25.members) do
				table.insert(t3, v.userId)
			end

			return t3
		end

		return Cryo.List.filter(t2, function(n1: number) -- line: 56
			-- upvalues: v23 (copy)
			return tostring(n1) ~= v23
		end)
	end, {
		v26,
		v25,
		v23
	})
	local v28, v29 = React.useState(t1.is_alive)
	local v30, v31 = React.useState(v27(t1.participant_user_ids))
	local v32 = useNavigationFocus()
	local v33 = v26 and v32

	React.useEffect(function() -- line: 68
		-- upvalues: v33 (copy), v24 (copy), SquadViewFlags (copy)
		if v33 then
			v24.updateSquadViewFlags(SquadViewFlags.SquadSystemMessage, true)
		end

		return function() -- line: 72
			-- upvalues: v33 (copy), v24 (copy), SquadViewFlags (copy)
			if v33 then
				v24.updateSquadViewFlags(SquadViewFlags.SquadSystemMessage, false)
			end
		end
	end, {
		v24.updateSquadViewFlags,
		v33
	})
	React.useEffect(function() -- line: 79
		-- upvalues: v31 (copy), v27 (copy), t1 (copy)
		v31(v27(t1.participant_user_ids))
	end, {
		v31,
		t1.participant_user_ids,
		v27
	})

	local v34 = React.useCallback(function(s1: string) -- line: 84
		-- upvalues: v22 (copy), NetworkingSquads (copy), v31 (copy), Http (copy), v29 (copy)
		v22(NetworkingSquads.GetSquadFromSquadId.API({
			squadId = s1
		})):andThen(function(p1) -- line: 86
			-- upvalues: v31 (copy)
			if p1 and (p1.responseBody and p1.responseBody.groupUp and p1.responseBody.groupUp.members) then
				local t4 = {}

				for _, v in ipairs(p1.responseBody.groupUp.members) do
					table.insert(t4, v.userId)
				end

				v31(t4)
			end
		end):catch(function(p2) -- line: 100
			-- upvalues: Http (copy), v29 (copy)
			if p2.StatusCode == Http.StatusCodes.NOT_FOUND then
				v29(false)

				return
			end

			warn("Unsupported error type")
		end)
	end, { v22 })

	React.useEffect(function() -- line: 109
		-- upvalues: v28 (copy), v26 (copy), setInterval (copy), v34 (copy), t1 (copy), clearInterval (copy)
		local u41 = nil

		if v28 and not v26 then
			u41 = setInterval(function() -- line: 113
				-- upvalues: v34 (copy), t1 (copy)
				v34(t1.group_up_id)
			end, 10000)
		end

		return function() -- line: 118
			-- upvalues: u41 (ref), clearInterval (copy)
			if u41 then
				clearInterval(u41)
			end
		end
	end, {
		v34,
		v28,
		v26,
		t1.group_up_id
	})

	local v35 = React.useMemo(function() -- line: 125
		-- upvalues: v28 (copy), React (copy), SquadStartedCard (copy), t1 (copy), v30 (copy), SquadEndedCard (copy)
		if v28 then
			return (React.createElement(SquadStartedCard, {
				conversationId = t1.conversation_id,
				participantUserIds = v30,
				squadLocation = t1.moduleLocation
			}))
		end

		return (React.createElement(SquadEndedCard, {
			conversationId = t1.conversation_id,
			squadLocation = t1.moduleLocation
		}))
	end, {
		v28,
		v30,
		t1.conversation_id,
		t1.group_up_id
	})

	return React.createElement(Foundation.View, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(0, 280, 0, 0)
	}, v35)
end

return SquadCard
