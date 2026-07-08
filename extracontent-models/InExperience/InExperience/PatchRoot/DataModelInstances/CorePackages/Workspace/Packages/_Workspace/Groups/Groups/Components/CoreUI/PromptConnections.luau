local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local useRoactService = require(GroupsParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(GroupsParent.RoactServiceTags).RoactNetworking
local React = require(GroupsParent.React)
local ReactUtils = require(GroupsParent.ReactUtils)
local UserLib = require(GroupsParent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local useLocalization = require(GroupsParent.Localization).Hooks.useLocalization
local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection
local Enums = require(GroupsParent.ProfilePlatform.Enums)
local fetchGroupDetails = require(Groups.Common.fetchGroupDetails)
local postJoinGroup = require(Groups.Common.postJoinGroup)
local fetchGroupActions = require(Groups.Common.fetchGroupActions)
local ServiceOverrideContext = require(Groups.Components.CoreUI.ServiceOverrideContext)

require(Groups.Common.Types)

local THUMBNAIL_SIZE = require(Groups.Common.constants).THUMBNAIL_SIZE

local function parseMembershipStatusFromActions(t1: {[any]: any}) -- line: 39
	-- upvalues: Enums (copy)
	local v22 = t1.buttons or {}
	local type = nil
	local disabledReason = nil

	if #v22 > 0 then
		type = v22[1].type
		disabledReason = v22[1].disabledReason
	end

	local v25 = type == Enums.ProfileActions.ViewCommunity or type == Enums.ProfileActions.ViewFullProfile
	local v26 = type == Enums.ProfileActions.CancelJoinCommunityRequest
	local v27 = type == Enums.ProfileActions.JoinCommunity or type == Enums.ProfileActions.Follow
	local v28 = v25 and not disabledReason
	local v29 = v27 and not disabledReason

	return {
		isAlreadyMember = v28,
		hasPendingRequest = v26,
		isEligible = v29,
		disabledReason = disabledReason
	}
end
local function buildGroupJoinPromptData(t2: {[any]: any}?) -- line: 72
	-- upvalues: parseMembershipStatusFromActions (copy)
	if not t2 then
		return nil
	end

	local v31 = t2.components or {}
	local v32 = v31.CommunityProfileHeader or {}
	local v33 = v31.Actions or {}
	local v34 = parseMembershipStatusFromActions(v33)

	return {
		groupName = v32.name,
		isGroupVerified = v32.isVerified,
		ownerName = v32.ownerName,
		ownerIsVerified = v32.ownerIsVerified,
		ownerUserId = v32.ownerUserId,
		membersCount = if not v32.counts then nil else v32.counts.membersCount,
		isAlreadyMember = v34.isAlreadyMember,
		hasPendingRequest = v34.hasPendingRequest,
		isEligible = v34.isEligible,
		disabledReason = v34.disabledReason,
		hasSocialModules = v32.hasSocialModules
	}
end

return function(t3: {[any]: any}) -- line: 98
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useContext (copy), ServiceOverrideContext (copy), useLocalization (copy), React (copy), postJoinGroup (copy), fetchGroupActions (copy), parseMembershipStatusFromActions (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), THUMBNAIL_SIZE (copy), fetchGroupDetails (copy), buildGroupJoinPromptData (copy), useEventConnection (copy)
	local v36 = useRoactService(RoactNetworking)
	local v37 = useContext(ServiceOverrideContext)
	local groupService = v37.groupService
	local guiService = v37.guiService
	local v40 = useLocalization({
		notificationJoined = "Feature.Groups.Notification.Joined",
		notificationFollowing = "Feature.Groups.Notification.Following",
		notificationJoinRequestPending = "Feature.Groups.Notification.JoinRequestPending",
		notificationFailedToLoad = "Feature.Groups.Notification.FailedToLoad",
		notificationFailedToJoin = "Feature.Groups.Notification.FailedToJoin",
		notificationFailedToFollow = "Feature.Groups.Notification.FailedToFollow",
		notificationGroupDoesNotExist = "Feature.Groups.Notification.GroupDoesNotExist",
		notificationGroupModerated = "Feature.Groups.Notification.GroupModerated"
	})
	local v41 = React.useRef(nil)

	local function closePrompt() -- line: 122
		-- upvalues: v41 (copy), t3 (copy)
		v41.current = nil
		t3.closePrompt()
	end

	local v43 = React.useCallback(function(n1: number, s1: string, s2: string?) -- line: 129
		-- upvalues: groupService (copy), guiService (copy), v41 (copy), t3 (copy)
		groupService:PromptJoinCompleted(n1, false, Enum.GroupMembershipStatus.None, s1)
		guiService:SendNotification({
			Icon = "rbxasset://textures/ui/ErrorIcon.png",
			Title = s2
		})
		v41.current = nil
		t3.closePrompt()
	end, {
		groupService,
		guiService,
		t3.closePrompt
	})
	local v44 = React.useCallback(function(n2: number, b1: boolean, s3: string, b2: boolean?) -- line: 147
		-- upvalues: v40 (copy), v43 (copy)
		local v55 = if not b2 then if not b1 then v40.notificationFailedToFollow else v40.notificationFailedToJoin else v40.notificationFailedToLoad

		v43(n2, s3, v55)
	end, { v43 })
	local v45 = React.useCallback(function(n3: number, p1) -- line: 162
		-- upvalues: postJoinGroup (copy), v36 (copy), fetchGroupActions (copy), v44 (copy), parseMembershipStatusFromActions (copy), v40 (copy), groupService (copy), v41 (copy), t3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), THUMBNAIL_SIZE (copy), guiService (copy)
		return function() -- line: 163
			-- upvalues: p1 (copy), postJoinGroup (copy), v36 (copy), n3 (copy), fetchGroupActions (copy), v44 (copy), parseMembershipStatusFromActions (copy), v40 (copy), groupService (copy), v41 (copy), t3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), THUMBNAIL_SIZE (copy), guiService (copy)
			local v63 = not p1 or (p1.hasSocialModules == nil or p1.hasSocialModules)
			local v64 = not p1 and "" or (p1.groupName or "")

			postJoinGroup(v36, n3):andThen(function() -- line: 171
				-- upvalues: fetchGroupActions (copy), v36 (copy), n3 (copy), v44 (copy), v63 (copy), parseMembershipStatusFromActions (copy), v40 (copy), groupService (copy), v41 (copy), t3 (copy), v64 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), THUMBNAIL_SIZE (copy), guiService (copy)
				return fetchGroupActions(v36, n3):andThen(function(p2) -- line: 172
					-- upvalues: v44 (copy), n3 (copy), v63 (copy), parseMembershipStatusFromActions (copy), v40 (copy), groupService (copy), v41 (copy), t3 (copy), v64 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), THUMBNAIL_SIZE (copy), guiService (copy)
					if p2.errors then
						v44(n3, v63, "Network error on join prompt: Some group components failed to load", false)

						return
					end

					local v80 = (p2.components or {}).Actions or {}
					local v81 = parseMembershipStatusFromActions(v80)
					local Joined, v83

					if v81.isAlreadyMember then
						Joined = Enum.GroupMembershipStatus.Joined
						v83 = if not v63 then v40.notificationFollowing else v40.notificationJoined
					else
						if not v81.hasPendingRequest then
							v44(n3, v63, "Unexpected membership status after join prompt", false)

							return
						end

						Joined = Enum.GroupMembershipStatus.JoinRequestPending
						v83 = v40.notificationJoinRequestPending
					end

					groupService:PromptJoinCompleted(n3, true, Joined, "")
					v41.current = nil
					t3.closePrompt()

					local v84 = string.gsub(v83, "{groupName}", v64)
					local v85 = getRbxthumbWithTypeSizeAndOptions(tostring(n3), Constants.RbxthumbTypes.GroupIcon, THUMBNAIL_SIZE)

					guiService:SendNotification({
						Title = v84,
						Icon = v85
					})
				end, function(p3) -- line: 226
					-- upvalues: v44 (copy), n3 (copy), v63 (copy)
					v44(n3, v63, "Network error on join prompt: " .. p3.StatusMessage, false)
				end)
			end, function(p4) -- line: 234
				-- upvalues: v44 (copy), n3 (copy), v63 (copy)
				v44(n3, v63, "Network error on join prompt: " .. p4.StatusMessage, false)
			end)
		end
	end, {
		v36,
		v44,
		v40,
		groupService,
		guiService,
		t3.closePrompt
	})
	local v46 = React.useCallback(function(n4: number, p5) -- line: 246
		-- upvalues: groupService (copy), v41 (copy), t3 (copy)
		return function() -- line: 247
			-- upvalues: p5 (copy), groupService (copy), n4 (copy), v41 (copy), t3 (copy)
			local v65 = not not p5 and not not p5.isAlreadyMember
			local v66 = not not p5 and not not p5.hasPendingRequest
			local v67 = if not v65 then if not v66 then Enum.GroupMembershipStatus.None else Enum.GroupMembershipStatus.JoinRequestPending else Enum.GroupMembershipStatus.AlreadyMember

			groupService:PromptJoinCompleted(n4, true, v67, "")
			v41.current = nil
			t3.closePrompt()
		end
	end, {
		groupService,
		t3.closePrompt
	})
	local v47 = React.useCallback(function(n5: number) -- line: 275
		-- upvalues: v41 (copy), v45 (copy), v46 (copy), t3 (copy), fetchGroupDetails (copy), v36 (copy), v44 (copy), v43 (copy), v40 (copy), buildGroupJoinPromptData (copy)
		local t4 = {}

		v41.current = t4

		local t5 = {
			onJoin = v45(n5, nil),
			onClose = v46(n5, nil)
		}

		t3.openGroupJoinPrompt(n5, nil, t5)
		fetchGroupDetails(v36, n5):andThen(function(p6) -- line: 291
			-- upvalues: v41 (copy), t4 (copy), v44 (copy), n5 (copy), v43 (copy), v40 (copy), buildGroupJoinPromptData (copy), v45 (copy), v46 (copy), t3 (copy)
			if v41.current ~= t4 then
				return
			end

			local v69 = p6.components or {}
			local v70 = next(v69) ~= nil
			local v71 = v69.CommunityLocked ~= nil
			local v72 = p6.errors ~= nil
			local v73 = v69.CommunityProfileHeader or {}
			local v74 = v73.hasSocialModules == nil or v73.hasSocialModules

			if v72 then
				if v41.current ~= t4 then
					return
				end

				v44(n5, v74, "Network error on join prompt: Some group components failed to load", true)

				return
			end

			if not v70 then
				if v41.current ~= t4 then
					return
				end

				v43(n5, "Group does not exist", v40.notificationGroupDoesNotExist)

				return
			end

			if v71 then
				if v41.current ~= t4 then
					return
				end

				v43(n5, "Group is currently moderated", v40.notificationGroupModerated)

				return
			end

			if v41.current ~= t4 then
				return
			end

			local v75 = buildGroupJoinPromptData(p6)
			local t6 = {
				onJoin = v45(n5, v75),
				onClose = v46(n5, v75)
			}

			t3.openGroupJoinPrompt(n5, v75, t6)
		end, function(p7) -- line: 341
			-- upvalues: v41 (copy), t4 (copy), v43 (copy), n5 (copy), v40 (copy)
			if v41.current ~= t4 then
				return
			end

			v43(n5, "Network error on join prompt: " .. p7.StatusMessage, v40.notificationFailedToLoad)
		end)
	end, {
		t3.openGroupJoinPrompt,
		v36,
		v40,
		v45,
		v46,
		v43,
		v44
	})

	useEventConnection(groupService.ShowJoinPrompt, v47)

	return React.createElement(React.Fragment, {}, {})
end
