local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local dependencies = require(ContactList.dependencies)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local UIBlox = dependencies.UIBlox
local RoduxCall = dependencies.RoduxCall
local getStandardSizeAvatarHeadShotRbxthumb = dependencies.getStandardSizeAvatarHeadShotRbxthumb
local teleportToRootPlace = dependencies.teleportToRootPlace
local Colors = UIBlox.App.Style.Colors
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local v26 = LocalPlayer and LocalPlayer.UserId or 0
local t1 = {
	callProtocol = CallProtocol.CallProtocol.default
}

local function formatDuration(n1: number) -- line: 56
	local v32 = math.floor(n1 / 3600)
	local v33 = math.floor(n1 % 3600 / 60)
	local v34 = n1 % 60
	local v35 = string.format("%02d", v32)
	local v36 = string.format("%02d", v33)
	local v37 = string.format("%02d", v34)

	if v32 > 0 then
		return v35 .. ":" .. v36 .. ":" .. v37
	end

	return v36 .. ":" .. v37
end
local function getTextFromCallStatus(s1: string, _: string) -- line: 75
	-- upvalues: RoduxCall (copy)
	if s1 == RoduxCall.Enums.Status.Connecting then
		return "Feature.Call.Label.Calling"
	end

	if s1 == RoduxCall.Enums.Status.Teleporting then
		return "Feature.Call.Label.Teleporting"
	end

	if s1 == RoduxCall.Enums.Status.Active then
		return "Feature.Call.Label.RobloxCall"
	end

	if s1 == RoduxCall.Enums.Status.Idle then
		return "Feature.Call.Label.CallEnded"
	end

	error("Invalid status for call bar: " .. s1 .. ".")
