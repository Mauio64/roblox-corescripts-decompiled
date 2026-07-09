local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local SquadsParent = Squads.Parent
local React = require(SquadsParent.React)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local Cryo = dependencies.Cryo
local Foundation = dependencies.Foundation
local Roact = dependencies.Roact
local useSelector = dependencies.Hooks.useSelector
local SquadState = require(SquadsParent.SquadsCore.Enums).SquadState
local useSquadState = require(SquadsParent.SquadsCore.Hooks).useSquadState
local useTokens = Foundation.Hooks.useTokens

require(Squads.Common.ModelTypes)

local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)
local SquadLobbyUserCard = require(script.Parent.SquadLobbyUserCard)
local SquadLobbyUpsellCard = require(script.Parent.SquadLobbyUpsellCard)
local v16 = game:DefineFastFlag("EmptySquadIdReinviteCheckEnabled", false)
local FFlagEnableSquadRegroupExperimentationSmallScreenFix = require(SquadsParent.SharedFlags).FFlagEnableSquadRegroupExperimentationSmallScreenFix

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: useTokens (copy), useLocalUserId (copy), useSquadState (copy), React (copy), SquadState (copy), v16 (copy), Cryo (copy), SquadUserPartyStatus (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy), useSelector (copy), SquadLobbyUserCard (copy), SquadLobbyUpsellCard (copy), Roact (copy)
	local v19 = useTokens()
	local v20 = tonumber(useLocalUserId()) or 0
	local v21 = useSquadState()
	local Medium = v19.Gap.Medium
	local XLarge = v19.Padding.XLarge
	local v24, v25, v26 = React.useMemo(function() -- line: 53
		-- upvalues: t1 (copy), XLarge (copy), v21 (copy), SquadState (copy), v16 (copy), Cryo (copy), SquadUserPartyStatus (copy), Medium (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy)
		if t1.containerSize.Y == 0 or t1.containerSize.X == 0 then
			return Vector2.new(0, 0), 0, 0
		end

		local v30 = t1.containerSize.X - XLarge * 2
		local v31 = v30 / t1.containerSize.Y
		local v32 = if not (v21 == SquadState.Initializing and not v16) and (not v16 or v21 == SquadState.Active) then math.max(#Cryo.List.filter(t1.users, function(p1) -- line: 66
			-- upvalues: SquadUserPartyStatus (copy)
			return p1.partyStatus ~= SquadUserPartyStatus.Inactive
		end), 2) else 1
		local n1

		if v32 <= 3 and (v31 > 1.75 and v30 >= v32 * 120 + (v32 - 1) * Medium) then
			n1 = 1
		elseif v32 <= 3 then
			n1 = v32
			v32 = 1
		else
			n1 = math.ceil(v32 / 2)
			v32 = 2
		end

		local v34 = math.min(n1, (math.clamp(math.floor((t1.containerSize.Y + Medium) / (120 + Medium)), 1, 3)))
		local v35 = (v30 + Medium) / v32 - Medium
		local v36 = if not FFlagEnableSquadRegroupExperimentationSmallScreenFix then (t1.containerSize.Y + Medium) / v34 - Medium else math.max(120, t1.containerSize.Y + Medium) / v34 - Medium

		return Vector2.new(v35, v36), n1, v32
	end, {
		Medium,
		t1.containerSize,
		t1.users,
		XLarge
	})
	local v27 = React.useCallback(function(p2) -- line: 103
		return p2.Squad.UserBlocking.isBlockedByMe
	end, {})
	local v28 = useSelector(v27)
	local v29 = React.useMemo(function() -- line: 109
		-- upvalues: v24 (copy), React (copy), SquadLobbyUserCard (copy), v28 (copy), t1 (copy), SquadUserPartyStatus (copy), v20 (copy), v21 (copy), SquadState (copy), SquadLobbyUpsellCard (copy), v25 (copy), v26 (copy), Medium (copy)
		if v24.X == 0 or v24.Y == 0 then
			return {}
		end

		local t2 = {}

		local function v39(p3, p4, p5) -- line: 115
			-- upvalues: React (copy), SquadLobbyUserCard (copy), v24 (copy), v28 (copy), t1 (copy)
			return React.createElement(SquadLobbyUserCard, {
				size = UDim2.fromOffset(v24.X, v24.Y),
				isBlocked = v28[tostring(p4.userId)],
				isConnecting = p5,
				layoutOrder = p3,
				onActivated = t1.onUserCardActivated,
				user = p4,
				isInExperience = t1.isInExperience
			})
		end

		for i, v in ipairs(t1.users) do
			if v.partyStatus ~= SquadUserPartyStatus.Inactive then
				if v.userId == v20 then
					table.insert(t2, v39(0, v, v.partyStatus == SquadUserPartyStatus.Connecting))
				else
					table.insert(t2, v39(i, v, v.partyStatus == SquadUserPartyStatus.Connecting))
				end
			end
		end

		if #t2 == 1 and v21 ~= SquadState.Initializing then
			table.insert(t2, (React.createElement(SquadLobbyUpsellCard, {
				size = UDim2.fromOffset(v24.X, v24.Y),
				layoutOrder = #t2 + 1,
				navigateToHomePage = t1.navigateToHomePage,
				navigateToSquadInviteFriends = t1.navigateToSquadInviteFriends
			})))
		end

		local t3 = {}

		for i = 1, v25 do
			local t4 = {}

			for j = 1, v26 do
				local v46 = (i - 1) * v26 + j

				if t2[v46] then
					t4["Card" .. v46] = t2[v46]
				end
			end

			t4.UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, Medium)
			})
			t3["Row" .. i] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v24.Y),
				LayoutOrder = i
			}, t4)
		end

		return t3
	end, {
		v24,
		Medium,
		v28,
		v20,
		v26,
		v25,
		t1.navigateToHomePage,
		t1.navigateToSquadInviteFriends,
		t1.onUserCardActivated,
		t1.users,
		v21
	})

	v29.UIListLayout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, Medium)
	})
	v29.UIPadding = React.createElement("UIPadding", {
		PaddingBottom = t1.paddingBottom,
		PaddingLeft = UDim.new(0, XLarge),
		PaddingRight = UDim.new(0, XLarge)
	})

	return Roact.createFragment(v29)
end
