local Players = game:GetService("Players")

local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local ProfileCard = require(parent.ProfileCard)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local View = Foundation.View

local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagFlyoutSidePanelUseProfileFrameThumbnail = SharedFlags.FFlagFlyoutSidePanelUseProfileFrameThumbnail

local UnibarList = require(InExperienceSideSheet.Components.UnibarList)

local engineFeature = FFlagEnableBlackbirdCheck and game:GetEngineFeature("ReadHasRobloxSubscriptionLua")

local v = engineFeature and { "Name", "DisplayName", "MembershipType", "HasRobloxSubscription" }
	or { "Name", "DisplayName", "MembershipType" }

local function createLocalUserModel(player) -- 3 equivalent calls inferred from this helper
	if player then
		return {
			id = tostring(player.UserId),
			name = player.Name,
			displayName = player.DisplayName,
			membership = player.MembershipType
		}
	end

	return nil
end

local function isRobloxSubscriber(p) -- 3 equivalent calls inferred from this helper
	local v2 = engineFeature

	if v2 then
		if p == nil then
			return false
		end

		return p.HasRobloxSubscription == true
	end

	return v2
end

local function isSameLocalUserModel(data, localUserModel): boolean -- 1 equivalent call inferred from this helper
	if data == nil or localUserModel == nil then
		return data == localUserModel
	end

	return data.id == localUserModel.id
		and data.name == localUserModel.name
		and data.displayName == localUserModel.displayName
		and data.membership == localUserModel.membership
end

local function useLocalUser()
	local state, setState = React.useState(function()
		return createLocalUserModel(Players.LocalPlayer) -- inferred equivalent call
	end)

	local state2, setState2 = React.useState(function()
		return isRobloxSubscriber(Players.LocalPlayer) -- inferred equivalent call
	end)

	React.useEffect(function()
		local connections = {}

		local function listenToPlayer(localPlayer)
			for _, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)

			setState(createLocalUserModel(localPlayer)) -- inferred equivalent call
			setState2(isRobloxSubscriber(localPlayer)) -- inferred equivalent call

			if localPlayer then
				for _, propertyName in v do
					table.insert(connections, localPlayer:GetPropertyChangedSignal(propertyName):Connect(function()
						setState(function(data)
							local localUserModel = createLocalUserModel(localPlayer) -- inferred equivalent call

							if isSameLocalUserModel(data, localUserModel) then -- inferred equivalent call
								return data
							end

							return localUserModel
						end)

						setState2(isRobloxSubscriber(localPlayer)) -- inferred equivalent call
					end))
				end
			end
		end

		local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			listenToPlayer(Players.LocalPlayer)
		end)
		listenToPlayer(Players.LocalPlayer)

		return function()
			localPlayerChangedConnection:Disconnect()

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {})

	return state, state2
end

local function UserProfileRow(p)
	local localUserModel, isRobloxSubscriber2 = useLocalUser()

	local createElement = React.createElement
	local v2 = {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-top-small",
		LayoutOrder = p.layoutOrder,
		testId = "user-profile-row"
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local profileCard = ProfileCard.ProfileCard

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber2 = nil
	end

	return createElement(View, v2, {
		ProfileCardContainer = createElement2(View, { tag = "fill auto-y", LayoutOrder = 0 }, {
			ProfileCard = createElement3(profileCard, {
				layoutOrder = 0,
				localUserModel = localUserModel,
				isRobloxSubscriber = isRobloxSubscriber2,
				isCompact = true,
				useProfileFrameThumbnail = FFlagFlyoutSidePanelUseProfileFrameThumbnail
			})
		}),
		UnibarList = React.createElement(UnibarList, { layoutOrder = 1 })
	})
end

return React.memo(UserProfileRow)