end
local function CallBar(t2: {[any]: any}) -- line: 89
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useAnalytics (copy), React (copy), useSelector (copy), v26 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), useLocalization (copy), RoduxCall (copy), teleportToRootPlace (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), EventNamesEnum (copy), Colors (copy), RunService (copy), formatDuration (copy), UserProfiles (copy), ImageSetLabel (copy)
	local v41 = Cryo.Dictionary.join(t1, t2)
	local v42 = useStyle()
	local v43 = useAnalytics()
	local Theme = v42.Theme
	local Font = v42.Font
	local v46, v47 = React.useState("00:00")
	local v48 = React.useCallback(function(p1) -- line: 98
		if p1.Call.currentCall then
			return p1.Call.currentCall.callId
		end

		return ""
	end)
	local v49 = useSelector(v48)
	local v50 = React.useCallback(function(p2) -- line: 103
		if p2.Call.currentCall then
			return p2.Call.currentCall.callerId
		end

		return ""
	end)
	local v51 = useSelector(v50)
	local v52 = React.useCallback(function(p3) -- line: 108
		if p3.Call.currentCall then
			return p3.Call.currentCall.calleeId
		end

		return ""
	end)
	local v53 = useSelector(v52)
	local v54 = React.useCallback(function(p4) -- line: 113
		if p4.Call.currentCall then
			return p4.Call.currentCall.status
		end

		return ""
	end)
	local v55 = useSelector(v54)
	local v56 = React.useCallback(function(p5) -- line: 118
		if p5.Call.currentCall ~= nil then
			return p5.Call.currentCall.instanceId
		end

		return ""
	end)
	local v57 = useSelector(v56)
	local v58 = React.useCallback(function(p6) -- line: 123
		-- upvalues: v26 (copy)
		local currentCall = p6.Call.currentCall

		if currentCall then
			if v26 == currentCall.callerId then
				return currentCall.calleeId
			end

			return currentCall.callerId
		end

		return nil
	end)
	local v59 = useSelector(v58)
	local v60 = nil

	if v59 then
		v60 = getStandardSizeAvatarHeadShotRbxthumb(v59)
	end

	local v61 = useLocalization
	local t3 = {}
	local s3

	if v55 == RoduxCall.Enums.Status.Connecting then
		s3 = "Feature.Call.Label.Calling"
	elseif v55 == RoduxCall.Enums.Status.Teleporting then
		s3 = "Feature.Call.Label.Teleporting"
	elseif v55 == RoduxCall.Enums.Status.Active then
		s3 = "Feature.Call.Label.RobloxCall"
	elseif v55 == RoduxCall.Enums.Status.Idle then
		s3 = "Feature.Call.Label.CallEnded"
	else
		error("Invalid status for call bar: " .. v55 .. ".")
		s3 = nil
	end

	t3.callStatusLabel = s3

	local callStatusLabel = v61(t3).callStatusLabel
	local v65 = v55 == RoduxCall.Enums.Status.Idle and v57 == game.JobId
	local v66 = v55 == RoduxCall.Enums.Status.Active or (v55 == RoduxCall.Enums.Status.Connecting or (v55 == RoduxCall.Enums.Status.Teleporting or v65))
	local v67 = React.useCallback(function() -- line: 154
		-- upvalues: v65 (copy), teleportToRootPlace (copy), v55 (copy), RoduxCall (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v41 (copy), v49 (copy), v43 (copy), EventNamesEnum (copy), v51 (copy), v53 (copy)
		local v82 = false

		if v65 then
			teleportToRootPlace()
			v82 = true
		elseif v55 == RoduxCall.Enums.Status.Active then
			SoundManager:PlaySound(Sounds.HangUp.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			v41.callProtocol:finishCall(v49)
		elseif v55 == RoduxCall.Enums.Status.Connecting or v55 == RoduxCall.Enums.Status.Teleporting then
			v41.callProtocol:cancelCall(v49)
		end

		v43.fireEvent(EventNamesEnum.CallBarHangUpClicked, {
			eventTimestampMs = os.time() * 1000,
			callerUserId = v51,
			calleeUserId = v53,
			callId = v49,
			callStatus = v55,
			isRetry = v82
		})
	end, {
		v55,
		v41.callProtocol,
		v65
	})
	local v68 = if not v65 then v42.Theme.Alert else v42.Theme.SystemPrimaryDefault
	local v69 = not v65 and "rbxassetid://15239778319" or "rbxassetid://15123605982"
	local v70 = if not v65 then Colors.White else Colors.Slate

	React.useEffect(function() -- line: 180
		-- upvalues: RunService (copy), v41 (copy), formatDuration (copy), v47 (copy)
		local connection = RunService.Heartbeat:Connect(function() -- line: 181
			-- upvalues: v41 (copy), formatDuration (copy), v47 (copy)
			if v41.activeUtc == 0 then
				return
			end

			local v86 = math.max(0, os.time() - v41.activeUtc / 1000)
			local v87 = formatDuration(v86)

			v47(v87)
		end)

		return function() -- line: 194
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v41.activeUtc })

	local v71 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(v59)) },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v72 = React.useCallback(function(p7) -- line: 204
		-- upvalues: v26 (copy)
		local currentCall = p7.Call.currentCall

		if currentCall then
			if v26 == currentCall.callerId then
				return currentCall.calleeCombinedName or ""
			end

			return currentCall.callerCombinedName or ""
		end

		return ""
	end)
	local v73 = useSelector(v72)
	local s4 = ""

	if v71.data then
		s4 = UserProfiles.Selectors.getCombinedNameFromId(v71.data, v59)
	elseif v71.error then
		s4 = v73
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(v41.size.X, v41.size.Y),
		Position = v41.position,
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4)
		}),
		ProfileImage = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromOffset(36, 36),
			Image = v60
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -88, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			DisplayName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 22),
				Font = Font.CaptionHeader.Font,
				Text = s4,
				TextColor3 = Theme.TextEmphasis.Color,
				TextSize = Font.BaseSize * Font.CaptionHeader.RelativeSize,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			DetailsText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				TextTransparency = 0.4,
				Size = UDim2.new(1, 0, 0, 14),
				Font = Font.Footer.Font,
				Text = if v55 ~= RoduxCall.Enums.Status.Active then callStatusLabel else v46,
				TextColor3 = Colors.White,
				TextSize = Font.BaseSize * Font.Footer.RelativeSize,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		}),
		ActionButton = if v55 == RoduxCall.Enums.Status.Failed then nil else React.createElement("ImageButton", {
			Position = UDim2.fromOffset(0, 0),
			Active = v66,
			AnchorPoint = Vector2.new(1, 1),
			LayoutOrder = 3,
			Size = UDim2.fromOffset(36, 36),
			BackgroundTransparency = v68.Transparency,
			BackgroundColor3 = v68.Color,
			BorderSizePixel = 0,
			Image = v69,
			ImageColor3 = v70,
			[React.Event.Activated] = v67
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 36)
			})
		})
	})
end

return CallBar
