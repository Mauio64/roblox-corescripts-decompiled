local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local cryo = dependencies.Cryo
local foundation = dependencies.Foundation
local roact = dependencies.Roact
local useSelector = dependencies.Hooks.useSelector
local squadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadState
local useSquadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useSquadState

local useTokens = foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local SquadUserPartyStatus = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadUserPartyStatus")

local SquadLobbyUserCard = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserCard")
local SquadLobbyUpsellCard = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUpsellCard")

local fFlagEnableSquadRegroupExperimentationSmallScreenFix = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags").FFlagEnableSquadRegroupExperimentationSmallScreenFix

return function(props)
	local v5 = useTokens()
	local v6 = tonumber(useLocalUserId()) or 0
	local v7 = useSquadState()

	local medium = v5.Gap.Medium
	local xLarge = v5.Padding.XLarge
	local v8, v9, v10 = React.useMemo(function()
		if props.containerSize.Y == 0 or props.containerSize.X == 0 then
			return Vector2.new(0, 0), 0, 0
		end

		local v11 = props.containerSize.X - xLarge * 2
		local v12 = v11 / props.containerSize.Y

		local v13 = v7 ~= squadState.Active and 1
			or math.max(#cryo.List.filter(props.users, function(p2): boolean
				return p2.partyStatus ~= SquadUserPartyStatus.Inactive
			end), 2)

		local v14 = v13 <= 3 and v12 > 1.75 and v13 * 120 + (v13 - 1) * medium <= v11
		local v15

		if v14 then
			v15 = v13
			v13 = 1
		elseif v13 <= 3 then
			v15 = 1
		else
			v13 = math.ceil(v13 / 2)
			v15 = 2
		end

		local v16 = math.min(
			v13,
			(math.clamp(math.floor((props.containerSize.Y + medium) / (120 + medium)), 1, 3))
		)

		local v17 = (v11 + medium) / v15 - medium
		local v18

		if fFlagEnableSquadRegroupExperimentationSmallScreenFix then
			v18 = math.max(120, props.containerSize.Y + medium) / v16 - medium
		else
			v18 = (props.containerSize.Y + medium) / v16 - medium
		end

		return Vector2.new(v17, v18), v13, v15
	end, { medium, props.containerSize, props.users, xLarge })

	local v12 = useSelector((React.useCallback(function(p2)
		return p2.Squad.UserBlocking.isBlockedByMe
	end, {})))

	local children = React.useMemo(function()
		if v8.X == 0 or v8.Y == 0 then
			return {}
		end

		local function fn(p2, user, p3)
			return React.createElement(SquadLobbyUserCard, {
				size = UDim2.fromOffset(v8.X, v8.Y),
				isBlocked = v12[tostring(user.userId)],
				isConnecting = p3,
				layoutOrder = p2,
				onActivated = props.onUserCardActivated,
				user = user,
				isInExperience = props.isInExperience,
				openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
			})
		end

		local v13 = {}

		for i, user in ipairs(props.users) do
			if user.partyStatus == SquadUserPartyStatus.Inactive then
				continue
			end

			if user.userId == v6 then
				table.insert(v13, fn(0, user, user.partyStatus == SquadUserPartyStatus.Connecting))
			else
				table.insert(v13, fn(i, user, user.partyStatus == SquadUserPartyStatus.Connecting))
			end
		end

		if #v13 == 1 and v7 ~= squadState.Initializing then
			table.insert(v13, (React.createElement(SquadLobbyUpsellCard, {
				size = UDim2.fromOffset(v8.X, v8.Y),
				layoutOrder = #v13 + 1,
				navigateToHomePage = props.navigateToHomePage,
				navigateToSquadInviteFriends = props.navigateToSquadInviteFriends
			})))
		end

		local children2 = {}

		for i = 1, v9 do
			local children3 = {}

			for j = 1, v10 do
				local v14 = (i - 1) * v10 + j

				if v13[v14] then
					children3["Card" .. v14] = v13[v14]
				end
			end

			children3.UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, medium)
			})

			children2["Row" .. i] = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, v8.Y),
					BackgroundTransparency = 1,
					LayoutOrder = i
				},
				children3
			)
		end

		return children2
	end, {
		v8,
		medium,
		v12,
		v6,
		v10,
		v9,
		props.navigateToHomePage,
		props.navigateToSquadInviteFriends,
		props.onUserCardActivated,
		props.openSquadVoiceAbuseReport,
		props.users,
		v7
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
