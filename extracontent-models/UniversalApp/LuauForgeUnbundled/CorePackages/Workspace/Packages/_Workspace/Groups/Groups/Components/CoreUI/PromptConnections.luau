local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/RoactServiceTags").RoactNetworking

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/ReactUtils")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UserLib")
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = UserLib.Utils.Constants
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization").Hooks.useLocalization
local fFlagAddCommunityDeactivatedToJoinPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagAddCommunityDeactivatedToJoinPrompt

local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/ProfilePlatform/Enums")

local fetchGroupDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/fetchGroupDetails")
local postJoinGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/postJoinGroup")
local fetchGroupActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/fetchGroupActions")

local ServiceOverrideContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/CoreUI/ServiceOverrideContext")

require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local THUMBNAIL_SIZE = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/constants").THUMBNAIL_SIZE

local function parseMembershipStatusFromActions(actions)
	local buttons = actions.buttons or {}
	local kind, disabledReason

	if #buttons > 0 then
		kind = buttons[1].type
		disabledReason = buttons[1].disabledReason
	end

	return {
		isAlreadyMember = (kind == Enums.ProfileActions.ViewCommunity or kind == Enums.ProfileActions.ViewFullProfile) and not disabledReason,
		hasPendingRequest = kind == Enums.ProfileActions.CancelJoinCommunityRequest,
		isEligible = (kind == Enums.ProfileActions.JoinCommunity or kind == Enums.ProfileActions.Follow) and not disabledReason,
		disabledReason = disabledReason
	}
end

local function buildGroupJoinPromptData(p2)
	if not p2 then
		return nil
	end

	local components = p2.components or {}
	local communityProfileHeader = components.CommunityProfileHeader or {}
	local actions = components.Actions or {}

	local v5 = parseMembershipStatusFromActions(actions)

	local v6 = {
		groupName = communityProfileHeader.name,
		isGroupVerified = communityProfileHeader.isVerified,
		ownerName = communityProfileHeader.ownerName,
		ownerIsVerified = communityProfileHeader.ownerIsVerified,
		ownerUserId = communityProfileHeader.ownerUserId,
		membersCount = 0,
		isAlreadyMember = 0,
		hasPendingRequest = 0,
		isEligible = 0,
		disabledReason = 0,
		hasSocialModules = 0
	}
	local v7 = if communityProfileHeader.counts then communityProfileHeader.counts.membersCount else nil
	v6.membersCount = v7
	v6.isAlreadyMember = v5.isAlreadyMember
	v6.hasPendingRequest = v5.hasPendingRequest
	v6.isEligible = v5.isEligible
	v6.disabledReason = v5.disabledReason
	v6.hasSocialModules = communityProfileHeader.hasSocialModules
	return v6
end

