local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagAddCommunityDeactivatedToJoinPrompt = SharedFlags.FFlagAddCommunityDeactivatedToJoinPrompt

local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection
local Enums = require(parent.ProfilePlatform.Enums)

local fetchGroupDetails = require(Groups.Common.fetchGroupDetails)
local postJoinGroup = require(Groups.Common.postJoinGroup)
local fetchGroupActions = require(Groups.Common.fetchGroupActions)

local ServiceOverrideContext = require(Groups.Components.CoreUI.ServiceOverrideContext)

require(Groups.Common.Types)
local constants = require(Groups.Common.constants)
local THUMBNAIL_SIZE = constants.THUMBNAIL_SIZE

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

local function buildGroupJoinPromptData(p)
	if not p then
		return nil
	end

	local components = p.components or {}
	local communityProfileHeader = components.CommunityProfileHeader or {}
	local actions = components.Actions or {}

	local v = parseMembershipStatusFromActions(actions)

	local v2 = {
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
	local membersCount

	if communityProfileHeader.counts then
		membersCount = communityProfileHeader.counts.membersCount
	end

	v2.membersCount = membersCount
	v2.isAlreadyMember = v.isAlreadyMember
	v2.hasPendingRequest = v.hasPendingRequest
	v2.isEligible = v.isEligible
	v2.disabledReason = v.disabledReason
	v2.hasSocialModules = communityProfileHeader.hasSocialModules
	return v2
end

return function(p)
	local v = useRoactService(RoactNetworking)

	local v2 = useContext(ServiceOverrideContext)
	local groupService = v2.groupService
	local guiService = v2.guiService

	local v3 = useLocalization({
		notificationJoined = "Feature.Groups.Notification.Joined",
		notificationFollowing = "Feature.Groups.Notification.Following",
		notificationJoinRequestPending = "Feature.Groups.Notification.JoinRequestPending",
		notificationFailedToLoad = "Feature.Groups.Notification.FailedToLoad",
		notificationFailedToJoin = "Feature.Groups.Notification.FailedToJoin",
		notificationFailedToFollow = "Feature.Groups.Notification.FailedToFollow",
		notificationGroupDoesNotExist = "Feature.Groups.Notification.GroupDoesNotExist",
		notificationGroupModerated = "Feature.Groups.Notification.GroupModerated",
		notificationGroupDeactivated = FFlagAddCommunityDeactivatedToJoinPrompt and "Feature.Groups.Notification.GroupDeactivated" or nil
	})

	local ref = React.useRef(nil)

	local function closePrompt() -- 3 equivalent calls inferred from this helper
		ref.current = nil
		p.closePrompt()
	end

	local v4 = React.useCallback(function(p2: number, p3: string, title: string?)
		groupService:PromptJoinCompleted(p2, false, Enum.GroupMembershipStatus.None, p3)

		guiService:SendNotification({ Title = title, Icon = "rbxasset://textures/ui/ErrorIcon.png" })
		closePrompt() -- inferred equivalent call
	end, { groupService, guiService, p.closePrompt })

	local v5 = React.useCallback(function(p2: number, flag: boolean, p3: string, flag2: boolean?)
		local v5

		if flag2 then
			v5 = v3.notificationFailedToLoad
		elseif flag then
			v5 = v3.notificationFailedToJoin
		else
			v5 = v3.notificationFailedToFollow
		end

		v4(p2, p3, v5)
	end, { v4 })

	local v6 = React.useCallback(function(p2: number, p3)
		return function()
			local v6 = not p3 or p3.hasSocialModules == nil or p3.hasSocialModules

			local groupName = p3 and p3.groupName or ""

			postJoinGroup(v, p2):andThen(function()
				return fetchGroupActions(v, p2):andThen(function(p4)
					if p4.errors then
						v5(p2, v6, "Network error on join prompt: Some group components failed to load", false)

						return
					end

					local actions = (p4.components or {}).Actions or {}
					local v7 = parseMembershipStatusFromActions(actions)
					local v8, v9

					if v7.isAlreadyMember then
						v8 = Enum.GroupMembershipStatus.Joined

						if v6 then
							v9 = v3.notificationJoined
						else
							v9 = v3.notificationFollowing
						end
					elseif v7.hasPendingRequest then
						v8 = Enum.GroupMembershipStatus.JoinRequestPending
						v9 = v3.notificationJoinRequestPending
					else
						v5(p2, v6, "Unexpected membership status after join prompt", false)

						return
					end

					groupService:PromptJoinCompleted(p2, true, v8, "")
					closePrompt() -- inferred equivalent call
					guiService:SendNotification({
						Title = string.gsub(v9, "{groupName}", groupName),
						Icon = getRbxthumbWithTypeSizeAndOptions(
							tostring(p2),
							Constants.RbxthumbTypes.GroupIcon,
							THUMBNAIL_SIZE
						)
					})
				end, function(p4)
					v5(p2, v6, "Network error on join prompt: " .. p4.StatusMessage, false)
				end)
			end, function(p4)
				v5(p2, v6, "Network error on join prompt: " .. p4.StatusMessage, false)
			end)
		end
	end, { v, v5, v3, groupService, guiService, p.closePrompt })

	local v7 = React.useCallback(function(p2: number, p3)
		return function()
			local v7 = p3 and p3.isAlreadyMember and true or false
			local v8 = p3 and p3.hasPendingRequest and true or false
			local v9

			if v7 then
				v9 = Enum.GroupMembershipStatus.AlreadyMember
			elseif v8 then
				v9 = Enum.GroupMembershipStatus.JoinRequestPending
			else
				v9 = Enum.GroupMembershipStatus.None
			end

			groupService:PromptJoinCompleted(p2, true, v9, "")
			closePrompt() -- inferred equivalent call
		end
	end, { groupService, p.closePrompt })

	local v8 = React.useCallback(function(p2: number)
		local current = {}
		ref.current = current

		local v8 = { onJoin = v6(p2, nil), onClose = v7(p2, nil) }

		p.openGroupJoinPrompt(p2, nil, v8)

		fetchGroupDetails(v, p2):andThen(function(p3)
			if ref.current ~= current then
				return
			end

			local components = p3.components or {}
			local v9 = next(components) ~= nil
			local v10 = components.CommunityLocked ~= nil
			local v11 = p3.errors ~= nil

			local v12 = FFlagAddCommunityDeactivatedToJoinPrompt and components.CommunityDeactivated ~= nil

			local communityProfileHeader = components.CommunityProfileHeader or {}
			local v13 = communityProfileHeader.hasSocialModules == nil or communityProfileHeader.hasSocialModules

			if v11 then
				if ref.current ~= current then
					return
				end

				v5(p2, v13, "Network error on join prompt: Some group components failed to load", true)
			elseif v9 then
				if v12 then
					if ref.current ~= current then
						return
					end

					v4(p2, "Group is deactivated", v3.notificationGroupDeactivated)
				elseif v10 then
					if ref.current ~= current then
						return
					end

					v4(p2, "Group is currently moderated", v3.notificationGroupModerated)
				else
					if ref.current ~= current then
						return
					end

					local groupJoinPromptData = buildGroupJoinPromptData(p3)

					local v14 = {
						onJoin = v6(p2, groupJoinPromptData),
						onClose = v7(p2, groupJoinPromptData)
					}

					p.openGroupJoinPrompt(p2, groupJoinPromptData, v14)
				end
			else
				if ref.current ~= current then
					return
				end

				v4(p2, "Group does not exist", v3.notificationGroupDoesNotExist)
			end
		end, function(p3)
			if ref.current ~= current then
				return
			end

			v4(p2, "Network error on join prompt: " .. p3.StatusMessage, v3.notificationFailedToLoad)
		end)
	end, { p.openGroupJoinPrompt, v, v3, v6, v7, v4, v5 })

	useEventConnection(groupService.ShowJoinPrompt, v8)

	return React.createElement(React.Fragment, {}, {})
end
