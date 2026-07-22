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
local FFlagEnableSquadRegroupExperimentationSmallScreenFix = require(SquadsParent.SharedFlags).FFlagEnableSquadRegroupExperimentationSmallScreenFix

return function(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), useLocalUserId (copy), useSquadState (copy), React (copy), SquadState (copy), Cryo (copy), SquadUserPartyStatus (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy), useSelector (copy), SquadLobbyUserCard (copy), SquadLobbyUpsellCard (copy), Roact (copy)
	local v18 = useTokens()
	local v19 = tonumber(useLocalUserId()) or 0
	local v20 = useSquadState()
	local Medium = v18.Gap.Medium
	local XLarge = v18.Padding.XLarge
	local v23, v24, v25 = React.useMemo(function() -- line: 52
		-- upvalues: t1 (copy), XLarge (copy), v20 (copy), SquadState (copy), Cryo (copy), SquadUserPartyStatus (copy), Medium (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy)
		if t1.containerSize.Y == 0 or t1.containerSize.X == 0 then
			return Vector2.new(0, 0), 0, 0
		end

		local v29 = t1.containerSize.X - XLarge * 2
		local v30 = v29 / t1.containerSize.Y
		local v31 = if v20 == SquadState.Active then math.max(#Cryo.List.filter(t1.users, function(p1) -- line: 64
			-- upvalues: SquadUserPartyStatus (copy)
			return p1.partyStatus ~= SquadUserPartyStatus.Inactive
		end), 2) else 1
		local n1

		if v31 <= 3 and (v30 > 1.75 and v29 >= v31 * 120 + (v31 - 1) * Medium) then
			n1 = 1
		elseif v31 <= 3 then
			n1 = v31
			v31 = 1
		else
			n1 = math.ceil(v31 / 2)
			v31 = 2
		end

		local v33 = math.min(n1, (math.clamp(math.floor((t1.containerSize.Y + Medium) / (120 + Medium)), 1, 3)))
		local v34 = (v29 + Medium) / v31 - Medium
		local v35 = if not FFlagEnableSquadRegroupExperimentationSmallScreenFix then (t1.containerSize.Y + Medium) / v33 - Medium else math.max(120, t1.containerSize.Y + Medium) / v33 - Medium

		return Vector2.new(v34, v35), n1, v31
	end, {
		Medium,
		t1.containerSize,
		t1.users,
		XLarge
	})
	local v26 = React.useCallback(function(p2) -- line: 101
		return p2.Squad.UserBlocking.isBlockedByMe
	end, {})
	local v27 = useSelector(v26)
	local v28 = React.useMemo(function() -- line: 107
		-- upvalues: v23 (copy), React (copy), SquadLobbyUserCard (copy), v27 (copy), t1 (copy), SquadUserPartyStatus (copy), v19 (copy), v20 (copy), SquadState (copy), SquadLobbyUpsellCard (copy), v24 (copy), v25 (copy), Medium (copy)
		if v23.X == 0 or v23.Y == 0 then
			return {}
		end

		local t2 = {}

		local function v38(p3, p4, p5) -- line: 113
			-- upvalues: React (copy), SquadLobbyUserCard (copy), v23 (copy), v27 (copy), t1 (copy)
			return React.createElement(SquadLobbyUserCard, {
				size = UDim2.fromOffset(v23.X, v23.Y),
				isBlocked = v27[tostring(p4.userId)],
				isConnecting = p5,
				layoutOrder = p3,
				onActivated = t1.onUserCardActivated,
				user = p4,
				isInExperience = t1.isInExperience
			})
		end

		for i, v in ipairs(t1.users) do
			if v.partyStatus ~= SquadUserPartyStatus.Inactive then
				if v.userId == v19 then
					table.insert(t2, v38(0, v, v.partyStatus == SquadUserPartyStatus.Connecting))
				else
					table.insert(t2, v38(i, v, v.partyStatus == SquadUserPartyStatus.Connecting))
				end
			end
		end

		if #t2 == 1 and v20 ~= SquadState.Initializing then
			table.insert(t2, (React.createElement(SquadLobbyUpsellCard, {
				size = UDim2.fromOffset(v23.X, v23.Y),
				layoutOrder = #t2 + 1,
				navigateToHomePage = t1.navigateToHomePage,
				navigateToSquadInviteFriends = t1.navigateToSquadInviteFriends
			})))
		end

		local t3 = {}

		for i = 1, v24 do
			local t4 = {}

			for j = 1, v25 do
				local v45 = (i - 1) * v25 + j

				if t2[v45] then
					t4["Card" .. v45] = t2[v45]
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
				Size = UDim2.new(1, 0, 0, v23.Y),
				LayoutOrder = i
			}, t4)
		end

		return t3
	end, {
		v23,
		Medium,
		v27,
		v19,
		v25,
		v24,
		t1.navigateToHomePage,
		t1.navigateToSquadInviteFriends,
		t1.onUserCardActivated,
		t1.users,
		v20
	})

	v28.UIListLayout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, Medium)
	})
	v28.UIPadding = React.createElement("UIPadding", {
		PaddingBottom = t1.paddingBottom,
		PaddingLeft = UDim.new(0, XLarge),
		PaddingRight = UDim.new(0, XLarge)
	})

	return Roact.createFragment(v28)
end