return function(p2)
	local v5 = useRoactService(roactNetworking)

	local v6 = useContext(ServiceOverrideContext)
	local groupService = v6.groupService
	local guiService = v6.guiService

	local v7 = useLocalization({
		notificationJoined = "Feature.Groups.Notification.Joined",
		notificationFollowing = "Feature.Groups.Notification.Following",
		notificationJoinRequestPending = "Feature.Groups.Notification.JoinRequestPending",
		notificationFailedToLoad = "Feature.Groups.Notification.FailedToLoad",
		notificationFailedToJoin = "Feature.Groups.Notification.FailedToJoin",
		notificationFailedToFollow = "Feature.Groups.Notification.FailedToFollow",
		notificationGroupDoesNotExist = "Feature.Groups.Notification.GroupDoesNotExist",
		notificationGroupModerated = "Feature.Groups.Notification.GroupModerated",
		notificationGroupDeactivated = fFlagAddCommunityDeactivatedToJoinPrompt and "Feature.Groups.Notification.GroupDeactivated" or nil
	})

	local ref = React.useRef(nil)

	local function closePrompt()
		ref.current = nil
		p2.closePrompt()
	end

	local v8 = React.useCallback(function(p3, p4, p5)
		groupService:PromptJoinCompleted(p3, false, Enum.GroupMembershipStatus.None, p4)

		guiService:SendNotification({
			Title = p5,
			Icon = "rbxasset://textures/ui/ErrorIcon.png"
		})
		ref.current = nil
		p2.closePrompt()
	end, { groupService, guiService, p2.closePrompt })

	local v9 = React.useCallback(function(p3, p4, p5, p6)
		local v10

		if p6 then
			v10 = v7.notificationFailedToLoad
		else
			v10 = if p4 then v7.notificationFailedToJoin else v7.notificationFailedToFollow
		end

		v8(p3, p5, v10)
	end, { v8 })

	local v10 = React.useCallback(function(p3, p4)
		return function()
			local v11 = not p4 or p4.hasSocialModules == nil or p4.hasSocialModules

			local groupName = p4 and p4.groupName or ""

			postJoinGroup(v5, p3):andThen(function()
				return fetchGroupActions(v5, p3):andThen(function(p5)
					if p5.errors then
						v9(
							p3,
							v11,
							"Network error on join prompt: Some group components failed to load",
							false
						)

						return
					end

					local actions = (p5.components or {}).Actions or {}
					local v12 = parseMembershipStatusFromActions(actions)
					local v13, v14

					if v12.isAlreadyMember then
						v13 = Enum.GroupMembershipStatus.Joined

						v14 = if v11 then v7.notificationJoined else v7.notificationFollowing
					elseif v12.hasPendingRequest then
						v13 = Enum.GroupMembershipStatus.JoinRequestPending
						v14 = v7.notificationJoinRequestPending
					else
						v9(p3, v11, "Unexpected membership status after join prompt", false)

						return
					end

					groupService:PromptJoinCompleted(p3, true, v13, "")
					ref.current = nil
					p2.closePrompt()

					guiService:SendNotification({
						Title = string.gsub(v14, "{groupName}", groupName),
						Icon = getRbxthumbWithTypeSizeAndOptions(
							tostring(p3),
							constants.RbxthumbTypes.GroupIcon,
							THUMBNAIL_SIZE
						)
					})
				end, function(p5)
					v9(p3, v11, "Network error on join prompt: " .. p5.StatusMessage, false)
				end)
			end, function(p5)
				v9(p3, v11, "Network error on join prompt: " .. p5.StatusMessage, false)
			end)
		end
	end, { v5, v9, v7, groupService, guiService, p2.closePrompt })

	local v11 = React.useCallback(function(p3, p4)
		return function()
			local v12 = p4 and p4.isAlreadyMember and true or false
			local v13 = p4 and p4.hasPendingRequest and true or false
			local v14

			if v12 then
				v14 = Enum.GroupMembershipStatus.AlreadyMember
			elseif v13 then
				v14 = Enum.GroupMembershipStatus.JoinRequestPending
			else
				v14 = Enum.GroupMembershipStatus.None
			end

			groupService:PromptJoinCompleted(p3, true, v14, "")
			ref.current = nil
			p2.closePrompt()
		end
	end, { groupService, p2.closePrompt })

	local v12 = React.useCallback(function(p3)
		local v13 = {}
		ref.current = v13

		local v14 = { onJoin = v10(p3, nil), onClose = v11(p3, nil) }

		p2.openGroupJoinPrompt(p3, nil, v14)

		fetchGroupDetails(v5, p3):andThen(function(p4)
			if ref.current ~= v13 then
				return
			end

			local components = p4.components or {}
			local v15 = next(components) ~= nil
			local v16 = components.CommunityLocked ~= nil
			local v17 = p4.errors ~= nil

			local v18 = fFlagAddCommunityDeactivatedToJoinPrompt and components.CommunityDeactivated ~= nil

			local communityProfileHeader = components.CommunityProfileHeader or {}
			local v19 = communityProfileHeader.hasSocialModules == nil
				or communityProfileHeader.hasSocialModules

			if v17 then
				if ref.current ~= v13 then
					return
				end

				v9(p3, v19, "Network error on join prompt: Some group components failed to load", true)
			elseif v15 then
				if v18 then
					if ref.current ~= v13 then
						return
					end

					v8(p3, "Group is deactivated", v7.notificationGroupDeactivated)
				elseif v16 then
					if ref.current ~= v13 then
						return
					end

					v8(p3, "Group is currently moderated", v7.notificationGroupModerated)
				else
					if ref.current ~= v13 then
						return
					end

					local groupJoinPromptData = buildGroupJoinPromptData(p4)

					local v20 = {
						onJoin = v10(p3, groupJoinPromptData),
						onClose = v11(p3, groupJoinPromptData)
					}

					p2.openGroupJoinPrompt(p3, groupJoinPromptData, v20)
				end
			else
				if ref.current ~= v13 then
					return
				end

				v8(p3, "Group does not exist", v7.notificationGroupDoesNotExist)
			end
		end, function(p4)
			if ref.current ~= v13 then
				return
			end

			v8(p3, "Network error on join prompt: " .. p4.StatusMessage, v7.notificationFailedToLoad)
		end)
	end, { p2.openGroupJoinPrompt, v5, v7, v10, v11, v8, v9 })

	useEventConnection(groupService.ShowJoinPrompt, v12)

	return React.createElement(React.Fragment, {}, {})
end
