local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)

local parent = Squads.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local cryo = dependencies.Cryo
local foundation = dependencies.Foundation
local roact = dependencies.Roact
local useSelector = dependencies.Hooks.useSelector
local Enums = require(parent.SquadsCore.Enums)
local SquadState = Enums.SquadState
local Hooks = require(parent.SquadsCore.Hooks)
local useSquadState = Hooks.useSquadState

local useTokens = foundation.Hooks.useTokens

require(Squads.Common.ModelTypes)
local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)

local SquadLobbyUserCard = require(script.Parent.SquadLobbyUserCard)
local SquadLobbyUpsellCard = require(script.Parent.SquadLobbyUpsellCard)

local SharedFlags = require(parent.SharedFlags)

local FFlagEnableSquadRegroupExperimentationSmallScreenFix = SharedFlags.FFlagEnableSquadRegroupExperimentationSmallScreenFix

return function(props)
	local v = useTokens()
	local v2 = tonumber(useLocalUserId()) or 0
	local v3 = useSquadState()

	local medium = v.Gap.Medium
	local xLarge = v.Padding.XLarge
	local v4, v5, v6 = React.useMemo(function()
		if props.containerSize.Y == 0 or props.containerSize.X == 0 then
			return Vector2.new(0, 0), 0, 0
		end

		local v4 = props.containerSize.X - xLarge * 2
		local v5 = v4 / props.containerSize.Y

		local v6 = v3 ~= SquadState.Active and 1 or math.max(#cryo.List.filter(props.users, function(p): boolean
			return p.partyStatus ~= SquadUserPartyStatus.Inactive
		end), 2)
		local v7

		if v6 <= 3 and v5 > 1.75 then
			v7 = v6 * 120 + (v6 - 1) * medium <= v4
		else
			v7 = false
		end

		local v8

		if v7 then
			v8 = v6
			v6 = 1
		elseif v6 <= 3 then
			v8 = 1
		else
			v6 = math.ceil(v6 / 2)
			v8 = 2
		end

		local v9 = math.min(v6, (math.clamp(math.floor((props.containerSize.Y + medium) / (120 + medium)), 1, 3)))

		local v10 = (v4 + medium) / v8 - medium
		local v11

		if FFlagEnableSquadRegroupExperimentationSmallScreenFix then
			v11 = math.max(120, props.containerSize.Y + medium) / v9 - medium
		else
			v11 = (props.containerSize.Y + medium) / v9 - medium
		end

		return Vector2.new(v10, v11), v6, v8
	end, { medium, props.containerSize, props.users, xLarge })

	local v7 = useSelector((React.useCallback(function(p)
		return p.Squad.UserBlocking.isBlockedByMe
	end, {})))

	local children = React.useMemo(function()
		if v4.X == 0 or v4.Y == 0 then
			return {}
		end

		local function fn(layoutOrder, user, isConnecting)
			return React.createElement(SquadLobbyUserCard, {
				size = UDim2.fromOffset(v4.X, v4.Y),
				isBlocked = v7[tostring(user.userId)],
				isConnecting = isConnecting,
				layoutOrder = layoutOrder,
				onActivated = props.onUserCardActivated,
				user = user,
				isInExperience = props.isInExperience,
				openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
			})
		end

		local v8 = {}

		for i, user in ipairs(props.users) do
			if user.partyStatus == SquadUserPartyStatus.Inactive then
				continue
			end

			if user.userId == v2 then
				table.insert(v8, fn(0, user, user.partyStatus == SquadUserPartyStatus.Connecting))
			else
				table.insert(v8, fn(i, user, user.partyStatus == SquadUserPartyStatus.Connecting))
			end
		end

		if #v8 == 1 and v3 ~= SquadState.Initializing then
			table.insert(v8, (React.createElement(SquadLobbyUpsellCard, {
				size = UDim2.fromOffset(v4.X, v4.Y),
				layoutOrder = #v8 + 1,
				navigateToHomePage = props.navigateToHomePage,
				navigateToSquadInviteFriends = props.navigateToSquadInviteFriends
			})))
		end

		local children = {}

		for i = 1, v5 do
			local children2 = {}

			for j = 1, v6 do
				local v9 = (i - 1) * v6 + j

				if v8[v9] then
					children2["Card" .. v9] = v8[v9]
				end
			end

			children2.UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, medium)
			})

			children["Row" .. i] = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, v4.Y), BackgroundTransparency = 1, LayoutOrder = i },
				children2
			)
		end

		return children
	end, {
		v4,
		medium,
		v7,
		v2,
		v6,
		v5,
		props.navigateToHomePage,
		props.navigateToSquadInviteFriends,
		props.onUserCardActivated,
		props.openSquadVoiceAbuseReport,
		props.users,
		v3
	})

	children.UIListLayout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, medium)
	})

	children.UIPadding = React.createElement("UIPadding", {
		PaddingBottom = props.paddingBottom,
		PaddingLeft = UDim.new(0, xLarge),
		PaddingRight = UDim.new(0, xLarge)
	})

	return roact.createFragment(children)
end
